import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_flutter_compass/simple_flutter_compass.dart';

void main() {
  const MethodChannel channel = MethodChannel('simple_flutter_compass');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SimpleFlutterCompass.platformVersion, '42');
  });
}
