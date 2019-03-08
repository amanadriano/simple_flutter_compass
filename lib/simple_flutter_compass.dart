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
    var success = true;
    success = await _channel.invokeMethod("check");
    return success;
  }

  static const mChannel = const EventChannel("com.palawenos.simple_flutter_compas.event");
  static StreamSubscription _compasSubscription;

  static Future<void> listenToCompas(Function listener) async {
    _compasSubscription = mChannel.receiveBroadcastStream().listen((dynamic event) {
      listener(event < 0 ? event * -1 : event);
    }, onError: (dynamic error) {
      print("error $error");
      listener(0);
    });
  }

  /**
   * stops the hardware and cancels the subscription
   */
  static Future<void> stopListenCompas() async {
    _channel.invokeMethod("stop");
    if (_compasSubscription == null) return;
    _compasSubscription.cancel();
  }

  /**
   * for iOS only
   * starts the hardware
   */
  static Future<void> start() async {
    _channel.invokeMethod("start");
  }


}
