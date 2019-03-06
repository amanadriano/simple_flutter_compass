import 'dart:async';

import 'package:flutter/services.dart';

class SimpleFlutterCompass {
  static const MethodChannel _channel =
  const MethodChannel("com.palawenos.simple_flutter_compas.method");

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> check() async {
    final bool success = await _channel.invokeMethod("check");
    return success;
  }

  static const mChannel = EventChannel("com.palawenos.simple_flutter_compas.event");

  static Future<void> listenToCompas(Function listener) async {
    mChannel.receiveBroadcastStream().listen((dynamic event) {
      double reading = event;
      listener(reading);
    }, onError: (dynamic error) {
      print("error $error");
      return 0;
    });

  }
}
