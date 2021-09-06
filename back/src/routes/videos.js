const router = require('express').Router();
const downloadVideo = require('../util/downloadYoutube');
const knex = require("../db/db_util");
var glob = require("glob")
const path = require('path');
const express = require('express');

router.get('/public/videos/:pasta?/:movieName', (req, res) => {
    if (!req.params.pasta)
        res.sendFile(path.resolve('videos') + '/' + req.params.movieName);
    else
        res.sendFile(path.resolve('videos') + '/' + req.params.pasta + '/' + req.params.movieName);
});

router.get('/videos', async (req, res) => {
    var sql = `select * from uploads`;
    return res.json(await knex('uploads').select())
});

router.get("/videos/pasta/:pasta", (req, res) => {
    glob('videos/' + req.params.pasta + '/*.mp4', (err, files) => {
        return res.send(files.map(i => i.replace('videos/', '')));
    });
})
router.use('/html', express.static(path.resolve('teste/dist/')));

router.post('/videos', (req, res, next) => {
    if (req.body.url && req.body.categoria)
        next();
    else if (!req.body.url) {
        console.log(`Variavel req.body: `, req.body)
        res.status(401).json({ msg: 'informe a url' })
    }
    else if (!req.body.categoria) {
        res.status(401).json({ msg: 'informe o lazer' })
    }
}, async (req, res) => {
    let resultado = await downloadVideo(req.body.url);
    if (resultado) {
        var reg = { categoria: req.body.categoria, filename: resultado.filename, path: 'videos/' + resultado.filename };
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