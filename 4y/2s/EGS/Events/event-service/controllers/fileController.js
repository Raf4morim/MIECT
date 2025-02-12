import amazonS3 from '../services/amazonS3.js';
import logger from '../logger.js';

// Upload a file to the storage
const uploadFile = async (req, res) => {
    try {
        // Upload the file to the storage
        await amazonS3.uploadFile(req.files[0], req.params.uuid);

        // Return the status code and the location header with the uri of the created event
        return res.status(201).setHeader('Location', `files/${req.params.uuid}`).end();

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

// Download a file from the storage
const downloadFile = async (req, res) => {
    try {
        // Get the file from the storage
        const file = await amazonS3.downloadFile(req.params.uuid);

        // Return the status code, headers and file
        res.setHeader('Content-Type', file.type);
        res.setHeader('Content-Disposition', `attachment; filename=${file.name}`);
        return res.status(200).send(file.buffer);

    } catch (error) {
        if (error.Code === 'NoSuchKey') {
            return res.status(404).json({
                error: {
                    code: '404',
                    message: 'Not Found',
                    details: 'The requested resource does not exist',
                }
            });
        }
        else {
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
            }
            );
        }
    };
};

const deleteFile = async (req, res) => {
    try {
        // Delete the file from the storage
        await amazonS3.deleteFile(req.params.uuid);

        // Return the status code
        return res.status(204).end();

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

const fileController = {
    uploadFile,
    downloadFile,
    deleteFile
};

export default fileController;
