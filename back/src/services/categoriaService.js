const knex = require("../db/db_util");
class CategoriaService {
    static getAllCategorias() {
        return knex('uploads').select('categoria').select('id').groupBy('categoria')
    }

    static getWhereParams(field, req) {
        return knex('uploads').select().where({ [field]: req.params[field] })
    }
}

module.exports = { CategoriaService }