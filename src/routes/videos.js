const router = require('express').Router();
const downloadVideo = require('../util/downloadYoutube');
const knex = require("../db/db_util");
const path = require('path');
const express = require('express');

router.get('/public/videos/:movieName', (req, res) => {
    return res.sendFile(path.resolve('videos') + '/' + req.params.movieName);
});

router.get('/videos', async (req, res) => {
    return res.json(await knex('uploads').select())
});

router.use('/html', express.static(path.resolve('html/dist')));

router.post('/videos', (req, res, next) => {
    if (req.body.url && req.body.categoria)
        next();
    else if (!req.body.url) {
        return res.status(401).json({ msg: 'informe a url' })
    }
    else if (!req.body.categoria) {
        return res.status(401).json({ msg: 'informe o lazer' })
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