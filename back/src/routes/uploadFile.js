const router = require('express').Router();
const knex = require('../db/db_util')
configMulter = require('../multer/config')



router.post('/', configMulter.single('file'), async (req, res, next) => {
    const { categoria } = JSON.parse(JSON.stringify(req.body));
    if (!categoria)
        return res.status(500).json({ msg: "Falta categoria", errno: 1 });
    if (!req.file)
        return res.status(500)


    const { filename, path } = req.file;

    var reg = { categoria, path, filename };


    return knex('uploads').where({ filename }).then(async rows => {
        if (rows.length == 0) {
            console.log('inserido!');
            await knex("uploads").insert(reg);
            return res.send({ ...reg })
        }
        else {
            console.log('tentativa de inserir duplicado');
            var r = await knex("uploads").select().where({ filename });
            return res.send(r);
        }
    });
});

module.exports = router;