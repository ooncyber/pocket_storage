const knex = require('knex')({
    client: 'sqlite3',
    connection: {
        filename: __dirname+'/data.db',
    },
});
knex.schema
    .createTableIfNotExists('uploads', table => {
        table.increments('id');
        table.string('categoria');
        table.string('filename');
        table.string('path');
    }).then((_) => { });

module.exports = knex;