# simple_flutter_compass

Simple Flutter Compass for accessing device's current heading (like a compass) using its magnetometer.

How to use : 
- Import the plugin
- create an instance of SimpleFlutterCompass()
- create a listener and set it to the new instance
- call check() to see if device supports or has the hardware needed
- call listen() to start listening for heading changes
- call stopListen() when you're done


Import Plugin
import 'package:simple_flutter_compass/simple_flutter_compass.dart';

Create Instance
SimpleFlutterCompass _simpleFlutterCompass = SimpleFlutterCompass();

Create and set litsener
void _streamListener(double currentHeading) {
  //do something with the currentHeading
}

_simpleFlutterCompass.setListener(_streamListener);

Check if hardware is present
__simpleFlutterCompass.check();

Start listening
_simpleFlutterCompass.listen();

Stop listening
_simpleFlutterCompass.stopListen();


Please check the example app for reference on actual plugin usage.
