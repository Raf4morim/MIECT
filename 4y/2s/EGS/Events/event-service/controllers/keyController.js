import mongoose from 'mongoose';
import crypto from 'crypto';
import { v4 as uuidv4 } from 'uuid';
import config from '../config/config.js';
import logger from '../logger.js';
import dbConnection from '../database/connection.js';
import dbOperation from '../database/operations.js';
import ApiKey from '../models/key.js';

// Generate a new key
const generateKey = async (req, res) => {
    try {
        // Generate a new key and hash it using api secret 
        const key = uuidv4();
        const hashedKey = crypto.createHash('sha256').update(key + config.server.secret).digest('hex');
        const app_id = 'app_id_' + uuidv4();
        const apiKey = {
            _id: hashedKey,
            appid: app_id,
        };

        // Open a new database connection if it is not already open
        if (mongoose.connection.readyState === 0) {
            await dbConnection.connect();
        }

        // Create a new apiKey in the database
        await dbOperation.createDocument(ApiKey, apiKey);

        // Return the status code and an informative message
        return res.status(201).json({
            success: {
                code: '201',
                message: 'Created',
                details: 'This will be the only time this key is shown. You will need it to authenticate yourself when making requests. Store it securely. If lost, a new key must be generated',
                key: key,
                appid: app_id
            }
        });

    } catch (error) {
        const msg = {
            messageID: req.logID,
            messageType: error.code,
            message: error.stack,
        }
        logger.logError.error(msg); // Write to error log file
        return res.status(500).json({
            error: {
                code: '500',
                message: 'Internal Server Error',
                details: 'An unexpected error has occurred. Please try again later'
            }
        });
    }
};

// Revoke the provided key 
const revokeKey = async (req, res) => {
    try {
        // Generate the hashed key using the provided key and the api secret
        const key = req.headers['service-api-key']
        const hashedKey = crypto.createHash('sha256').update(key + config.server.secret).digest('hex');

        // Open a new database connection if it is not already open
        if (mongoose.connection.readyState === 0) {
            await dbConnection.connect();
        }

        // Update the field 'active' to false
        await dbOperation.updateDocument(ApiKey, hashedKey, { active: false });

        // Return the status code and an informative message
        return res.status(200).json({
            success: {
                code: '200',
                message: 'OK',
                details: 'Your key has been revoked. You will no longer be able to authenticate yourself using this key'
            }
        });

    } catch (error) {
        const msg = {
            messageID: req.logID,
            messageType: error.code,
            message: error.stack,
        }
        logger.logError.error(msg); // Write to error log file
        return res.status(500).json({
            error: {
                code: '500',
                message: 'Internal Server Error',
                details: 'An unexpected error has occurred. Please try again later'
            }
        });
    }
};

const keyController = {
    generateKey,
    revokeKey
};

export default keyController;
