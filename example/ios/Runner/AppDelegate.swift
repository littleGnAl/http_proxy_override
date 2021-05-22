import UIKit
import Flutter
import http_proxy_override

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
        name: "com.littlegnal.http_proxy_override.test",
      binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { (_ call: FlutterMethodCall, result: @escaping FlutterResult) in
        guard let arguments = call.arguments as? [String: AnyObject] else {
            result(nil)
            return
        }
        
        switch call.method {
        case "enableMockProxy":
            setMockProxySetting(
                host: arguments["host"] as? String,
                port: arguments["port"] as? String)
            result(true)
        case "disableProxy":
            setMockProxySetting(host: nil, port: nil)
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
