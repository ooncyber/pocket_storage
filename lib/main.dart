import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/MyApp.dart';

void main() async {
  WidgetsFlutterBinding();

  // await deleteDatabase('db.db');
  await openDatabase('db.db', version: 13, onCreate: (db, v) async {
    db
        .execute('drop table if exists registro')
        .then((value) => db.execute('drop table if exists categoria'))
        .then(
          (value) => db.execute(''' 
    create table categoria
    (
      id integer primary key autoincrement,
      nome text not null
    );
    ''').then(
            (value) => db.execute('''
    create table registro
      (
        id integer primary key autoincrement,
        path text not null unique,
        nome text not null unique,
        idCategoria int not null,
        foreign key(idCategoria) references categoria(id)
      )
    '''),
          ),
        );
    print('db registro criado');
  });
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
