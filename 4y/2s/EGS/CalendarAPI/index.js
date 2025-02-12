require('dotenv').config();
const crypto = require('crypto');
const express = require('express');
const { google } = require('googleapis');
const db = require('./database/database');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const swaggerDocument = YAML.load('api-docs.yml');
const cors = require('cors');
const bcrypt = require('bcrypt');
const moment = require('moment'); 
const { findOrCreateUser } = require('./userManagement.js');

const corsOptions = {
  origin: '*', // Allow all origins
  optionsSuccessStatus: 200 
};


const {OAuth2} = google.auth;

const app = express();

app.use(express.static(__dirname + '/public'));

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));
//app.use(cors(corsOptions));
app.use(cors());
app.use(express.json());

// // At application start
db.connect().catch(err => {
  console.error('Failed to connect to the database:', err);
  process.exit(1); // Exit the app if the database connection fails
});



//identifies my application to Google's OAuth 2.0 server.
// allow my  application to authenticate users using Google's OAuth 2.0 server. 
const oauth2Client = new OAuth2(
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_CLIENT_SECRET,
  process.env.CALLBACK_URL
);

// retrieving user information from Google's OAuth 2.0 server using the provided access token
//OAuth 2.0 client is trying to access the user's info
//The user interacts with the OAuth 2.0 client by providing their credentials (such as username and password) 
//and granting permission to the client to access their resources.
async function fetchUserInfo(accessToken) {
  const oauth2Client = new google.auth.OAuth2(
      process.env.GOOGLE_CLIENT_ID,
      process.env.GOOGLE_CLIENT_SECRET,
      process.env.CALLBACK_URL
  );

  oauth2Client.setCredentials({
      access_token: accessToken,
  });

  const oauth2 = google.oauth2({
      auth: oauth2Client,
      version: 'v2',
  });

  try {
      const userInfoResponse = await oauth2.userinfo.get();
      return userInfoResponse.data; 
  } catch (error) {
      console.error('Error fetching user information:', error);
      throw error; 
  }
}


app.post('/generate-api-key', async (req, res) => {
  const { clientName, password } = req.body;

  if (!clientName || !password) {
    return res.status(400).send('Client name and password are required');
  }

  try {
    const pool = db.getPool();
    const [existingClient] = await pool.query('SELECT * FROM api_keys WHERE username = ?', [clientName]);
    if (existingClient.length > 0) {
      return res.status(409).send('Client already exists.');
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const apiKey = crypto.randomBytes(30).toString('hex');

    await pool.query('INSERT INTO api_keys (username, password, api_key) VALUES (?, ?, ?)', [clientName, hashedPassword, apiKey]);
    
    
    res.status(201).send({ message: 'Client registered successfully', apiKey: apiKey });

  } catch (error) {
    console.error('Registration failed:', error);
    res.status(500).send('Failed to register client');
  }
});



app.post('/retrieve-api-key', async (req, res) => {
  const { clientName, password } = req.body;

  if (!clientName || !password) {
    return res.status(400).send('Client name and password are required');
  }

  try {
    const pool = db.getPool();
    // Buscar o cliente pelo nome
    const [clients] = await pool.query('SELECT * FROM api_keys WHERE username = ?', [clientName]);
    if (clients.length === 0) {
      return res.status(404).send('Client not found');
    }

    const client = clients[0]; 

    const isValid = await bcrypt.compare(password, client.password); 
    if (!isValid) {
      return res.status(401).send('Invalid credentials');
    }

    // Se a senha for correta, retornar a chave de API
    res.status(200).send({ apiKey: client.api_key })
  } catch (error) {
    console.error('Failed to retrieve API key:', error);
    res.status(500).send('Failed to retrieve API key');
  }
});



const apiKeyMiddleware = async (req, res, next) => {
  const apiKey = req.headers['x-api-key'];

  if (!apiKey) {
      return res.status(401).json({ message: 'API Key is required' });
  }

  try {
      const pool = db.getPool();
      const [apiKeys] = await pool.query('SELECT api_key FROM api_keys WHERE api_key = ?', [apiKey]);
      
      if (apiKeys.length === 0) {
          return res.status(401).json({ message: 'Invalid API Key' });
      }

      next();
  } catch (error) {
      console.error('API Key validation failed:', error);
      res.status(500).send('Failed to validate API Key');
  }
};



const { v4: uuidv4 } = require('uuid');

app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const pool = db.getPool();
    const [users] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    //palavra pass errada
    if (users.length > 0) {
      if (users[0].name !== password) {
        return res.status(401).send('Invalid username or password');
      }

      const userId = users[0].id;
      const [existingCalendars] = await pool.query('SELECT * FROM calendars WHERE userId = ?', [userId]);
      let calendarId = existingCalendars.length ? existingCalendars[0].id : null;

      //first time login
      if (!calendarId) {
        const [calendarResult] = await pool.query('INSERT INTO calendars (userId, name) VALUES (?, ?)', [userId, 'Default Calendar']);
        calendarId = calendarResult.insertId;
      }

      res.send({ userId, calendarId });
    } 
    else {
      const googleId = uuidv4(); // Gerar um UUID único
      const [userResult] = await pool.query('INSERT INTO users (email, name, google_id) VALUES (?, ?, ?)', [email, password, googleId]);
      const userId = userResult.insertId;
      const [calendarResult] = await pool.query('INSERT INTO calendars (userId, name) VALUES (?, ?)', [userId, 'Default Calendar']);
      const calendarId = calendarResult.insertId;

      res.status(201).json({
        message: "Login successfully",
        userId: userId,
        calendarId: calendarId
      });
    }
  } catch (error) {
    console.error('Error processing login or registration:', error);
    res.status(500).send('Internal Server Error');
  }
});



