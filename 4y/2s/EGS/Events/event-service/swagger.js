import swaggerJSDoc from 'swagger-jsdoc';
import config from './config/config.js';

// Point of Interest schema definition
const poi = {
  type: 'object',
  properties: {
    name: {
      type: 'string',
      example: 'POI Name'
    },
    longitude: {
      type: 'number',
      format: 'float',
      minimum: -180,
      maximum: 180,
      example: 38.7610731
    },
    latitude: {
      type: 'number',
      format: 'float',
      minimum: -90,
      maximum: 90,
      example: -9.1631749
    },
    street: {
      type: 'string',
      example: 'Street Name N123'
    },
    postcode: {
      type: 'string',
      example: '1234-567'
    },
    location: {
      type: 'string',
      example: 'City Name, Country Name'
    },
    category: {
      type: 'string',
      enum: config.poiService.allowedCategories,
      example: 'landmarks'
    },
    description: {
      type: 'string',
      example: 'This is a description of the point of interest'
    },
    thumbnail: {
      type: 'string',
      format: 'url',
      example: 'https://example.com/image.jpg'
    }
  },
  required: [
    'name',
    'latitude',
    'longitude',
    'street',
    'postcode',
    'location',
  ]
};

// Favorite schema definition
const favorite = {
  type: 'object',
  properties: {
    userid: {
      type: 'string',
      example: '1'
    },
    calendarid: {
      type: 'string',
      example: '1'
    },
    favoritestatus: {
      type: 'boolean',
      example: true
    }
  },
  required: [
    'userid',
    'calendarid',
    'favoritestatus'
  ]
};

// Event schema definition
const eventRequest = {
  type: 'object',
  properties: {
    userid: {
      type: 'string',
      example: '1'
    },
    name: {
      type: 'string',
      example: 'Event Name'
    },
    organizer: {
      type: 'string',
      example: 'Organizer Name'
    },
    category: {
      type: 'string',
      enum: config.server.allowedCategories,
      example: 'technology'
    },
    contact: {
      type: 'string',
      format: 'email',
      example: 'user@domain.com'
    },
    startdate: {
      type: 'string',
      format: 'date-time',
      example: '2024-04-07T20:00:00.001Z'
    },
    enddate: {
      type: 'string',
      format: 'date-time',
      example: '2024-04-07T22:00:00.001Z'
    },
    about: {
      type: 'string',
      example: 'This is a description of the event'
    },
    price: {
      type: 'string',
      pattern: '^(EUR|USD|GBP)\d+\.\d{2}$',
      example: 'EUR25.55'
    },
    maxparticipants: {
      type: 'integer',
      format: 'int32',
      minimum: 0,
      maximum: 9999999999,
      example: 100
    },
    currentparticipants: {
      type: 'integer',
      format: 'int32',
      minimum: 0,
      maximum: 9999999999,
      example: 25
    },
    pointofinterestid: {
      type: 'string',
      example: '5f8f4b3b9b3e6b1f3c1e4b1a'
    },
    pointofinterest: poi,
  },
  required: [
    'userid',
    'name',
    'organizer',
    'category',
    'contact',
    'startdate',
    'enddate',
    'about',
  ]
};

