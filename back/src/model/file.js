const knex = require('../db/db_util')
function uploadFile(req) {
    return new Promise((resolve, reject) => {
        const { categoria } = JSON.parse(JSON.stringify(req.body));
        if (!categoria)
            reject({ msg: "Falta categoria", errno: 1 });
        if (!req.file)
            return reject('Problema com servidor')


        const { filename, path } = req.file;

        var reg = { categoria, path, filename };


        return knex('uploads').where({ filename }).then(async rows => {
            if (rows.length == 0) {
                console.log('inserido!');
                await knex("uploads").insert(reg);
                return resolve({ ...reg })
            }
            else {
                console.log('tentativa de inserir duplicado');
                var r = await knex("uploads").select().where({ filename });
                return resolve(r);
            }
        });
    })
}

module.exports = {
    uploadFile
}