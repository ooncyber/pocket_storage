const knex = require('knex')({
    client: 'sqlite3',
    useNullAsDefault: '',
    username: 'sa',
    password: 'moi',
    connection: {
        filename: __dirname + '/data.db',
    },
});
knex.schema
    .hasTable('uploads').then(existe => {
        if (!existe)
            knex.schema.createTable('uploads', table => {

                table.increments('id');
                table.string('categoria');
                table.string('filename');
                table.string('path');
            })

    }).then((_) => { });

module.exports = knex;