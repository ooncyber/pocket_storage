import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Categoria extends StatefulWidget {
  const Categoria(this.categoria);

  final Map categoria;

  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  List<Map> videos = [];
  @override
  void initState() {
    super.initState();
    carregar();
  }

  void carregar() async {
    // var db = await openDatabase('db.db');

    // var q = await db.query('registro',
    //     where: 'idCategoria = ?', whereArgs: [widget.categoria['id']]);

    // setState(() {
    //   videos = q;
    // });
    // print('Variavel q: ${q}');

    var regs = await http.get(Uri.parse(
        "http://10.0.2.2/categoria/${widget.categoria['categoria']}"));
    videos = List<Map>.from(jsonDecode(regs.body));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('Variavel videos: ${videos}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria['categoria']),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        // children: [],
        children: videos.map(
          (video) {
            var controller = VideoPlayerController.network(
                "http://10.0.2.2/videos/${video['filename'].toString().replaceAll(' ', '%20')}")
              ..initialize();
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