//Create a new calendar for the user
app.post('/calendars/users/:userId/', apiKeyMiddleware, async (req, res) => {
  const userId = req.params.userId;

  try {
    const pool = db.getPool();

    // Check if the user already has a calendar
    const [existingCalendars] = await pool.query('SELECT * FROM calendars WHERE userId = ?', [userId]);

    if (existingCalendars.length > 0) {
      // If a calendar exists, return the existing calendar ID
      return res.status(200).json({
        message: "User already has a calendar.",
        calendarId: existingCalendars[0].id  
      });
    }

    // If no calendar exists, proceed to create a new one
    const [insertResult] = await pool.query('INSERT INTO calendars (userId) VALUES (?)', [userId]);

    const calendarId = insertResult.insertId;

    res.status(201).json({
      message: "Calendar created successfully",
      calendarId: calendarId,
    });

  } catch (error) {
    console.error('Failed to create calendar:', error);
    res.status(500).send('Failed to create calendar');
  }
});





// Insere um novo evento no calendário 
app.post('/calendars/events/:calendarId/', apiKeyMiddleware, async (req, res) => {
  const { calendarId } = req.params;
  const { eventId, summary, location, description, start, end, timeZone, obs } = req.body;

  try {
    const pool = db.getPool();

    // Check if the provided event ID already exists in the same calendar
    const checkId = await pool.query('SELECT id FROM events WHERE id = ? AND calendarId = ?', [eventId, calendarId]);
    if (checkId[0].length > 0) {
      return res.status(409).json({ message: "Event ID already exists in this calendar" });
    }

    const formatStart = moment(start).format('YYYY-MM-DD HH:mm:ss');
    const formatEnd = moment(end).format('YYYY-MM-DD HH:mm:ss');

    const query = 'INSERT INTO events (id, calendarId, summary, location, description, startDateTime, endDateTime, timeZone, obs) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
    const values = [eventId, calendarId, summary, location, description, formatStart, formatEnd, timeZone, obs || null];

    await pool.query(query, values);
    res.status(201).json({ message: "Event added successfully", eventId: eventId });
  } catch (error) {
    console.error('Error processing request:', error);
    res.status(500).send('Failed to process request');
  }
});



function normalizeString(input) {
  return input.toLowerCase().replace(/[\s,]+/g, ''); 
}

