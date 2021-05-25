//
//  CodeReader.swift
//  code_scanner
//
//  Created by honda on 2021/05/16.
//

import Foundation
import Photos
import PhotosUI


class CodeReader: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate{
    var channel: FlutterMethodChannel
    var controller: FlutterViewController?
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        self.controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init (coder:) is not supported")
    }
    
    
    func setChannel(channel: FlutterMethodChannel){
        self.channel = channel
    }
    
    func getImage(result: @escaping FlutterResult){
        if #available(iOS 14, *){
            // iOS version >= 14
            if PHPhotoLibrary.authorizationStatus(for: .readWrite) != .authorized{
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized || status == .limited {
                        self.handlePHPickerController()
                    }else{
                        result(FlutterError(code: "PERMISSION_DENIED", message: "Photo Library permission denied.", details: ""))
                    }
                }
            } else {
                self.handlePHPickerController()
            }
        } else {
            // iOS version < 14
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        self.handleUIImagePickerController()
                    } else {
                        result(FlutterError(code: "PERMISSION_DENIED", message: "Photo Library permission denied.", details: ""))
                    }
                }
            }
        }
    }
    
    
    @available(iOS 14, *)
    func handlePHPickerController(){
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.controller?.present(picker, animated: true)
    }
    
    // iOS version < 14
    func handleUIImagePickerController(){
        let picker: UIImagePickerController! = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        self.controller?.present(picker, animated: true)
    }
    
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self){ image, error in
                if let image = image as? UIImage {
                    let readData = self.readDatafromUIImage(image: image)
                    self.sendReadData(channel: self.channel, readData: readData)
                }
            }
        }
    }
    
    // iOS version < 14
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let readData = self.readDatafromUIImage(image: image)
        self.sendReadData(channel: self.channel, readData: readData)
    }
    
    
    func readDatafromUIImage(image: UIImage?) -> String{
        var readData = ""
    
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage: CIImage = CIImage(image: image!)!
        let features = detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            readData += feature.messageString!
        }
    
        return readData
    }
    
    func sendReadData(channel: FlutterMethodChannel, readData: String){
        channel.invokeMethod("receiveReadData", arguments: [readData != "", readData])
    }
    
}