// Event schema definition for responses
const eventResponse = {
  type: 'object',
  properties: {
    _id: {
      type: 'string',
      format: 'uuid',
      example: 'd290f1ee-6c54-4b01-90e6-d701748f0851'
    },
    name: {
      type: 'string',
      example: 'Event Name'
    },
    organizer: {
      type: 'string',
      example: 'Organizer Name'
    },
    category: {
      type: 'string',
      enum: config.server.allowedCategories,
      example: 'technology'
    },
    contact: {
      type: 'string',
      format: 'email',
      example: 'organizer@example.com'
    },
    startdate: {
      type: 'string',
      format: 'date-time',
      example: '2024-04-07T20:00:00.001Z'
    },
    enddate: {
      type: 'string',
      format: 'date-time',
      example: '2024-04-07T22:00:00.001Z'
    },
    about: {
      type: 'string',
      example: 'Event description'
    },
    price: {
      type: 'number',
      minimum: 0,
      example: 25.55
    },
    currency: {
      type: 'string',
      enum: ['EUR', 'USD', 'GBP'],
      example: 'EUR'
    },
    maxparticipants: {
      type: 'integer',
      format: 'int32',
      minimum: 0,
      maximum: 9999999999,
      example: 100
    },
    currentparticipants: {
      type: 'integer',
      format: 'int32',
      minimum: 0,
      maximum: 9999999999,
      example: 25
    },
    favorites: {
      type: 'integer',
      format: 'int32',
      minimum: 0,
      maximum: 9999999999,
      example: 100
    },
    pointofinterestid: {
      type: 'string',
      example: '5f8f4b3b9b3e6b1f3c1e4b1a'
    },
    pointofinterest: poi
  },
  required: [
    '_id',
    'name',
    'organizer',
    'contact',
    'category',
    'startdate',
    'enddate',
    'about',
    'price',
    'currency',
    'maxparticipants',
    'currentparticipants',
    'favorites',
    'pointofinterestid',
    'pointofinterest'
  ]
};

// Swagger definition
const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Event Service API',
    version: '1.0.0',
    description: 'API that exposes endpoints for an event managing microservice',
    name: 'Luís Couto',
    license: {
      name: 'Apache 2.0',
      url: 'http://www.apache.org/licenses/LICENSE-2.0.html'
    },
    contact: {
      name: 'Luís Couto',
      email: 'luiscouto10@ua.pt'
    }
  },
  tags: [
    {
      name: 'Keys',
      description: 'Operations available for Keys'
    },
    {
      name: 'Events',
      description: 'Operations available for Events'
    },
    {
      name: 'Files',
      description: 'Operations available for Files'
    }
  ],
  security: {
    ApiKeyAuth: []
  },
  components: {
    securitySchemes: {
      ApiKeyAuth: {
        type: 'apiKey',
        in: 'header',
        name: 'SERVICE-API-KEY'
      }
    },
    schemas: {
      Event_Request: eventRequest,
      Event_Response: eventResponse,
      PointOfInterest: poi,
      Favorite: favorite
    },
    responses: {
      Created_201: {
        description: 'Created',
        headers: {
          Location: {
            description: 'URI where the newly created resource can be found',
            schema: {
              type: 'string'
            }
          }
        }
      },
      NoContent_204: {
        description: 'No Content',
      },
      BadRequest_400: {
        description: 'Bad Request',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    },
                    example: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      Unauthorized_401: {
        description: 'Unauthorized',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        },
        headers: {
          WWW_Authenticate: {
            description: 'Basic realm="service-api-key"',
            schema: {
              type: 'string'
            }
          }
        }
      },
      Forbidden_403: {
        description: 'Forbidden',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      NotFound_404: {
        description: 'Not Found',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      Conflict_409: {
        description: 'Conflict',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      PayloadTooLarge_413: {
        description: 'Payload Too Large',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      UnsupportedMediaType_415: {
        description: 'Unsupported Media Type',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      InternalServerError_500: {
        description: 'Internal Server Error',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      },
      BadGateway_502: {
        description: 'Bad Gateway',
        content: {
          'application/json': {
            schema:
            {
              type: 'object',
              properties: {
                error: {
                  type: 'object',
                  properties: {
                    code: {
                      type: 'string'
                    },
                    message: {
                      type: 'string'
                    },
                    details: {
                      type: 'string'
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
};

// Options for the swagger specification
const options = {
  swaggerDefinition,
  apis: ['./routes/*.js']
};

// Generate the swagger specification
const swaggerSpec = swaggerJSDoc(options);

// Export the swagger specification
export default swaggerSpec;
