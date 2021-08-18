import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';

class Categoria extends StatefulWidget {
  const Categoria(this.categoria);

  final Map categoria;

  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  @override
  void initState() {
    super.initState();
    carregar();
  }

  void carregar() async {
    var db = await openDatabase('db.db');

    var q = await db.query('registro',
        where: 'idCategoria = ?', whereArgs: [widget.categoria['id']]);

    setState(() {
      videos = q;
    });
    print('Variavel q: ${q}');
  }

  List<Map> videos = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria['nome']),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: videos.map(
          (video) {
            var controller = VideoPlayerController.file(
              File(
                video['path'],
              ),
            )..initialize();
            return InkWell(
              onTap: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              },
              child: Container(
                margin: EdgeInsets.all(8),
                child: VideoPlayer(
                  controller,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
