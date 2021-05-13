# code_scanner

QR code scanner plugin for flutter. This plugin responds to camera usage permission requests.

## Getting Started

### iOS
Please add as follows in <code>info.plist</code>
```
<key>NSCameraUsageDescription</key>
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
### How to get scanData
Listern for scanDataStream.
```dart
controller.scanDataStream
```
### Method
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
