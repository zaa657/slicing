require('dotenv').config();
const express = require('express');
const cors = require('cors');
const swaggerUi = require('swagger-ui-express');
const openapi = require('./docs/openapi');
const routes = require('./routes');
const { notFound, errorHandler } = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.json({ message: 'todo API berjalan', docs: '/api-docs' }));

app.get('/api-docs.json', (req, res) => res.json(openapi));
app.use(
  '/api-docs',
  swaggerUi.serve,
  swaggerUi.setup(openapi, {
    customSiteTitle: 'todo API Docs',
    swaggerOptions: { persistAuthorization: true },
  })
);

app.use('/api', routes);

app.use(notFound);
app.use(errorHandler);

module.exports = app;
