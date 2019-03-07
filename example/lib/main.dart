import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:simple_flutter_compass/simple_flutter_compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _compas;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool result = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await SimpleFlutterCompass.check();
      if (!result) return;
      await SimpleFlutterCompass.listenToCompas((reading) {
        setState(() {
          _compas = reading.ceil();
        });
      });

    } on PlatformException {

    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Value we got : $_compas\n'),
        ),
      ),
    );
  }

}
