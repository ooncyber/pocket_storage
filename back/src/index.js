const express = require('express');
const cors = require('cors');
const morgan = require('morgan')
const multer = require('multer');
const path = require("path");
const SERVER_URL = 'localhost'
const fs = require('fs');

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

server.get('/', async (req, res) => {
    // var list ='';
    // fs.readdir('./uploads/', (err, files) => {
    //     res.send(files);
    //     // files.forEach(file => {
    //     //     console.log(files);
    //     // });
    // });
    return res.send(await knex('uploads').select('categoria').select('id').groupBy('categoria'));
});

server.get('/:categoria', async (req, res) => {
    console.log('Variavel req.params: ', req.params)
    return res.send(await knex('uploads').select().where({ categoria: req.params.categoria }))
});


server.post('/', upload.single('file'), async (req, res, next) => {
    const { categoria } = JSON.parse(JSON.stringify(req.body));
    if (!categoria)
        return res.status(500).json({ msg: "Falta categoria", errno: 1 });
    if (!req.file)
        return res.status(500)


    const { filename, path } = req.file;

    var reg = { categoria, path, filename };


    return knex('uploads').where({ filename }).then(async rows => {
        if (rows.length == 0) {
            console.log('inserido!');
            await knex("uploads").insert(reg);
            return res.send({ ...reg })
        }
        else {
            console.log('tentativa de inserir duplicado');
            var r = await knex("uploads").select().where({ filename });
            return res.send(r);
        }
    });
});

server.get('/movies/:movieName', (req, res) => {
    const { movieName } = req.params;
    const movieFile = `./uploads/${movieName}`;
    fs.stat(movieFile, (err, stats) => {
        if (err) {
            console.log(err);
            return res.status(404).end('<h1>Movie Not found</h1>');
        }
        // Variáveis necessárias para montar o chunk header corretamente
        const { range } = req.headers;
        const { size } = stats;
        const start = Number((range || '').replace(/bytes=/, '').split('-')[0]);
        const end = size - 1;
        const chunkSize = (end - start) + 1;
        // Definindo headers de chunk
        res.set({
            'Content-Range': `bytes ${start}-${end}/${size}`,
            'Accept-Ranges': 'bytes',
            'Content-Length': chunkSize,
            'Content-Type': 'video/mp4'
        });
        // É importante usar status 206 - Partial Content para o streaming funcionar
        res.status(206);
        // Utilizando ReadStream do Node.js
        // Ele vai ler um arquivo e enviá-lo em partes via stream.pipe()
        const stream = fs.createReadStream(movieFile, { start, end });
        stream.on('open', () => stream.pipe(res));
        stream.on('error', (streamErr) => res.end(streamErr));
    });
});
server.listen(80, () => console.log(SERVER_URL));


