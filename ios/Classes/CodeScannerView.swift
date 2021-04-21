import UIKit
import Flutter
import MTBBarcodeScanner


public class CodeScannerView: NSObject, FlutterPlatformView {
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    var registrar: FlutterPluginRegistrar
    var channel: FlutterMethodChannel
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, withRegistrar registrar: FlutterPluginRegistrar) {
        self.previewView = UIView(frame: frame)
        self.registrar = registrar
        self.scanner = MTBBarcodeScanner(previewView: previewView)
        self.channel = FlutterMethodChannel(name: "code_scanner", binaryMessenger: registrar.messenger())
    }
    
    public func view() -> UIView {
        
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: FlutterResult) -> Void in
            
            switch(call.method){
            case "startScan":
                MTBBarcodeScanner.requestCameraPermission(success: { isSuccess in
                    if isSuccess {
                        do {
                            try self.scanner?.startScanning(with: .back ,resultBlock: { codes in
                                if let codes = codes {
                                    for code in codes {
                                        let scanCode = code.stringValue!
                                        self.channel.invokeMethod("receiveScanData", arguments: scanCode)
                                    }
                                }
                            })
                        } catch {
                            NSLog("Unable to start scanning")
                        }
                    } else {
                        UIAlertView(title: "Scanning Unavailable", message: "This app does not have permission to access the camera", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Ok").show()
                    }
                })
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
        return previewView
    }
}
