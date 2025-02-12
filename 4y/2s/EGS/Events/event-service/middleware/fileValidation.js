import multer from 'multer';
import config from '../config/config.js';
import logger from '../logger.js';

// Create a new instance of multer and configure it to handle requests with files according to the service configuration
const initializeMulter = () => {
    try {
        return multer({
            fileFilter: (req, file, cb) => {
                if (!config.server.allowedFileType.includes(file.mimetype)) { // The allowed file types 
                    cb(null, false);
                    cb(new Error('INVALID_FILE_TYPE'));
                }
                else {
                    cb(null, true);
                }
            },
            limits: { fileSize: config.server.allowedFileMaxSizeMB * 1024 * 1024, files: config.server.allowedFileNumber, fieldSize: 1048576}, // The maximum file size in bytes and the maximum number of files per request
        }).array('file'); // The name of the file input field in the form
    }
    catch (err) {
        throw err;
    };
};

// Verify if request contains a valid file type with a valid size
const isValidFile = (req, res, next) => {
    try {

        // Check if content-type is multipart/form-data
        if (!req.headers['content-type'] || !req.headers['content-type'].includes('multipart/form-data')) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Invalid content-type. It must be multipart/form-data'
                }
            });
        }

        // Call a multer instance to handle the request, process the file and check for file existence, size, and type
        const multerInstance = initializeMulter();
        multerInstance(req, res, (err) => {

            // If error was thrown by multer itself
            if (err instanceof multer.MulterError) {
                if (err.code === 'LIMIT_FILE_SIZE') {
                    return res.status(413).json({
                        error: {
                            code: '413',
                            message: 'Payload Too Large',
                            details: 'The file size exceeds the maximum allowed size of 10MB'
                        }
                    });
                }
                if (err.code === 'LIMIT_FILE_COUNT') {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'The request contains too many files. Only one file per request is allowed'
                        }
                    });
                }
                if (err.code === 'LIMIT_UNEXPECTED_FILE') {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'The request contains unexpected files. In your request, the field name for the file must be: file'
                        }
                    });
                }
                if (err.code === 'LIMIT_FIELD_VALUE') {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'The request contains a text field too large. Maximum allowed size is 1MB'
                        }
                    });
                }
            }

            // If error was manually thrown
            if (err) {
                if (err.message === 'INVALID_FILE_TYPE') {
                    return res.status(415).json({
                        error: {
                            code: '415',
                            message: 'Unsupported Media Type',
                            details: `This file type is not supported. Supported types are: [${config.server.allowedFileType.join(', ')}]`,
                        }
                    });
                }
            }

            // If no file was uploaded
            if (!req.files || req.files.length === 0) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'No file was uploaded. Please select a file and try again'
                    }
                });
            }

            // All checks passed, continue
            next();
        });
    }
    catch (error) {
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
const fileValidator = {
    isValidFile
};

export default fileValidator;