app.get('/calendars/:calendarId/', apiKeyMiddleware, async (req, res) => {
  const { calendarId } = req.params;
  let { startDate, beforeDate, afterDate, location, eventId } = req.query;

  try {
    const pool = db.getPool();
    let query = 'SELECT id AS eventId, summary, location, description, DATE_FORMAT(startDateTime, "%Y-%m-%d %H:%i:%s") AS startDateTime, DATE_FORMAT(endDateTime, "%Y-%m-%d %H:%i:%s") AS endDateTime FROM events WHERE calendarId = ?';
    const queryParams = [calendarId];

    if (eventId) {
      query += ' AND id = ?';
      queryParams.push(eventId);
    }

    if (startDate) {
      const formattedStartDate = moment(startDate).format('YYYY-MM-DD HH:mm:ss');
      query += ' AND startDateTime = ?';
      queryParams.push(formattedStartDate);
    }
    if (beforeDate) {
      const formattedBeforeDate = moment(beforeDate).format('YYYY-MM-DD HH:mm:ss');
      query += ' AND endDateTime <= ?';
      queryParams.push(formattedBeforeDate);
    }
    if (afterDate) {
      const formattedAfterDate = moment(afterDate).format('YYYY-MM-DD HH:mm:ss');
      query += ' AND startDateTime >= ?';
      queryParams.push(formattedAfterDate);
    }
    if (location) {
      location = normalizeString(location); 
      query += ' AND REPLACE(LOWER(location), " ", "") = ?';
      queryParams.push(location);
    }

    const [events] = await pool.query(query, queryParams);

    if (events.length === 0) {
      return res.status(404).send('No events found matching the criteria.');
    }

    res.status(200).json(events);

    //res.json(events);
  } catch (error) {
    console.error('Failed to retrieve events:', error);
    res.status(500).send('Failed to retrieve events');
  }
});





// Updates an existing event in the user's calendar
app.patch('/calendars/:calendarId/:eventId', apiKeyMiddleware, async (req, res) => {
  const { calendarId, eventId } = req.params;  // Extract both calendarId and eventId from URL
  const { summary, location, description, start, end, timeZone } = req.body;

  try {
    const pool = db.getPool();
    const formattedStart = moment(start).format('YYYY-MM-DD HH:mm:ss');
    const formattedEnd = moment(end).format('YYYY-MM-DD HH:mm:ss');

    // Prepare SQL query conditions and parameters
    let condition = 'id = ? AND calendarId = ?';
    let parameters = [eventId, calendarId]; 

    // Check if the event exists in the user's calendar
    const [eventResult] = await pool.query(`SELECT id FROM events WHERE ${condition}`, parameters);
    if (eventResult.length === 0) {
      return res.status(404).send(`Event not found in the user's calendar.`);
    }

    const updateParameters = [summary, location, description, formattedStart, formattedEnd, timeZone, ...parameters];
    await pool.query(
      `UPDATE events SET summary = ?, location = ?, description = ?, startDateTime = ?, endDateTime = ?, timeZone = ? WHERE ${condition}`,
      updateParameters
    );
    
    return res.status(201).send({ message: "Event updated successfully", updatedEventId: eventId });

  } 
  catch (error) {
    console.error('Error processing request:', error);
    res.status(500).send('Failed to process request');
  }
});


// Deletes an existing event from the user's calendar
app.delete('/calendars/:calendarId/:eventId', apiKeyMiddleware, async (req, res) => {
  const { calendarId, eventId } = req.params; // Extracting eventId and calendarId from the URL

  try {
    const pool = db.getPool();

    const query = 'DELETE FROM events WHERE id = ? AND calendarId = ?';
    const values = [eventId, calendarId];
    const [result] = await pool.query(query, values);

    if (result.affectedRows === 0) {
      return res.status(404).send('Event not found in the calendar.');
    }
    
    return res.status(200).send({ message: "Event deleted successfully", eventId: eventId });

  } 
  catch (error) {
    console.error('Error processing request:', error);
    res.status(500).send('Failed to process request');
  }
});


app.get('/', (req, res) => {
  res.send('Welcome to the Calendar App!');
});


const port = process.env.PORT;

var listener = app.listen(port, '0.0.0.0', () => {

  console.log(`API listening at http://localhost:${port}` + listener.address().address); 
});
