# simple_flutter_compass_example

Demonstrates how to use the simple_flutter_compass plugin.

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
