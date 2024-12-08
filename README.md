> [!WARNING]
> # [ This is not under maintainance. ]

# code_scanner
[![pub](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev/packages/code_scanner)

QR code scanner plugin for flutter. This plugin responds to camera/photo-lirary usage permission requests.
This plugin function is Scan/Read. "Scan" is scanning QR code by scanner, "Read" is reading qr code by picking up qr code image from photo library.

<center><img src="medias/screen_shot.jpg" width="200"></center>

### iOS
Support for iOS > 8.0  
Please add as follows in <code>info.plist</code>
```
<key>NSCameraUsageDescription</key>
<string></string>
<key>NSPhotoLibraryUsageDescription</key>
<string></string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### Android
```
minSdkVersion 23
```
Please add as follows in <code>Manifest.xml</code>
```xml
<manifest ... xmlns:tools="http://schemas.android.com/tools">
                    :
  <uses-sdk tools:overrideLibrary="com.google.zxing.client.android" />
</manifest>
```

## Dependent library
iOS:  [MTBBarcodeScanner](https://github.com/mikebuss/MTBBarcodeScanner)
<br>
Android:  [zxing-android-embedded](https://github.com/journeyapps/zxing-android-embedded)


## How to use
### View & View Controller
```dart
/// Scan Widget
CodeScanner(
  controller : controller,
  isScanFrame : true, // optional
  scanFrameSize : Size(200, 200), // optional
  frameWidth : 8, // optional
  frameColor : Color(0xcc222222), // optional
)

/// Widget Controller
controller = CodeScannerController();
```
## How to get scan/read data
### How to get scan data
Listen for scanDataStream.
```dart
/// scan data
controller.scanDataStream
```
### How to get read data
If reading qr image from photo gallery is success, true value flows through isSuccessReadDataStream.  
If reading qr image from photo gallery is failure, false value flows through isSuccessReadDataStream.  
You can detect read result without isSuccessReadDataStream. You Listen for only readDataStream, it is flowed two value pattern, one is actual read data, another is null when reading is failure
```dart
/// flag of successful read
controller.isSuccessReadDataStream

/// read data
controller.readDataStream
```
### Method
#### start scanning (This method is called automatically when CodeScanner is created.)
```dart
await controller.startScan();
```
#### stop scanning (this method is called on controller dispose method as default.)
```dart
await controller.stopScan();
```
#### Read code from image gallery
```dart
await controller.readDataFromGallery();
```
#### Turn on light
```dart
await controller.lightON();
```
#### Turn off light
```dart
await controller.lightOFF();
```
#### Toggle light
```dart
await controller.toggleLight();
```
