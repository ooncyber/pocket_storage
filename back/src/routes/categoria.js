const router = require('express').Router();
const knex = require("../db/db_util");
const { getCategoriasId } = require('../model/categorias');

router.get('/categorias/:categoria', async (req, res) => {
    console.log('Variavel req.params: ', req.params)
    return res.send(await knex('uploads').select().where({ categoria: req.params.categoria }))
});
router.get('/categorias', async (req, res) => {
    return getCategoriasId().then(e => res.send(e)).catch(e => res.status(500).send(e))
});
module.exports = router;