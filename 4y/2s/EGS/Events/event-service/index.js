import dotenv from 'dotenv';
import path from 'path';
import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

// Load environment variables
const loadEnvVariables = async () => {
  try {
    dotenv.config({ path: path.resolve(process.cwd(), './.env') });
  } catch (error) {
    throw error;
  }
};

// Configure the server
const configServer = async () => {
  const config = (await import('./config/config.js')).default;
  const dbConnection = (await import('./database/connection.js')).default;
  const routerEvents = (await import('./routes/events.js')).default;
  const routerFiles = (await import('./routes/files.js')).default;
  const routerKeys = (await import('./routes/keys.js')).default;
  const swaggerUI = (await import('swagger-ui-express')).default;
  const swaggerSpec = (await import('./swagger.js')).default;

  // Create a new instance of the express server
  const app = express();
  const port = config.server.port;

  // Use middleware
  app.use(bodyParser.json());
  app.use(cors());

  // Use swagger route
  app.use('/e1/docs', swaggerUI.serve, swaggerUI.setup(swaggerSpec));

  // Use service routes
  app.use('/e1', routerKeys, routerEvents, routerFiles);

  // Default 404 route
  app.use((req, res) => {
    res.status(404).json({
      error: {
        code: '404',
        message: 'Not Found',
        details: 'The requested resource does not exist',
      }
    });
  });

  // Handle process initialization
  try {
    console.log('Connecting to the database...');
    await dbConnection.connect();
    console.log('Database connection has been successfully established!');
    console.log('Starting server...');
    var listener = app.listen(port, '0.0.0.0', () => {
      console.log('Server listening at ' + listener.address().address +  `:${port}`);
    });
  } catch (error) {
    throw error;
  }

  // Handle process termination
  process.once('SIGINT', async () => {
    console.log('Closing database connection...');
    await dbConnection.disconnect();
    console.log('Database connection has been successfully closed!')
    console.log('Server has been stopped');
    process.exit(0);
  });
};

// Start the server
try {
  await loadEnvVariables();
  await configServer();
}
catch (error) {
  console.log('----------------------------------------------------------------------------------\nAN ERROR OCCURRED WHILE STARTING THE SERVER:\n----------------------------------------------------------------------------------')
  console.error(error);
}
