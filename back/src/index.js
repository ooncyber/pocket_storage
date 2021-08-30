const express = require('express');
const cors = require('cors');
const morgan = require('morgan')
const routes = require('./routes/index.js')
require('dns').lookup(require('os').hostname(), function (err, add, fam) {
    console.log( add);
})
require('dotenv/config');

const SERVER_URL = 'localhost'

const server = express();

server.use(morgan('dev'));
server.use(express.json());
server.use(cors());
server.use(routes);

server.get("/", (req, res) =>
    res.send(true));


server.listen(process.env.PORT, () => console.log(SERVER_URL + ":" + process.env.PORT));


