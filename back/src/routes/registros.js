const { getRegistrosId } = require('../model/registros');

const router = require('express').Router();

router.get('/registros', async (req, res) => {
    return getRegistrosId().then(e => res.send(e)).catch(e=>res.status(500).send(e))
});



module.exports = router;