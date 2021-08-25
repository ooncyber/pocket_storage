import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Categoria extends StatefulWidget {
  const Categoria(this.categoria);

  final Map categoria;

  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria> {
  List<Map> videos = [];
  String ip = '';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      var ipSp = sp.getString('IP');
      setState(() {
        ip = "http://$ipSp";
      });
      carregar();
    });
  }

  void carregar() async {
    // var db = await openDatabase('db.db');

    // var q = await db.query('registro',
    //     where: 'idCategoria = ?', whereArgs: [widget.categoria['id']]);

    // setState(() {
    //   videos = q;
    // });
    // print('Variavel q: ${q}');

    var regs = await http
        .get(Uri.parse("$ip/categoria/${widget.categoria['categoria']}"));
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
                "$ip/videos/${video['filename'].toString().replaceAll(' ', '%20')}")
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
