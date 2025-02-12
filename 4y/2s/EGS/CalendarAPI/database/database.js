require('dotenv').config(); 
const mysql = require('mysql2/promise');


let pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  port: '3306'
});

const connect = async () => {
  const maxRetries = 5;
  const baseDelay = 2000; // Base delay in ms
  console.log(`Connecting to MySQL at host ${process.env.DB_HOST}`);

  for (let i = 0; i < maxRetries; i++) {
    try {
      console.log('Attempting to connect to MySQL...');
      const connection = await pool.getConnection();
      console.log('MySQL connection successful.');
      connection.release();
      break; // Exit the loop if the connection is successful
    } catch (error) {
      console.error(`Error connecting to MySQL on attempt ${i + 1}:`, error);
      if (i === maxRetries - 1) {
        throw new Error('Failed to connect to MySQL after multiple retries.');
      }
      const delay = baseDelay * Math.pow(2, i); // Exponential backoff
      console.log(`Retrying connection after ${delay}ms...`);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
};


const disconnect = async () => {
  if (pool) {
    await pool.end();
    console.log('MySQL pool has been closed.');
  }
};

// Getter for the pool, ensures you're always using the initialized pool
const getPool = () => {
  if (!pool) {
    throw new Error("Database pool has not been initialized. Call 'connect()' first.");
  }
  return pool;
};

module.exports = { connect, disconnect, getPool };
