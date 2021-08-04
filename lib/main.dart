import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'pages/MyApp.dart';

void main() async {
  WidgetsFlutterBinding();

  // await deleteDatabase('db.db');
  openDatabase('db.db', version: 1, onCreate: (db, v) {
    db.execute(''' 
    create table registro
      (
        id integer primary key autoincrement,
        path text not null unique,
        nome text not null unique
      )
    ''');
    print('db registro criado');
  }).then((value) => runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),
        ),
      ));
}
