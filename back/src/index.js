const express = require('express');
const cors = require('cors');
const morgan = require('morgan')
const routes = require('./routes/index.js')

const SERVER_URL = 'localhost'

const server = express();

server.use(morgan('dev'));
server.use(express.json());
server.use(cors());
server.use(routes);




server.listen(80, () => console.log(SERVER_URL));


