import mongoose from 'mongoose';
import crypto from 'crypto';
import validator from 'validator';
import config from '../config/config.js';
import logger from '../logger.js';
import dbConnection from '../database/connection.js';
import dbOperation from '../database/operations.js';
import ApiKey from '../models/key.js';
import Event from '../models/event.js';

// Verify if request authentication key is valid
const isValidAuthKey = async (req, res, next) => {
    try {
        // Check if the request contains header with the API key
        if (!req.headers['service-api-key']) {
            res.setHeader('WWW-Authenticate', 'Basic realm="service-api-key"');
            return res.status(401).json({
                error: {
                    code: '401',
                    message: 'Unauthorized',
                    details: 'Authentication header is missing'
                }
            });
        }

        // Check if the API key is valid
        const key = req.headers['service-api-key']
        const hashedKey = crypto.createHash('sha256').update(key + config.server.secret).digest('hex');

        if (mongoose.connection.readyState === 0) {
            await dbConnection.connect();
        }

        const validUser = await dbOperation.readDocument(ApiKey, hashedKey);

        if (!validUser || !validUser.active) {
            res.setHeader('WWW-Authenticate', 'Basic realm="service-api-key"');
            return res.status(401).json({
                error: {
                    code: '401',
                    message: 'Unauthorized',
                    details: 'Authentication key is invalid'
                }
            });
        }

        // All checks passed, continue
        next();

    } catch (error) {
        const msg = {
            messageID: req.logID,
            message: error.stack
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

// Verify if who made the request has permission to perform the operation
const isOperationAllowed = async (req, res, next) => {
    try {
        // Check if request body is not missing or empty
        if (!req.body || Object.keys(req.body).length === 0) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Request body is missing or empty'
                }
            });
        }

        // Check if required body parameter exists and is of the correct type and format
        if (req.body.userid === null || req.body.userid === undefined) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Request body is missing the required parameter: userid'
                }
            });
        }
        if (typeof req.body.userid !== 'string' || !validator.isLength(req.body.userid.trim(), { min: 1, max: 1024 })) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <userid> must be a non-empty string between 1 and 1024 characters long (excluding leading and trailing white spaces)',
                    example: '1'
                }
            });
        }

        // Check if the user has permission to modify the resource (if he was the one that created it)
        if (mongoose.connection.readyState === 0) {
            await dbConnection.connect();
        }

        const event = await dbOperation.readDocument(Event, req.params.uuid);

        if (event) {
            if (event.userid !== req.body.userid) {
                return res.status(403).json({
                    error: {
                        code: '403',
                        message: 'Forbidden',
                        details: 'You do not have permission to perform this operation'
                    }
                });
            }
            else {
                next();
            }
        }
        else {
            if (req.method !== 'DELETE') {
                return res.status(404).json({
                    error: {
                        code: '404',
                        message: 'Not Found',
                        details: 'The requested resource does not exist'
                    }
                });
            }
            else {
                next();
            }
        }
    } catch (error) {
        const msg = {
            messageID: req.logID,
            message: error.stack
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

// Export 
const authValidator = {
    isValidAuthKey,
    isOperationAllowed
};

export default authValidator;
