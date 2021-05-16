# code_scanner

QR code scanner plugin for flutter. This plugin responds to camera/photo-lirary usage permission requests.
This plugin function is Scan/Read. "Scan" is scanning QR code by scanner, "Read" is reading qr code by picking up qr code image from photo library.

## Getting Started

### iOS
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
minSdkVersion 24
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
  controller: controller,
)

/// Widget Controller
controller = CodeScannerController();
```
## How to get scan/read data
### How to get scan data
Listern for scanDataStream.
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
