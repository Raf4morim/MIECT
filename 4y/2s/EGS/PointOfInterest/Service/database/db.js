import { MongoClient } from 'mongodb';
import dotenv from 'dotenv';
dotenv.config();

// Define MongoDB connection URI and database/collection names
const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017'; 
const dbName = process.env.DB_NAME || 'poi_database'; 
const mainCollection = process.env.COLLECTION_NAME || 'POIs';
const apiKeysCollection = process.env.COLLECTION_APIKEYS || 'apiKeys';

let client = null;

// Function to connect to MongoDB
async function connect() {
  client = new MongoClient(uri);
  await client.connect();
  return client.db(dbName).collection(mainCollection);
}

async function connectToApiKeys() {
  client = new MongoClient(uri);
  await client.connect();
  return client.db(dbName).collection(apiKeysCollection);
}

async function closeConnection() {
  await client.close();
}


export { connect, connectToApiKeys, closeConnection };
