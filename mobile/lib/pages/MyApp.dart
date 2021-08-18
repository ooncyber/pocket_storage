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

    File arq = await File(file.path).copy(dir);
    await db.insert(
        'registro', {'path': dir, 'nome': arqNome, 'idCategoria': idCat});
    print("variavel arquivo inserido na categoria já existente");
    await buscar();
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
    File arq = await File(file.path).copy(dir);
    db.insert('registro', {'path': dir, 'nome': arqNome, 'idCategoria': idCat});
    print("variavel arquivo inserido no banco e copiado para celular");
    await buscar();
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
          content: Container(
            width: 300,
            height: 300,
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
                  width: 300,
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

  deletar() async {
    var db = await openDatabase('db.db');
    var q = await db.query('registro');
    q.forEach((registro) {
      File(registro['path']).delete(recursive: true);
      db.delete('registro', where: 'id == "${registro['id']}"');
    });
    db.delete('categoria');

    buscar();
  }

  Future<void> buscar() async {
    var db = await openDatabase('db.db');
    var q = await db.query('categoria');

    print('Variavel q: ${q}');

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
        floatingActionButton: FloatingActionButton(
          onPressed: () async => await buscar(),
          child: Icon(Icons.refresh),
        ),
        appBar: AppBar(
          title: const Text('Pocket Storage'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                deletar();
              },
              icon: Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => buscar(),
          child: Container(
            margin: EdgeInsets.all(16),
            child: categorias.length > 0
                ? GridView.count(
                    childAspectRatio: 3,
                    crossAxisCount: 3,
                    children: categorias
                        .map(
                          (categoria) => InkWell(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                child: itemCategoria(categoria, context)),
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
