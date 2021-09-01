const router = require('express').Router();
const fs = require('fs');
const downloadVideo = require('../util/downloadYoutube');
const knex = require("../db/db_util");
var glob = require("glob")
const express = require("express")
const path = require('path');

router.get('/public/videos/:pasta?/:movieName', (req, res) => {
    // console.log('Variavel req.params: ', req.params)
    // console.log('Variavel __dirname+"videos/"+req.params: ', path.resolve('videos') + '/' + req.params.movieName)
    if (!req.params.pasta)
        res.sendFile(path.resolve('videos') + '/' + req.params.movieName);
    else
        res.sendFile(path.resolve('videos') + '/' + req.params.pasta+'/'+req.params.movieName);
    // res.sendFile(req.params.movieName);
    // const { movieName } = req.params;
    // const movieFile = `./videos/${movieName}`;
    // fs.stat(movieFile, (err, stats) => {
    //     if (err) {
    //         console.log(err);
    //         return res.status(404).end('<h1>Movie Not found</h1>');
    //     }
    //     // Variáveis necessárias para montar o chunk header corretamente
    //     const { range } = req.headers;
    //     const { size } = stats;
    //     const start = Number((range || '').replace(/bytes=/, '').split('-')[0]);
    //     const end = size - 1;
    //     const chunkSize = (end - start) + 1;
    //     // Definindo headers de chunk
    //     res.set({
    //         'Content-Range': `bytes ${start}-${end}/${size}`,
    //         'Accept-Ranges': 'bytes',
    //         'Content-Length': chunkSize,
    //         'Content-Type': 'video/mp4'
    //     });
    //     // É importante usar status 206 - Partial Content para o streaming funcionar
    //     res.status(206);
    //     // Utilizando ReadStream do Node.js
    //     // Ele vai ler um arquivo e enviá-lo em partes via stream.pipe()
    //     const stream = fs.createReadStream(movieFile, { start, end });
    //     stream.on('open', () => stream.pipe(res));
    //     stream.on('error', (streamErr) => res.end(streamErr));
    // });
});

router.get('/videos', (req, res) => {
    // var list = [];
    // fs.readdirSync('./videos/').forEach(file => {
    //     // console.log(file);
    //     list.push(file);
    // });
    // res.send(list);

    glob('videos/**/*.mp4', (err, files) => {
        return res.send(files.map(i => i.replace('videos/', '')));
    })
})

router.get("/videos/pasta/:pasta", (req, res) => {
    glob('videos/' + req.params.pasta + '/*.mp4', (err, files) => {
        return res.send(files.map(i => i.replace('videos/', '')));
    });
})
console.log('Variavel path.resolve(__dirname+): ', path.resolve(''))

router.get('/html*', (req, res) => {
    res.sendFile(path.resolve('teste') + '/index.html')
    // console.log('oi');
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