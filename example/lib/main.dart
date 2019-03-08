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
  int _compas = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    bool result = await SimpleFlutterCompass.check();
    print(result);
    if (result) {
      await SimpleFlutterCompass.start();
      await SimpleFlutterCompass.listenToCompas((reading) {
        setState(() {
          _compas = reading.ceil();
        });
      });
    } else {
      print("Hardware not available");
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Current Heading : $_compas\n'),
              RaisedButton(
                child: Text("Start"),
                onPressed: () async {
                  await SimpleFlutterCompass.start();
                  await SimpleFlutterCompass.listenToCompas((reading) {
                    setState(() {
                      _compas = reading.ceil();
                    });
                  });
                },
              ),
              RaisedButton(
                child: Text("Stop"),
                onPressed: () {
                  SimpleFlutterCompass.stopListenCompas();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}
