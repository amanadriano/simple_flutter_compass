# simple_flutter_compass

Simple Flutter Compass for accessing device's current heading (like a compass) using its magnetometer.

## How to use : 
```
- Import the plugin
- create an instance of SimpleFlutterCompass()
- create a listener and set it to the new instance
- call check() to see if device supports or has the hardware needed
- call listen() to start listening for heading changes
- call stopListen() when you're done
```

## Getting Started

Import Plugin
```
import 'package:simple_flutter_compass/simple_flutter_compass.dart';
```

Create Instance
```
SimpleFlutterCompass _simpleFlutterCompass = SimpleFlutterCompass();
```

Check if hardware exists and set a listener
```
_simpleFlutterCompass.check().then((result) {
    if (result) {
        _simpleFlutterCompass.setListener(_streamListener);
    } else {
        print("Hardware not available");
    }
});

void _streamListener(double currentHeading) {
    setState(() {
      //we set the new heading value to our _compas variable to display on screen
      _compas = currentHeading;
    });
}
```

Start listening
```
_simpleFlutterCompass.listen();
```

Stop listening
```
_simpleFlutterCompass.stopListen();
```
