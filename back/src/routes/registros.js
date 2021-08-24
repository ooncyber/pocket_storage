const router = require('express').Router();
const knex = require("../db/db_util");

router.get('/registros', async (req, res) => {
    return res.send(await knex('uploads').select('categoria').select('id').groupBy('categoria'));
});

module.exports = router;