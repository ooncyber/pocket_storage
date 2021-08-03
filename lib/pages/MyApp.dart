import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = const MethodChannel("com.example.pocket_storage/ch");

  @override
  void initState() {
    super.initState();
  }

  String valor = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  printy();
                },
                child: Text(valor)),
          ],
        ),
      ),
    );
  }

  void printy() async {
    String v = '';
    try {
      v = await platform.invokeMethod('Printy');
      setState(() {
        valor = v;
      });
    } catch (e) {
      print(e);
    }
  }
}
