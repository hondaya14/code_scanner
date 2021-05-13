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

}
