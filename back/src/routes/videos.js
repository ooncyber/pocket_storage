const router = require('express').Router();
const fs = require('fs');
const downloadVideo = require('../util/downloadYoutube');
const knex = require("../db/db_util");

router.get('/videos/:movieName', (req, res) => {
    const { movieName } = req.params;
    const movieFile = `./videos/${movieName}`;
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

router.post('/videos', (req, res, next) => {
    if (req.body.url && req.body.categoria)
        next();
    else if (!req.body.url) {
        res.status(401).json({ msg: 'informe a url' })
    }
    else if (!req.body.categoria) {
        res.status(401).json({ msg: 'informe o lazer' })
    }
}, async (req, res) => {
    let resultado = await downloadVideo(req.body.url);
    if (resultado) {
        var reg = { categoria: req.body.categoria, filename: resultado.filename, path: 'videos/' + resultado.filename };
        console.log('Variavel resultado: ', resultado)
        knex('uploads').where({ filename: resultado.filename }).then(async rows => {
            if (rows.length == 0) {
                console.log('inserido!');
                await knex("uploads").insert(reg);
            }
            else {
                console.log('tentativa de inserir duplicado');
                await knex("uploads").select().where({ filename: resultado.filename });
            }
        });
        return res.send(reg);
    }
    return res.status(500)
})

module.exports = router;