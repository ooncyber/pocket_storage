import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';
import 'package:pocket_storage/pages/categoria.dart';
import 'package:pocket_storage/util/io.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';

import 'package:http/http.dart' as http;

import 'components/appbarcustom.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription _intentDataStreamSubscription;
  List<VideoPlayerController> c = [];
  List<Map> categorias = [];

  String ip = '10.0.2.2';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      var ipSp = sp.getString('IP');
      if (ip == null) {
        mostrarDialogServidor(context)
            .then((value) => print('Variavel value: ${value}'));
      } else
        setState(() {
          ip = "http://$ipSp";
        });
    });
    print('Variavel ip: ${ip}');
    buscar();
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value != null && value.length > 0) {
        // print('Variavel value: ${value[0].path}');
        value.forEach((element) {
          var c = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Novo vídeo recebido"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Digite o nome da categoria "),
                  TextField(
                    controller: c,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (c.text.isNotEmpty) {
                      salvarVideo(File(element.path), c.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Salvar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar"),
                ),
              ],
            ),
          );
          buscar();
        });
      }
    });
    // For sharing or opening urls/text coming from outside the app while the app is closed
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) async {
      var c = TextEditingController();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Novo vídeo baixado"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Digite o nome da categoria "),
              TextField(
                controller: c,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (c.text.isNotEmpty) {
                  var r = await http.post(Uri.parse(ip + '/videos'),
                      headers: {
                        'Content-type': 'application/json',
                        'Accept': 'application/json',
                      },
                      body: json.encode({'url': value, 'categoria': c.text}));
                  print('Variavel r: ${r.body}');
                  Navigator.pop(context);
                }
              },
              child: Text("Salvar"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
          ],
        ),
      );
      buscar();
    }, onError: (err) {
      print("getLinkStream error: $err");
    });
  }

  salvarVideo(File file, String txtCategoria) async {
    var url = Uri.parse(ip + '/uploadFile');
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

    request.fields.addAll({'categoria': txtCategoria});

    await request.send();
    buscar();
  }

  Future<void> buscar() async {
    print('Variavel ip: ${ip}');
    var respo = await http.get(Uri.parse(ip + '/registros'));
    categorias = List<Map>.from(jsonDecode(respo.body));
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
        appBar: appBarCustom(context),
        body: RefreshIndicator(
            onRefresh: () => buscar(),
            child: categorias.length > 0
                ? Container(
                    margin: EdgeInsets.all(16),
                    child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        children: categorias
                            .map((i) => Container(
                                  padding: EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(Colors
                                                  .primaries[
                                              math.Random().nextInt(
                                                  Colors.primaries.length)]),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Categoria(
                                            i,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      i['categoria'],
                                    ),
                                  ),
                                ))
                            .toList()),
                  )
                : Center(
                    child: Text("Sem vídeos!"),
                  )),
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
