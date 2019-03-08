import Flutter
import UIKit
import CoreMotion
import CoreLocation

public class SwiftSimpleFlutterCompassPlugin: NSObject, FlutterPlugin, FlutterStreamHandler, CLLocationManagerDelegate {

    private var eventSink : FlutterEventSink?
    private var mRegistrar : FlutterPluginRegistrar?

    private var clLocationManager : CLLocationManager?
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    let channel = FlutterMethodChannel(name: "com.palawenos.simple_flutter_compas.method", binaryMessenger: registrar.messenger())
    let mChannel = FlutterEventChannel(name: "com.palawenos.simple_flutter_compas.event", binaryMessenger: registrar.messenger())
    let instance = SwiftSimpleFlutterCompassPlugin()
    instance.mRegistrar = registrar
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    mChannel.setStreamHandler(instance)
    
    instance.clLocationManager = CLLocationManager()
    instance.clLocationManager?.headingOrientation = CLDeviceOrientation.faceUp
    instance.clLocationManager?.distanceFilter = 1000;
    instance.clLocationManager?.delegate = instance;
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch(call.method) {
        case "check":
            result(CLLocationManager.headingAvailable())
        case "stop":
            stop()
        case "start":
            listenToCompas()
        default:
            result("ok")
    }
  }
    

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    private func listenToCompas() {
        clLocationManager?.startUpdatingHeading()
    }
    
    
    private func stop() {
        clLocationManager?.stopUpdatingHeading()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.eventSink!(newHeading.magneticHeading)
    }
    
    
}
