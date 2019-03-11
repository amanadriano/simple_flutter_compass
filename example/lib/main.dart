import 'package:flutter/material.dart';
import 'dart:async';

import 'package:simple_flutter_compass/simple_flutter_compass.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _compas = 0;
  SimpleFlutterCompass _simpleFlutterCompass = SimpleFlutterCompass();
  final _toRadians = 3.1416 / 180;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    _simpleFlutterCompass.check().then((result) {
      if (result) {
        //set a function to handle the compass data
        _simpleFlutterCompass.setListener(_streamListener);
      } else {
        print("Hardware not available");
      }
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  /**
   * listener for your stream of compass value changes from android/ios
   */
  void _streamListener(double currentHeading) {
    setState(() {
      //we set the new heading value to our _compas variable to display on screen
      _compas = currentHeading;
    });
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
              Transform.rotate(
                angle: _compas * _toRadians,
                child: FlutterLogo(size: 100.0,),
              ),
              Text('Current Heading : ${_compas.ceil()}\n'),
              RaisedButton(
                child: Text("Start"),
                onPressed: () async {
                  //start listening again, tell android/ios to start listening to sensor changes
                  _simpleFlutterCompass.listen().then((v) {
                    //listen request completed
                  });
                },
              ),
              RaisedButton(
                child: Text("Stop"),
                onPressed: () {
                  //stop listening, tell android/ios to stop monitoring sensor
                  _simpleFlutterCompass.stopListen().then((v) {
                    //stopped request done.
                    setState(() {
                      _compas = 0.0;
                    });
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}
