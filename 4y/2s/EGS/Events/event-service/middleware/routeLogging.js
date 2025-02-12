import { v4 as uuidv4 } from 'uuid';
import logger from '../logger.js';

// Log incoming request
const request = async (req, res, next) => {

    // Generate a unique ID for the log message to track the request and response
    req.logID = uuidv4();
    try {
        logger.logInfo.info({
            messageID: req.logID,
            messageType: 'REQUEST',
            message: `${req.method} ${req.originalUrl}`,
            fromIP: req.ip,
            content: req.headers['content-type'],
            params: req.params,
            query: req.query,
            body: req.body
        });

        next();

    } catch (error) {
        const msg = {
            messageID: req.logID,
            message: error.stack
        }
        logger.logError.error(msg); // Write to error log file
    }
};

const response = async (req, res, next) => {
    try {
        res.on('finish', () => {
            logger.logInfo.info({
                messageID: req.logID,
                messageType: 'RESPONSE',
                message: `${req.method} ${req.originalUrl}`,
                toIP: req.ip,
                status_code: res.statusCode,
            });
        });

        next();

    } catch (error) {
        const msg = {
            messageID: req.logID,
            message: error.stack
        }
        logger.logError.error(msg); // Write to error log file
    }
}

// Export 
const routeLogger = {
    request,
    response,
};

export default routeLogger;
