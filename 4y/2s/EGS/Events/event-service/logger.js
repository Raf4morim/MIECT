import *  as  winston from 'winston';
import 'winston-daily-rotate-file';

// Create error logger instance
const logError = winston.createLogger({
    level: 'error',
    format: winston.format.combine(
        winston.format.timestamp({
            format: 'YYYY-MM-DD HH:mm:ss'
        }),
        winston.format.errors({ stack: true }),
        winston.format.splat(),
        winston.format.json(),
        winston.format.prettyPrint()
    ),
    defaultMeta: { service: 'Event-service' },
    transports: [
        new winston.transports.DailyRotateFile({
            filename: 'event-logs/error/error_%DATE%.log',
            datePattern: 'YYYY-MM-DD',
            zippedArchive: true,
            colorize: true,
        })
    ]
});

// Create info logger instance
const logInfo = winston.createLogger({
    level: 'info',
    format: winston.format.combine(
        winston.format.timestamp({
            format: 'YYYY-MM-DD HH:mm:ss'
        }),
        winston.format.errors({ stack: true }),
        winston.format.splat(),
        winston.format.json(),
        winston.format.prettyPrint()
    ),
    defaultMeta: { service: 'Event-service' },
    transports: [
        new winston.transports.DailyRotateFile({
            filename: 'event-logs/info/info_%DATE%.log',
            datePattern: 'YYYY-MM-DD',
            zippedArchive: true,
            colorize: true,
        })
    ]
});

// Export
const logger = {
    logError,
    logInfo
};

export default logger;
