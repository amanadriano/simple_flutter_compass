import Flutter
import UIKit
import CoreMotion

public class SwiftSimpleFlutterCompassPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

    private var eventSink : FlutterEventSink?
    private var motionManager :CMMotionManager?
    private var operationQue = OperationQueue()
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    let channel = FlutterMethodChannel(name: "com.palawenos.simple_flutter_compas.method", binaryMessenger: registrar.messenger())
    let mChannel = FlutterEventChannel(name: "com.palawenos.simple_flutter_compas.event", binaryMessenger: registrar.messenger())
    let instance = SwiftSimpleFlutterCompassPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    mChannel.setStreamHandler(instance)
    instance.motionManager = CMMotionManager()
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch(call.method) {
        case "check":
            result(motionManager?.isMagnetometerAvailable);
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
        motionManager?.magnetometerUpdateInterval = 1
        motionManager?.startMagnetometerUpdates(to: self.operationQue, withHandler: self.handler)
    }
    
    private func handler(data: CMMagnetometerData?, error: Error?) {
        self.eventSink!(1);
    }
    
    private func stop() {
        motionManager?.stopMagnetometerUpdates();
    }
    
}
