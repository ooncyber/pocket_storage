const knex = require("../db/db_util");
function getRegistrosId() {
    return new Promise(async (resolve, reject) => {
        try {
            resolve(await knex('uploads').select('categoria').select('id').groupBy('categoria'));
        } catch (err) {
            reject(err);
        }
    })
}

module.exports = {
    getRegistrosId
}