// swagger.js
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Basketball Stats API',
      version: '1.0.0',
      description: 'API per gestire statistiche di basket',
    },
    servers: [
      {
        url: 'http://localhost:5001',
      },
    ],
  },
  apis: ['./routes/*.js'], // Percorso ai file delle rotte
};

const specs = swaggerJsDoc(options);

const setupSwagger = (app) => {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));
};

module.exports = setupSwagger;
