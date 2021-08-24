const router = require('express').Router();

router.get('/registros', async (req, res) => {
    return res.send(await knex('uploads').select('categoria').select('id').groupBy('categoria'));
});

module.exports = router;