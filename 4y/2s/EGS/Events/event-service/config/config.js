// Service configuration
const config = {
    amazonS3: {
        accessKeyId: process.env.AMAZONS3_SERVICE_ACCESS_KEY_ID,
        secretAccessKey: process.env.AMAZONS3_SERVICE_SECRET_ACCESS_KEY,
        region: process.env.AMAZONS3_SERVICE_REGION,
        bucket: process.env.AMAZONS3_SERVICE_BUCKET,
        url: process.env.AMAZONS3_SERVICE_URL,
        forcePathStyle: true
    },
    calendarService: {
        apikey: process.env.CALENDAR_SERVICE_KEY,
        baseUrl: process.env.CALENDAR_SERVICE_URL,
        port: process.env.CALENDAR_SERVICE_PORT,
        allowedQueryParams: [
            'calendarid',
            'startdate',
            'beforedate',
            'afterdate',
            'name'
        ]
    },
    poiService: {
        apikey: process.env.POI_SERVICE_KEY,
        baseUrl: process.env.POI_SERVICE_URL,
        port: process.env.POI_SERVICE_PORT,
        allowedCategories: [
            'nature',
            'food',
            'culture',
            'shopping',
            'landmarks'
        ],
        allowedQueryParams: [
            'location',
            'longitude',
            'latitude',
            'radius'
        ],
        minimumPoiDistance: 100,
        maximumPoiDistance: 50000
    },
    database: {
        appName: process.env.API_NAME,
        dbName: process.env.DATABASE_NAME,
        uri: process.env.DATABASE_URI
    },
    server: {
        port: process.env.API_PORT,
        secret: process.env.API_SECRET,
        allowedCategories: [
            'business',
            'conference',
            'culture',
            'networking',
            'technology',
            'sports',
            'wellness',
            'workshop',
            'food'],
        allowedQueryParams: [
            'limit',
            'offset',
            'pointofinterestid',
            'userid',
            'organizer',
            'category',
            'maxprice'
        ],
        allowedFileType: ['image/jpeg'], // Allowed MIME types for files
        allowedFileMaxSizeMB: 10, // Allowed maximum file size in MB
        allowedFileNumber: 1, // Allowed number of files per request
        priceFormatReq: /^(EUR|USD|GBP)\d+\.\d{2}$/, // Regular expression to validate the price format in a request
        priceFormatQuery: /^(\d+\.\d{2})$/, // Regular expression to validate the price format in a query parameter
        requiredBodyParams: [
            'userid',
            'name',
            'organizer',
            'category',
            'contact',
            'startdate',
            'enddate',
            'about'
        ], // Required fields in the request body
        requiredPoiParams: ['name', 'longitude', 'latitude', 'street', 'postcode', 'location'], // Required fields in the Point of Interest structure
        requiredFavParams: ['userid', 'calendarid', 'favoritestatus'], // Required fields in the Favorite structure
        minimumLimit: 1,
        maximumLimit: 50,
        defaultLimit: 25,
        minimumOffset: 0,
        defaultOffset: 0,
        defaultCalendarId: '1'
    },
};

export default config;
