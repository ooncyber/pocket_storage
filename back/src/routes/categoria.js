const router = require('express').Router();
const knex = require("../db/db_util");
router.get('/:categoria', async (req, res) => {
    console.log('Variavel req.params: ', req.params)
    return res.send(await knex('uploads').select().where({ categoria: req.params.categoria }))
});

module.exports = router;