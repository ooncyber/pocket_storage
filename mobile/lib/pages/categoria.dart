import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pocket_storage/pages/video_full.dart';
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
        .get(Uri.parse("$ip/categorias/${widget.categoria['categoria']}"));
    print('Variavel ip: ${ip}');
    videos = List<Map>.from(jsonDecode(regs.body));
    print('Variavel videos: ${videos}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoFull(
                            url:
                                "$ip/public/videos/${video['filename'].toString().replaceAll(' ', '%20')}")));
              },
              child: Container(
                margin: EdgeInsets.all(8),
                child: VideoPlayer(VideoPlayerController.network(
                    "$ip/public/videos/${video['filename'].toString().replaceAll(' ', '%20')}")
                  ..initialize()),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
