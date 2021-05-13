//
//  CodeScannerViewFactory.swift
//  code_scanner
//
//  Created by honda on 2021/04/19.
//

import Foundation
import Flutter

class CodeScannerViewFactory: NSObject, FlutterPlatformViewFactory {
//    private var messenger: FlutterBinaryMessenger
    var registrar: FlutterPluginRegistrar?
    
    public init(withRegistrar registrar: FlutterPluginRegistrar){
        super.init()
        self.registrar = registrar
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var dict = args as! Dictionary<String, Double>
        return CodeScannerView(withFrame: frame, viewIdentifier: viewId, withRegistrar: registrar!)
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec(readerWriter: FlutterStandardReaderWriter())
      }
}
