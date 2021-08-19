const express = require('express');
const cors = require('cors');
const morgan = require('morgan')
const multer = require('multer');
const path = require("path");
const SERVER_URL = 'localhost'

const knex = require('knex')({
    client: 'sqlite3',
    connection: {
        filename: './data.db',
    },
});
knex.schema
    .createTableIfNotExists('uploads', table => {
        table.increments('id');
        table.string('categoria');
        table.string('filename');
        table.string('path');
    }).then((_) => { });


const server = express();

server.use('/uploads', express.static('uploads'))

server.use(morgan('dev'));
server.use(express.json());
server.use(cors());


const upload = multer({
    storage: multer.diskStorage({
        destination: 'uploads/',
        filename: function (req, file, cb) {
            cb(null, file.originalname)
        }
    })
});


server.post('/', upload.single('file'), (req, res, next) => {
    const { categoria } = JSON.parse(JSON.stringify(req.body));
    const {filename, path} = req.file ? req.file : {};

    var reg = {categoria, path, filename};

    knex('uploads').insert(reg);
    res.send({...reg, path:'http://'+SERVER_URL+'/'+path.replace('\\', '/')})
});
server.listen(80, () => console.log(SERVER_URL));


