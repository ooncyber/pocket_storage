import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<VideoPlayerController> c = [];

  @override
  void initState() {
    super.initState();
    // c = VideoPlayerController.file(
    //   File(
    //       '/data/user/0/com.example.pocket_storage/app_flutter/Cópia de curso story 3.MOV'),
    // )..initialize().then((value) {
    //     setState(() {});
    //   });
    // For sharing images coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
    //     .listen((List<SharedMediaFile> value) {
    //   if (value != null) print('Variavel value: ${value}');
    //   print('ue');
    // }, onError: (err) {
    //   print("getIntentDataStream error: $err");
    // });

    buscar();
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        print('Variavel value: ${value[0].path}');
        value.forEach((element) {
          salvar(element);
        });
      }
    });
  }

  String getNome(String path) =>
      "${path.substring(path.indexOf('cache/') + 6)}";

  salvar(SharedMediaFile file) async {
    var db = await openDatabase('db.db');
    // print('Variavel file.path: ${file.path}');
    var arqNome = getNome(file.path);
    var q = await db.query('registro', where: "nome == '$arqNome'");
    if (q.length == 0) {
      var appDir = await getApplicationDocumentsDirectory();
      var dir = "${appDir.path}/$arqNome";

      // TODO salvar arquivo e dps salvar no banco
      File arq = await File(file.path).copy(dir).then((value) => db.insert(
          'registro', {'path': dir, 'nome': arqNome}).then((value) => null));
      print("variavel arquivo inserido no banco e copiado para celular");
      buscar();
    } else {
      await showDialog(
          context: context,
          builder: (c) => AlertDialog(
                title: Text("Vídeo já está no dispositivo!"),
              ));
    }
  }

  buscar() async {
    var db = await openDatabase('db.db');
    var q = await db.query('registro');
    print('Variavel q (select registro): ${q}');
    if (q.length > 0) {
      c.clear();
      q.forEach(
        (element) {
          c.add(VideoPlayerController.file(
            File(
              element['path'],
            ),
          )..initialize());
        },
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              c.forEach((element) {
                element.value.isPlaying ? element.pause() : element.play();
              });
            });
          },
          child: Icon(
            c.length > 0
                ? c[0].value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow
                : Icons.circle,
          ),
        ),
        appBar: AppBar(
          title: const Text('Pocket Storage'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: c != null
                ? c
                    .map(
                      (i) => Container(
                        height: 50,
                        width: 50,
                        child: VideoPlayer(
                          i,
                        ),
                      ),
                    )
                    .toList()
                : [Text('sem dados')],
          ),
        ),
      ),
    );
  }
}
