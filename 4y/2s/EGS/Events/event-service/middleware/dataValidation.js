import mongoose from 'mongoose';
import validator from 'validator';
import config from '../config/config.js';
import logger from '../logger.js';

// Verify if request contains a valid UUIDv4 parameter
const isValidUUID = (req, res, next) => {
    try {

        // Check if parameter is a string in the UUIDv4 format
        const uuid = req.params.uuid;

        if (typeof uuid !== 'string' || !validator.isUUID(uuid, 4)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'URL parameter <uuid> must be a string in the UUIDv4 format',
                    example: 'd290f1ee-6c54-4b01-90e6-d701748f0851'
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

// Verify if request contains valid query parameters
const isValidQuery = (req, res, next) => {
    try {

        // Check if invalid query parameters are present in the request
        const allowedParameters = [
            ...config.server.allowedQueryParams,
            ...config.calendarService.allowedQueryParams,
            ...config.poiService.allowedQueryParams
        ];
        const invalidParams = Object.keys(req.query).filter(param => !allowedParameters.includes(param.toLocaleLowerCase()));

        if (invalidParams.length > 0) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: `Query parameter(s) <${invalidParams.join(', ')}> is not allowed. Must be one of the following: [${allowedParameters.join(', ')}]`,
                }
            });
        }

        // Check if valid query parameters are of the correct type and format
        if (req.query.limit !== null && req.query.limit !== undefined) {
            const limit = Number.parseInt(req.query.limit);
            if (isNaN(limit) || !Number.isInteger(limit) || limit < config.server.minimumLimit || limit > config.server.maximumLimit) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: `Query parameter <limit> must be a string that represents a valid positive integer between ${config.server.minimumLimit} and ${config.server.maximumLimit}`,
                        example: `${config.server.defaultLimit}`
                    }
                });
            }
        }

        if (req.query.offset !== null && req.query.offset !== undefined) {
            const offset = Number.parseInt(req.query.offset);
            if (isNaN(offset) || !Number.isInteger(offset) || offset < config.server.minimumOffset) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <offset> must be a string that represents a valid non-negative integer',
                        example: `${config.server.defaultOffset}`
                    }
                });
            }
        }

        if (req.query.calendarid !== null && req.query.calendarid !== undefined) {
            if (typeof req.query.calendarid !== 'string' || !validator.isLength(req.query.calendarid.trim(), { min: 1, max: 1024 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <calendarid> must be a non-empty string between 1 and 1024 characters long (excluding leading and trailing white spaces)',
                        example: '1'
                    }
                });
            }
        }

        if (req.query.pointofinterestid !== null && req.query.pointofinterestid !== undefined) {
            if (typeof req.query.pointofinterestid !== 'string' || !mongoose.isObjectIdOrHexString(req.query.pointofinterestid)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <pointofinterestid> must be a 24 character hex string',
                        example: '5f8f4b3b9b3e6b1f3c1e4b1a'
                    }
                });
            }
        }

        if (req.query.userid !== null && req.query.userid !== undefined) {
            if (typeof req.query.userid !== 'string' || !validator.isLength(req.query.userid.trim(), { min: 1, max: 1024 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <userid> must be a non-empty string between 1 and 1024 characters long (excluding leading and trailing white spaces)',
                        example: '1'
                    }
                });
            }
        }

        if (req.query.name !== null && req.query.name !== undefined) {
            if (typeof req.query.name !== 'string' || !validator.isLength(req.query.name.trim(), { min: 1, max: 256 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <name> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                        example: 'Event Name'
                    }
                });
            }
        }

        if (req.query.organizer !== null && req.query.organizer !== undefined) {
            if (typeof req.query.organizer !== 'string' || !validator.isLength(req.query.organizer.trim(), { min: 1, max: 256 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <organizer> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                        example: 'Organizer Name'
                    }
                });
            }
        }

        if (req.query.location !== null && req.query.location !== undefined) {
            if (typeof req.query.location !== 'string' || !validator.isLength(req.query.location.trim(), { min: 1, max: 2048 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <location> must be a non-empty string between 1 and 2048 characters long (excluding leading and trailing white spaces)',
                        example: 'City Name'
                    }
                });
            }
        }

        if (req.query.category !== null && req.query.category !== undefined) {
            if (typeof req.query.category !== 'string' || !validator.isLength(req.query.category.trim(), { min: 1, max: 256 })) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <category> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                        example: 'technology'
                    }
                });
            }
        }

        if (req.query.maxprice !== null && req.query.maxprice !== undefined) {
            const pattern = config.server.priceFormatQuery;
            if (typeof req.query.maxprice !== 'string' || !pattern.test(req.query.maxprice)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <maxPrice> must be a string in the correct format',
                        example: '25.55'
                    }
                });
            }
        }

        if (req.query.startdate !== null && req.query.startdate !== undefined) {
            if (req.query.startdate) {
                if (typeof req.query.startdate !== 'string' || !validator.isRFC3339(req.query.startdate)) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'Query parameter <startDate> must be a string in the RFC 3339 format',
                            example: '2024-04-07T20:00:00.001Z'
                        }
                    });
                }
            }
        }

        if (req.query.beforedate !== null && req.query.beforedate !== undefined) {
            if (typeof req.query.beforedate !== 'string' || !validator.isRFC3339(req.query.beforedate)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <beforedate> must be a string in the RFC 3339 format',
                        example: '2024-04-07T22:00:00.001Z'
                    }
                });
            }
        }

        if (req.query.afterdate !== null && req.query.afterdate !== undefined) {
            if (typeof req.query.afterdate !== 'string' || !validator.isRFC3339(req.query.afterdate)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <afterdate> must be a string in the RFC 3339 format',
                        example: '2024-04-07T22:00:00.001Z'
                    }
                });
            }
        }

        if (req.query.longitude !== null && req.query.longitude !== undefined) {
            const longitude = Number.parseFloat(req.query.longitude);
            if (isNaN(longitude) || !Number.parseFloat(longitude) || longitude < -180 || longitude > 180) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <longitude> must be a string that represents a valid float between -180 and 180',
                        example: '38.7610731'
                    }
                });
            }
        }

        if (req.query.latitude !== null && req.query.latitude !== undefined) {
            const latitude = Number.parseFloat(req.query.latitude);
            if (isNaN(latitude) || !Number.parseFloat(latitude) || latitude < -90 || latitude > 90) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Query parameter <latitude> must be a string that represents a valid float between -90 and 90',
                        example: '-9.1631749'
                    }
                });
            }
        }

        if (req.query.radius !== null && req.query.radius !== undefined) {
            const radius = Number.parseFloat(req.query.radius);
            if (isNaN(radius) || !Number.parseFloat(radius) || radius < config.poiService.minimumPoiDistance || radius > config.poiService.maximumPoiDistance) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: `Query parameter <radius> must be a string that represents a valid positive float between ${config.poiService.minimumPoiDistance} and ${config.poiService.maximumPoiDistance} meters`,
                        example: '250'
                    }
                });
            }
        }

        // Either all or none of the location parameters are present
        if (
            (req.query.longitude === null || req.query.longitude === undefined) ||
            (req.query.latitude === null || req.query.latitude === undefined) ||
            (req.query.radius === null || req.query.radius === undefined)
        ) {
            delete req.query.longitude;
            delete req.query.latitude;
            delete req.query.radius;
        }

        // All checks passed, continue
        next();

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

