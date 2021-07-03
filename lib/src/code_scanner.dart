import 'dart:async';

import 'package:code_scanner/src/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exception.dart';

class CodeScanner extends StatefulWidget {
  const CodeScanner({
    required this.controller,
    this.isScanFrame = false,
    this.scanFrameSize,
    this.frameWidth = 8,
    this.frameColor = const Color(0xffffffff),
  });

  /// CodeScanner needs [CodeScannerController] instance.
  final CodeScannerController controller;

  /// scan frame
  final bool isScanFrame;

  /// Scan frame
  final Size? scanFrameSize;

  /// frame width
  final double frameWidth;

  /// frame color
  final Color frameColor;

  @override
  State<StatefulWidget> createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  static const MethodChannel _channel = const MethodChannel('code_scanner');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    final Size defaultSize = Size(width, width);
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Stack(
          children: [
            AndroidView(
              viewType: 'code_scanner_view',
              onPlatformViewCreated: startScan,
              creationParams: {},
              creationParamsCodec: const StandardMessageCodec(),
            ),
            widget.isScanFrame
                ? Components.defaultScanBorder(
                    widget.scanFrameSize ?? defaultSize,
                    widget.frameColor,
                    widget.frameWidth,
                  )
                : Container(),
          ],
        );
      case TargetPlatform.iOS:
        return Stack(
          children: [
            UiKitView(
              viewType: 'code_scanner_view',
              onPlatformViewCreated: startScan,
              creationParams: {},
              creationParamsCodec: const StandardMessageCodec(),
            ),
            widget.isScanFrame
                ? Components.defaultScanBorder(
                    widget.scanFrameSize ?? defaultSize,
                    widget.frameColor,
                    widget.frameWidth,
                  )
                : Container(),
          ],
        );
      default:
        throw UnsupportedError('Unsupport platform');
    }
  }

  /// Start scan code.
  /// This method is called automatically when Platform View Created.
  Future<void> startScan(int id) async {
    try {
      await _channel.invokeMethod('startScan');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }
}

/// Controller of [CodeScanner].
/// manage screen([CodeScanner]) state by calling method from instance of [CodeScannerController].
class CodeScannerController {
  static const MethodChannel _channel = const MethodChannel('code_scanner');
  CodeScannerController() {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'receiveScanData':
            final receivedData = call.arguments;
            if (receivedData != null) {
              if (_scanDataStreamController.hasListener) {
                _scanDataStreamController.sink.add(receivedData.toString());
              }
            }
            break;
          case 'receiveReadData':
            final receivedData = call.arguments;
            final isSuccess = receivedData[0];
            final readData = receivedData[1];
            if (isSuccess) {
              streamData(_isSuccessReadDataStreamController, isSuccess);
              streamData(_readDataStreamController, readData);
              break;
            }
            streamData(_isSuccessReadDataStreamController, false);
            streamData(_readDataStreamController, null);
            break;
        }
      },
    );
  }

  void streamData(StreamController sc, dynamic value) {
    if (sc.hasListener) {
      sc.sink.add(value);
    }
  }

  StreamController<String> _scanDataStreamController =
      StreamController<String>.broadcast();

  StreamController<bool> _isSuccessReadDataStreamController =
      StreamController<bool>.broadcast();

  StreamController<String> _readDataStreamController =
      StreamController<String>.broadcast();

  /// Listen for [scanDataStream] to get scan data.
  Stream<String> get scanDataStream => _scanDataStreamController.stream;

  /// Listen for [isSuccessReadDataStream] to confirm to be able to get read data.
  Stream<bool> get isSuccessReadDataStream =>
      _isSuccessReadDataStreamController.stream;

  /// Listen for [readDataStream] to get read data.
  Stream<String> get readDataStream => _readDataStreamController.stream;

  void dispose() {
    this.stopScan();
    _scanDataStreamController.close();
    _isSuccessReadDataStreamController.close();
    _readDataStreamController.close();
  }

  /// Stop scan code.
  Future<void> stopScan() async {
    try {
      await _channel.invokeMethod('stopScan');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }

  /// turn on light
  Future<void> lightON() async {
    try {
      await _channel.invokeMethod('turnOnLight');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }

  /// turn off light
  Future<void> lightOFF() async {
    try {
      await _channel.invokeMethod('turnOffLight');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }

  /// toggle light
  /// when light is turning on, then turn off light vice versa.
  Future<void> toggleLight() async {
    try {
      await _channel.invokeMethod('toggleLight');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }

  Future<void> readDataFromGallery() async {
    try {
      await _channel.invokeMethod('readDataFromGallery');
    } on PlatformException catch (e) {
      throw CodeScannerException(e.code, e.message);
    }
  }
}
