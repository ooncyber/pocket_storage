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
          mostrarDialogServidor(context);
        },
        icon: Icon(
          Icons.settings,
        ),
      ),
      IconButton(
        onPressed: () async {
          SharedPreferences.getInstance()
              .then((value) async => await value.remove('IP'));
        },
        icon: Icon(
          Icons.delete,
        ),
      ),
    ],
  );
}

Future<String> mostrarDialogServidor(context) async {
  var c = TextEditingController();
  return await showDialog(
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
              var res = await http.get(Uri.parse('http://$v'));
              print('Variavel res.body: ${res.body}');
              if (res.body == 'true') {
                var sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setString('IP', v);
                Navigator.pop(context, v);
              }
            },
          ),
        ],
      ),
    ),
  );
}
