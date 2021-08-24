const router = require('express').Router();

router.get('/:categoria', async (req, res) => {
    console.log('Variavel req.params: ', req.params)
    return res.send(await knex('uploads').select().where({ categoria: req.params.categoria }))
});

module.exports = router;