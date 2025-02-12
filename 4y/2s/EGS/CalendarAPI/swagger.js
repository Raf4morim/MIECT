const swaggerJSDoc = require('swagger-jsdoc');

const swaggerOptions = {
  swaggerDefinition: {
    openapi: '3.0.0',
    info: {
      title: 'Calendar API ',
      version: '1.0.0',
      description: 'Documentation for calendar API endpoints',
    },
  },
  
  apis: ['./index.js'], // Adjust the path to your main file
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

module.exports = swaggerSpec;
