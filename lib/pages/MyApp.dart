import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pocket_storage/pages/categoria.dart';
import 'package:pocket_storage/util/io.dart';
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
    buscar();
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        print('Variavel value: ${value[0].path}');
        value.forEach((element) {
          salvar(element);
          buscar();
        });
      }
    });
  }

  clicouNaTag(arqNome, categoria, file, db) async {
    var appDir = await getApplicationDocumentsDirectory();
    var dir = "${appDir.path}/$arqNome";
    var idCat = categoria['id'];

    File arq = await File(file.path).copy(dir).then((value) => db.insert(
            'registro', {
          'path': dir,
          'nome': arqNome,
          'idCategoria': idCat
        }).then((value) => null));
    print("variavel arquivo inserido na categoria já existente");
  }

  clicouEmSalvar(arqNome, Database db, file, c) async {
    var appDir = await getApplicationDocumentsDirectory();
    var dir = "${appDir.path}/$arqNome";

    // existe?
    var existe = await db.query('categoria', where: 'nome == "${c.text}"');
    int idCat;
    if (existe.length == 0) {
      print('categoria inserida');
      idCat = await db.insert('categoria', {'nome': c.text});
    } else
      idCat = existe[0]['id'];

    // TODO salvar arquivo e dps salvar no banco
    File arq = await File(file.path).copy(dir).then((value) => db.insert(
            'registro', {
          'path': dir,
          'nome': arqNome,
          'idCategoria': idCat
        }).then((value) => null));
    print("variavel arquivo inserido no banco e copiado para celular");
  }

  salvarVideo(context, arqNome, file, db) async {
    TextEditingController c = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        print('Variavel categorias: ${categorias}');
        return AlertDialog(
          title: Text(
              "Digite ou selecione a categoria para o vídeo ${arqNome.split('.')[0]}"),
          content: SingleChildScrollView(
            child: Column(
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
                Container(
                  height: 200,
                  margin: EdgeInsets.all(16),
                  child: GridView.count(
                    childAspectRatio: 4,
                    crossAxisCount: 2,
                    children: categorias
                        .map(
                          (categoria) => InkWell(
                            child: Container(
                              child: itemCategoria(categoria, context),
                              width: 100,
                            ),
                            onTap: () async {
                              clicouNaTag(arqNome, categoria, file, db);
                              await buscar();
                              Navigator.pop(context);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
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
                clicouEmSalvar(arqNome, db, file, c);
                await buscar();
                Navigator.pop(context);
              },
              child: Text("Salvar"),
            )
          ],
        );
      },
    );
  }

  salvar(SharedMediaFile file) async {
    var db = await openDatabase('db.db');
    // print('Variavel file.path: ${file.path}');
    var arqNome = getFilename(file.path);
    var q = await db.query('registro', where: "nome == '$arqNome'");
    buscar();
    if (q.length == 0) {
      salvarVideo(context, arqNome, file, db);
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

    categorias = q;
    setState(() {});
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
        appBar: AppBar(
          title: const Text('Pocket Storage'),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(16),
          child: categorias.length > 0
              ? GridView.count(
                  childAspectRatio: 3,
                  crossAxisCount: 3,
                  children: categorias
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
                      .toList())
              : Center(
                  child: Text(
                    "Sem categorias!",
                    textAlign: TextAlign.center,
                  ),
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