// Verify if request contains a valid body
const isValidBody = (req, res, next) => {
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

        // Check if all required body parameters are present in the request body
        const requiredParameters = config.server.requiredBodyParams;
        for (const param of requiredParameters) {
            if (!req.body[param]) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: `Request body is missing the required parameter: ${param}`
                    }
                });
            }
        }

        if ((req.body.pointofinterestid === null || req.body.pointofinterestid === undefined) && (req.body.pointofinterest === null || req.body.pointofinterest === undefined)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Request body must contain at least one of the following parameters: [pointofinterestid, pointofinterest]'
                }
            })
        }

        // Check if all required body parameters are of the correct type and format
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

        if (typeof req.body.name !== 'string' || !validator.isLength(req.body.name.trim(), { min: 1, max: 256 })) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <name> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                    example: 'Event Name'
                }
            });
        }

        if (typeof req.body.organizer !== 'string' || !validator.isLength(req.body.organizer.trim(), { min: 1, max: 256 })) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <organizer> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                    example: 'Organizer Name'
                }
            });
        }

        if (typeof req.body.contact !== 'string' || !validator.isEmail(req.body.contact)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <contact> must be a string in a valid email format',
                    example: 'user@domain.com'
                }
            });
        }

        const allowedOptions = config.server.allowedCategories;
        if (typeof req.body.category !== 'string' || !validator.isIn(req.body.category.toLowerCase(), allowedOptions)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: `Body parameter <category> must be a string of one of the following options: [${allowedOptions.join(', ')}]`,
                    example: 'technology'
                }
            });
        }

        if (typeof req.body.startdate !== 'string' || !validator.isRFC3339(req.body.startdate)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <startdate> must be a string in the RFC 3339 format',
                    example: '2024-04-07T20:00:00.001Z'
                }
            });
        }

        if (typeof req.body.enddate !== 'string' || !validator.isRFC3339(req.body.enddate)) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <enddate> must be a string in the RFC 3339 format',
                    example: '2024-04-07T22:00:00.001Z'
                }
            });
        }

        if ((new Date(req.body.enddate) - new Date(req.body.startdate)) < 60000) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'There must be at least 1 minute between the start and end date of the event',
                }
            });
        }

        if (typeof req.body.about !== 'string' || !validator.isLength(req.body.about.trim(), { min: 1, max: 2048 })) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <about> must be a non-empty string between 1 and 2048 characters long (excluding leading and trailing white spaces)',
                    example: 'This is a description of the event'
                }
            });
        }

        // Check if optional body parameters, should they exist, are of the correct type and format
        if (req.body.price !== null && req.body.price !== undefined) {
            const pattern = config.server.priceFormatReq;
            if (typeof req.body.price !== 'string' || !pattern.test(req.body.price)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Body parameter <price> must be a string in the correct format',
                        example: 'EUR25.55'
                    }
                });
            }
        }

        if (req.body.maxparticipants !== null && req.body.maxparticipants !== undefined) {
            if (typeof req.body.maxparticipants !== 'number' || !Number.isInteger(req.body.maxparticipants) || req.body.maxparticipants < 0 || req.body.maxparticipants > 9999999999) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Body parameter <maxparticipants> must be a non-negative integer with a maximum value of 9999999999',
                        example: '100'
                    }
                });
            }
        }

        if (req.body.currentparticipants !== null && req.body.currentparticipants !== undefined) {
            if (typeof req.body.currentparticipants !== 'number' || !Number.isInteger(req.body.currentparticipants) || req.body.currentparticipants < 0 || req.body.currentparticipants > 9999999999) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Body parameter <currentparticipants> must be a non-negative integer with a maximum value of 9999999999',
                        example: '25'
                    }
                });
            }
        }

        if (req.body.currentparticipants && req.body.maxparticipants) {
            if (req.body.currentparticipants > req.body.maxparticipants) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'The value of <currentparticipants> must be lesser or equal to <maxparticipants>',
                    }
                });
            }
        }

        if (req.body.pointofinterestid !== null && req.body.pointofinterestid !== undefined) {
            if (typeof req.body.pointofinterestid !== 'string' || !mongoose.isObjectIdOrHexString(req.body.pointofinterestid)) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: 'Body parameter <pointofinterestid> must be a 24 character hex string',
                        example: '5f8f4b3b9b3e6b1f3c1e4b1a'
                    }
                });
            }
        }

        if (req.body.pointofinterest !== null && req.body.pointofinterest !== undefined) {
            if (req.body.pointofinterest) {
                // Check if all required parameters were given
                const requiredParams = config.server.requiredPoiParams;
                for (const param of requiredParams) {
                    if (!req.body.pointofinterest[param]) {
                        return res.status(400).json({
                            error: {
                                code: '400',
                                message: 'Bad Request',
                                details: `pointofinterest was given but is missing the required parameter: ${param}`
                            }
                        });
                    }
                }
                // Check if required parameters are of the correct type and format
                if (typeof req.body.pointofinterest.name !== 'string' || !validator.isLength(req.body.pointofinterest.name.trim(), { min: 1, max: 256 })) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'pointofinterest parameter <name> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                            example: 'POI Name'
                        }
                    });
                }
                if (typeof req.body.pointofinterest.longitude !== 'number' || req.body.pointofinterest.longitude < -180 || req.body.pointofinterest.longitude > 180) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'pointofinterest parameter <longitude> must be a valid float between -180 and 180',
                            example: '38.7610731'
                        }
                    });
                }
                if (typeof req.body.pointofinterest.latitude !== 'number' || req.body.pointofinterest.latitude < -90 || req.body.pointofinterest.latitude > 90) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'pointofinterest parameter <latitude> must be a valid float between -90 and 90',
                            example: '-9.1631749'
                        }
                    });
                }
                if (typeof req.body.pointofinterest.street !== 'string' || !validator.isLength(req.body.pointofinterest.street.trim(), { min: 1, max: 512 })) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'Body parameter <street> must be a non-empty string between 1 and 512 characters long (excluding leading and trailing white spaces)',
                            example: 'Street Name N123'
                        }
                    });
                }
                if (typeof req.body.pointofinterest.postcode !== 'string' || !validator.isLength(req.body.pointofinterest.postcode.trim(), { min: 1, max: 256 })) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'Body parameter <postcode> must be a non-empty string between 1 and 256 characters long (excluding leading and trailing white spaces)',
                            example: '1234-567'
                        }
                    });
                }

                if (typeof req.body.pointofinterest.location !== 'string' || !validator.isLength(req.body.pointofinterest.location.trim(), { min: 1, max: 512 })) {
                    return res.status(400).json({
                        error: {
                            code: '400',
                            message: 'Bad Request',
                            details: 'Body parameter <location> must be a non-empty string between 1 and 512 characters long (excluding leading and trailing white spaces)',
                            example: 'City Name, Country Name'
                        }
                    });
                }

                // Check if optional parameters, should they exist, are of the correct type and format
                if (req.body.pointofinterest.category !== null && req.body.pointofinterest.category !== undefined) {
                    const allowedOptions = config.poiService.allowedCategories;
                    if (typeof req.body.pointofinterest.category !== 'string' || !validator.isIn(req.body.pointofinterest.category.toLowerCase(), allowedOptions)) {
                        return res.status(400).json({
                            error: {
                                code: '400',
                                message: 'Bad Request',
                                details: `pointofinterest parameter <category> must be a string of one of the following categories: [${allowedOptions.join(', ')}]`,
                                example: 'landmarks'
                            }
                        });
                    }
                }

                if (req.body.pointofinterest.description !== null && req.body.pointofinterest.description !== undefined) {
                    if (typeof req.body.pointofinterest.description !== 'string' || !validator.isLength(req.body.pointofinterest.description.trim(), { min: 1, max: 2048 })) {
                        return res.status(400).json({
                            error: {
                                code: '400',
                                message: 'Bad Request',
                                details: 'pointofinterest parameter <description> must be a non-empty string between 1 and 2048 characters long (excluding leading and trailing white spaces)',
                                example: 'This is a description of the point of interest'
                            }
                        });
                    }
                }
                if (req.body.pointofinterest.thumbnail !== null && req.body.pointofinterest.thumbnail !== undefined) {
                    if (typeof req.body.pointofinterest.thumbnail !== 'string' || !validator.isURL(req.body.pointofinterest.thumbnail)) {
                        return res.status(400).json({
                            error: {
                                code: '400',
                                message: 'Bad Request',
                                details: 'pointofinterest parameter <thumbnail> must be a string in a valid url format',
                                example: 'https://example.com/image.jpg'
                            }
                        });
                    }
                }
            }
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

// Verify if request contains valid favorite
const isValidFavorite = (req, res, next) => {
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

        // Check if required body parameters exist and are of the correct type and format
        const requiredParameters = config.server.requiredFavParams;
        for (const param of requiredParameters) {
            if (req.body[param] === null || req.body[param] === undefined) {
                return res.status(400).json({
                    error: {
                        code: '400',
                        message: 'Bad Request',
                        details: `Request body is missing the required parameter: ${param}`
                    }
                });
            }
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
        if (typeof req.body.calendarid !== 'string' || !validator.isLength(req.body.calendarid.trim(), { min: 1, max: 1024 })) {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <calendarid> must be a non-empty string between 1 and 1024 characters long (excluding leading and trailing white spaces)',
                    example: '1'
                }
            });
        }

        if (typeof req.body.favoritestatus !== 'boolean') {
            return res.status(400).json({
                error: {
                    code: '400',
                    message: 'Bad Request',
                    details: 'Body parameter <favoritestatus> must be a boolean',
                    example: 'true'
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

// Export
const dataValidator = {
    isValidUUID,
    isValidQuery,
    isValidBody,
    isValidFavorite
};

export default dataValidator;
