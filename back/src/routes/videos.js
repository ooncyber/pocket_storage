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
    if (req.body.url)
        next();
    else
        return res.status(400).json({ msg: "Informe a url" })
}, async (req, res) => {
    let resultado = await downloadVideo(req.body.url);
    return res.send(resultado);
})

module.exports = router;