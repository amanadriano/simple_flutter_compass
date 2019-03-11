import 'dart:async';

import 'package:flutter/services.dart';

class SimpleFlutterCompass {

  final MethodChannel _channel = MethodChannel("com.palawenos.simple_flutter_compas.method");
  final mChannel = EventChannel("com.palawenos.simple_flutter_compas.event");
  StreamSubscription _compasSubscription;
  Function _listener;

  /**
   * check if hardaware for fetching heading/bearing is available
   */
  Future<bool> check() async {
    var success = true;
    success = await _channel.invokeMethod("check");
    return success;
  }

  /**
   * getter for the stream subscription in case user wasnt to access it directly
   */
  StreamSubscription<double> get StreamCompass {
    return _compasSubscription;
  }

  /**
   * set a listener for your application to wait for new data to come in
   */
  void setListener(Function listener) {
    _listener = listener;
  }

  /**
   * starts monitoring magnetometer service and register a stream receiver
   * all events are passed to the listener callback
   */
  Future<void> listen() async {
    await _channel.invokeMethod("start");
    _compasSubscription = mChannel.receiveBroadcastStream().listen((dynamic event) {
      _listener(event);
    }, onError: (dynamic error) {
      print("error $error");
      _listener(0.0);
    });
  }



  /**
   * stops the hardware and cancels the stream subscription
   */
  Future<void> stopListen() async {
    _channel.invokeMethod("stop"); //need for ios
    if (_compasSubscription == null) return;
    _compasSubscription.cancel();
  }


}
