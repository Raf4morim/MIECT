import crypto from 'crypto';
import { AuthenticationError } from 'apollo-server-errors';
import { connectToApiKeys } from './database/db.js';

// Middleware to validate API keys
const authenticateWithApiKey = async (resolve, parent, args, context, info) => {
  //console.log('Authenticating with API key...', context);
  const apiKey = context.apiKey; // Extract API key from context

  // Proceed with API key validation for other resolvers
  const validApiKey = await validateApiKey(apiKey); // Validate API key (e.g., check against database)
  
  if (!validApiKey) {
    throw new AuthenticationError('Invalid API key');
  }
};

// Function to validate API key
const validateApiKey = async (apiKey) => {
  const collection = await connectToApiKeys();
  
  const result = await collection.findOne({
    apiKey: apiKey
  });
  
  return result ? true : false;
};


// Function to generate API key
const generateApiKey = (clientName) => {


  const apiKey = crypto.randomBytes(16).toString('hex');

  // Associate the API key with the client name
  const apiKeyWithClient = `${clientName}:${apiKey}`;

  return apiKeyWithClient;
};

export { authenticateWithApiKey, generateApiKey };
