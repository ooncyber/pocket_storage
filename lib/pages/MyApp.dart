import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_storage/pages/categoria.dart';
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
      // var appDir = await getApplicationDocumentsDirectory();
      // var dir = "${appDir.path}/$arqNome";

      // // TODO salvar arquivo e dps salvar no banco
      // File arq = await File(file.path).copy(dir).then((value) => db.insert(
      //     'registro', {'path': dir, 'nome': arqNome, 'categoria': categoria}).then((value) => null));
      // print("variavel arquivo inserido no banco e copiado para celular");
      // mostrar dialog p pegar categoria
      TextEditingController c = TextEditingController();
      await showDialog(
        context: context,
        builder: (context) {
          print('Variavel categorias: ${categorias}');
          return AlertDialog(
            title: Text(
                "Digite ou selecione a categoria para o vídeo ${arqNome.split('.')[0]}"),
            content: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: TextField(
                    focusNode: FocusNode()..requestFocus(),
                    decoration: InputDecoration(
                        labelText: "Digite o nome da categoria"),
                    controller: c,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, top: 16),
                    child: GridView.count(
                      childAspectRatio: 3,
                      crossAxisCount: 2,
                      children: categorias
                          .map(
                            (categoria) => InkWell(
                              child: itemCategoria(categoria, context),
                              onTap: () async {
                                //
                                var appDir =
                                    await getApplicationDocumentsDirectory();
                                var dir = "${appDir.path}/$arqNome";

                                // existe?
                                var idCat = categoria['id'];

                                // TODO salvar arquivo e dps salvar no banco
                                File arq = await File(file.path).copy(dir).then(
                                    (value) => db.insert('registro', {
                                          'path': dir,
                                          'nome': arqNome,
                                          'idCategoria': idCat
                                        }).then((value) => null));
                                print(
                                    "variavel arquivo inserido na categoria já existente");

                                await buscar();
                                Navigator.pop(context);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (c.text.isEmpty) return;
                  var appDir = await getApplicationDocumentsDirectory();
                  var dir = "${appDir.path}/$arqNome";

                  // existe?
                  var existe =
                      await db.query('categoria', where: 'nome == "${c.text}"');
                  int idCat;
                  if (existe.length == 0) {
                    print('categoria inserida');
                    idCat = await db.insert('categoria', {'nome': c.text});
                  } else
                    idCat = existe[0]['id'];

                  // TODO salvar arquivo e dps salvar no banco
                  File arq = await File(file.path).copy(dir).then((value) => db
                          .insert('registro', {
                        'path': dir,
                        'nome': arqNome,
                        'idCategoria': idCat
                      }).then((value) => null));
                  print(
                      "variavel arquivo inserido no banco e copiado para celular");

                  await buscar();
                  Navigator.pop(context);
                },
                child: Text("Salvar"),
              )
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text("Vídeo já está no dispositivo!"),
        ),
      );
    }
  }

  buscar() async {
    var db = await openDatabase('db.db');

    var q = await db.query('categoria');

    print('Variavel await db.query("registro"): ${await db.query("registro")}');

    categorias = q;
    setState(() {});
    // var q = await db.query('registro');
    // print('Variavel q (select registro): ${q}');
    // if (q.length > 0) {
    //   c.clear();
    //   q.forEach(
    //     (element) {
    //       c.add(VideoPlayerController.file(
    //         File(
    //           element['path'],
    //         ),
    //       )..initialize());
    //     },
    //   );
    //   setState(() {});
    // }
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  List<Map> categorias = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(
        //       () {
        //         c.forEach(
        //           (element) {
        //             element.value.isPlaying ? element.pause() : element.play();
        //           },
        //         );
        //       },
        //     );
        //   },
        //   child: Icon(
        //     c.length > 0
        //         ? c[0].value.isPlaying
        //             ? Icons.pause
        //             : Icons.play_arrow
        //         : Icons.circle,
        //   ),
        // ),
        appBar: AppBar(
          title: const Text('Pocket Storage'),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 32, left: 32),
          child: GridView.count(
            childAspectRatio: 3,
            crossAxisCount: 3,
            children: categorias.length > 0
                ? categorias
                    .map(
                      (categoria) => InkWell(
                        child: itemCategoria(categoria, context),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Categoria(categoria),
                            ),
                          );
                        },
                      ),
                    )
                    .toList()
                : [
                    Text(
                      "Sem categorias!",
                    ),
                  ],
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
