import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/MyApp.dart';

void main() async {
  WidgetsFlutterBinding();

  //await deleteDatabase('db.db');
  await openDatabase('db.db', version: 1, onCreate: (db, v) {
    db.execute(''' 
    create table categoria
    (
      id integer primary key autoincrement,
      nome text not null
    );
    ''');
    db.execute('''
    create table registro
      (
        id integer primary key autoincrement,
        path text not null unique,
        nome text not null unique,
        idCategoria int not null,
        foreign key(idCategoria) references categoria(id)
      )
    ''');
    print('db registro criado');
  });
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}
