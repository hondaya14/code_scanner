import Flutter
import UIKit

public class SwiftCodeScannerPlugin: NSObject, FlutterPlugin {
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "code_scanner", binaryMessenger: registrar.messenger())
        let instance = SwiftCodeScannerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let factory = CodeScannerViewFactory(withRegistrar: registrar)
        registrar.register(factory, withId: "code_scanner_view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS : " + UIDevice.current.systemVersion)
        case "scanner_start":
            result("")
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    }
}
