const router = require('express').Router();
const knex = require("../db/db_util");
const { CategoriaService } = require('../services/categoriaService');

router.get('/categorias/:categoria', async (req, res) => {
    try {
        res.send(await CategoriaService.getWhereParams('categoria', req))
    }
    catch (e) {
        res.status(500).json({ erro: "Erro interno" })
    }
});
router.get('/categorias', async (req, res) => {
    try {
        res.send(await CategoriaService.getAllCategorias())
    }
    catch (e) {
        res.status(500).json({ erro: "Erro interno" })
    }
});
module.exports = router;