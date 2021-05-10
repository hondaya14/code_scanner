import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exception.dart';

class CodeScanner extends StatefulWidget {
  const CodeScanner({
    @required this.controller,
    this.width,
    this.height,
  });

  /// CodeScanner needs [CodeScannerController] instance.
  final CodeScannerController controller;

  /// [CodeScanner] screen width. default value is device width.
  final int width;

  /// [CodeScanner] screen width. default value is device height.
  final int height;

  @override
  State<StatefulWidget> createState() => _CodeScannerState();
}

///
class _CodeScannerState extends State<CodeScanner> {
  static const MethodChannel _channel = const MethodChannel('code_scanner');
  String scanData = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ratio = MediaQuery.of(context).devicePixelRatio;
    final width = widget.width ?? size.width.toInt();
    final height = widget.height ?? size.height.toInt();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'code_scanner_view',
          onPlatformViewCreated: startScan,
          creationParams: {
            'width': width,
            'height': height,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'code_scanner_view',
          onPlatformViewCreated: startScan,
          creationParams: {
            'width': width,
            'height': height,
          },
          creationParamsCodec: const StandardMessageCodec(),
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
        }
      },
    );
  }

  StreamController<String> _scanDataStreamController =
      StreamController<String>();

  /// Listen for [scanDataStream] to get scan data.
  Stream<String> get scanDataStream => _scanDataStreamController.stream;

  void dispose() {
    _scanDataStreamController.close();
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
}
