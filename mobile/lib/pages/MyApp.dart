import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_storage/pages/categoria.dart';
import 'package:pocket_storage/util/io.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

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
    buscar();
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        // print('Variavel value: ${value[0].path}');
        value.forEach((element) {
          salvarVideo(File(element.path));
          buscar();
        });
      }
    });
  }

  salvarVideo(File file) async {
    var url = Uri.parse('http://10.0.2.2:80');
    var stream = http.ByteStream(file.openRead());

    var request = http.MultipartRequest("POST", url);
    // Map<String, String> headers = {
    //   "Accept": "application/json",
    //   "Authorization": "Bearer " + token
    // };
    // request.headers.addAll(headers);

    var arqNome = getFilename(file.path);

    var multipartFileSign = http.MultipartFile(
        'file', stream, file.lengthSync(),
        filename: arqNome);
    request.files.add(multipartFileSign);

    request.fields.addAll({'categoria': 'lazer'});

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {
      // armazenar resultado (req.file) no banco
      // print('Variavel value: ${value}');
      var dados = jsonDecode(value);
      print('Variavel dados: ${dados}');
      c.add(VideoPlayerController.network(dados['path']
          .toString()
          .replaceAll('http://localhost', 'http://10.0.0.2'))
        ..initialize());
    });
  }

  Future<void> buscar() async {
    var respo = await http.get(Uri.parse('http://10.0.2.2:80'));
    List movies = jsonDecode(respo.body);
    c.clear();
    movies.forEach((element) {
      print(
          ': http://10.0.2.2/movies/${element.toString().replaceAll(' ', '%22')}');
      c.add(VideoPlayerController.network(
          'http://10.0.2.2/movies/' + element.toString().replaceAll(' ', '%20'))
        ..initialize()
        ..play());
    });
    setState(() {});
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
          onPressed: () async {
            await buscar();
          },
          child: Icon(Icons.refresh),
        ),
        appBar: AppBar(
          title: const Text('Pocket Storage'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => buscar(),
          child: Column(
            children: c
                .map((i) => Container(
                      width: 100,
                      height: 100,
                      child: VideoPlayer(i),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget itemCategoria(categoria, context) => Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        categoria['nome'],
      ),
    );
