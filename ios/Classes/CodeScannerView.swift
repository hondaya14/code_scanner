import UIKit
import Flutter
import AVFoundation
import MTBBarcodeScanner


public class CodeScannerView: NSObject, FlutterPlatformView {
    @IBOutlet var previewView: UIView!
    var scanner: MTBBarcodeScanner?
    var registrar: FlutterPluginRegistrar
    var channel: FlutterMethodChannel
    var reader: CodeReader
    
    public init(withFrame frame: CGRect, viewIdentifier viewId: Int64, withRegistrar registrar: FlutterPluginRegistrar) {
        self.previewView = UIView(frame: frame)
        self.previewView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.registrar = registrar
        self.scanner = MTBBarcodeScanner(previewView: previewView)
        self.channel = FlutterMethodChannel(name: "code_scanner", binaryMessenger: registrar.messenger())
        self.reader = CodeReader.init(channel: self.channel)
    }
    
    public func view() -> UIView {
        
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch(call.method){
            case "startScan":
                self.startScan(result: result)
            case "stopScan":
                self.stopScan(result: result)
            case "turnOnLight":
                self.turnOnLight(result: result)
            case "turnOffLight":
                self.turnOffLight(result: result)
            case "toggleLight":
                self.toggleLight(result: result)
            case "readDataFromGallery":
                self.reader.getImage(result: result)
            default:
                result(FlutterMethodNotImplemented)
                return
            }
        })
        return previewView
    }
    
    
    func startScan(result: @escaping FlutterResult){
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
                    result(FlutterError.init(code: "UNKNOWN", message: "Unable to start scanning.", details: ""))
                }
            } else {
                result(FlutterError(code: "PERMISSION_DENIED", message: "Camera permission denied.", details: ""))
            }
        })
    }
    
    func turnOnLight( result: @escaping FlutterResult){
        if let cs: MTBBarcodeScanner = self.scanner{
            if cs.hasTorch(){
                cs.torchMode = MTBTorchMode.on
            }
        } else {
            return result(FlutterError(code: "NOT_HAS_LIGHT", message: "Light is not available.", details: ""))
        }
    }
    
    func turnOffLight(result: @escaping FlutterResult){
        if let cs: MTBBarcodeScanner = self.scanner{
            if cs.hasTorch(){
                cs.torchMode = MTBTorchMode.off
            }
        } else {
            result(FlutterError(code: "NOT_HAS_LIGHT", message: "Light is not available.", details: ""))
        }
    }
    
    func toggleLight(result: @escaping FlutterResult){
        if let cs: MTBBarcodeScanner = self.scanner{
            if cs.hasTorch(){
                cs.toggleTorch()
            }
        } else {
            result(FlutterError(code: "NOT_HAS_LIGHT", message: "Light is not available.", details: ""))
        }
    }
    
    func stopScan(result: @escaping FlutterResult){
        self.scanner?.stopScanning()
    }
    
}
