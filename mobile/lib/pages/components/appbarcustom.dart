import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Widget appBarCustom(BuildContext context) {
  return AppBar(
    title: const Text('Pocket Storage'),
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () async {
          await mostrarDialogServidor(context);
        },
        icon: Icon(
          Icons.settings,
        ),
      ),
    ],
  );
}

testar(String v) async {
  print('Variavel v: ${v}');
  var res = await http.get(Uri.parse('http://$v'));
  print('Variavel res.body: ${res.body}');
  if (res.body == 'true') {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('IP', v);
  }
}

mostrarDialogServidor(context) async {
  // testo se o 10.0.2.2 retorna true
  var res = await http
      .get(Uri.parse('http://10.0.2.2'))
      .timeout(Duration(seconds: 3))
      .then((value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('IP', '10.0.2.2');
    return '';
  }).catchError((e) async {
    var c = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Defina a url do servidor"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: c,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Digite o endereço IP do servidor",
                ),
                onSubmitted: (v) async {
                  testar(v);
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (c.text.isNotEmpty) testar(c.text);
                    },
                    child: Text("Salvar")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
              ],
            )
          ],
        ),
      ),
    );
  });

  var c = TextEditingController();
}
