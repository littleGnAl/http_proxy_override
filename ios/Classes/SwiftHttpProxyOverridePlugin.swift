import Flutter
import UIKit

/// `mockProxySetting` allow us to set a mock proxy setting in integration test, and it should only be used in test
private var mockProxySetting: [String : AnyObject]? = nil
public func setMockProxySetting(host: String? = nil, port: String? = nil) {
    if (host == nil || port == nil) {
        mockProxySetting = nil
    } else {
        mockProxySetting = [
            "HTTPEnable": true,
            "HTTPProxy": host!,
            "HTTPPort": Int(port!)!
        ] as [String : AnyObject]?
    }
}

public class SwiftHttpProxyOverridePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
        name: "com.littlegnal.http_proxy_override",
        binaryMessenger: registrar.messenger())
    let instance = SwiftHttpProxyOverridePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let proxiesSettings = getProxySettings() else {
        result(nil);
        return
    }
    
    let isHttpEnable = proxiesSettings["HTTPEnable"] as? Bool ?? false
    if (!isHttpEnable) {
        result(nil);
        return
    }
    
    switch call.method {
    case "getProxyHost":
        result(proxiesSettings["HTTPProxy"] as? String)
    case "getProxyPort":
        let port = proxiesSettings["HTTPPort"] as? Int
        if port != nil {
            result("\(port!)")
        } else {
            result(nil)
        }
    default:
        result(FlutterMethodNotImplemented)
    }
  }
    
    private func getProxySettings() -> [String : AnyObject]? {
        if (mockProxySetting != nil) {
            return mockProxySetting
        }
        
        guard let proxiesSettingsUnmanaged = CFNetworkCopySystemProxySettings() else {
            return nil
        }
        guard let proxiesSettings = proxiesSettingsUnmanaged.takeRetainedValue() as? [String : AnyObject] else {
            return nil
        }
        
        return proxiesSettings
    }
}
