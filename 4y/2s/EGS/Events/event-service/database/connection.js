import mongoose from 'mongoose';
import config from '../config/config.js';

// Open connection to the database
const connect = async () => {
    try {
        await mongoose.connect(config.database.uri,
            {
                appName: config.database.appName,
                dbName: config.database.dbName,
                autoIndex: false,
            });
    } catch (error) {
        throw error;
    }
};

// Close connection to the database
const disconnect = async () => {
    try {
        await mongoose.disconnect();
    } catch (error) {
        throw error;
    }
};

// Export
const dbConnection = {
    connect,
    disconnect
};

export default dbConnection;
