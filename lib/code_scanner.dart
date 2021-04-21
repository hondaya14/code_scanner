import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CodeScanner extends StatefulWidget {
  const CodeScanner({
    @required this.controller,
  });

  final CodeScannerController controller;

  @override
  State<StatefulWidget> createState() => _CodeScannerState();
}

class _CodeScannerState extends State<CodeScanner> {
  static const MethodChannel _channel = const MethodChannel('code_scanner');
  String scanData = 'null';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return UiKitView(
      viewType: 'code_scanner_view',
      onPlatformViewCreated: startScan,
      creationParams: {
        'width': size.width,
        'height': size.height,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  void startScan(int id) async {
    await _channel.invokeMethod('startScan');
  }
}

class CodeScannerController {
  static const MethodChannel _channel = const MethodChannel('code_scanner');
  CodeScannerController() {
    _channel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case 'receiveScanData':
            if (call.arguments != null) {
              if (_scanDataStreamController.hasListener) {
                _scanDataStreamController.sink.add(call.arguments.toString());
              }
            }
        }
      },
    );
  }

  StreamController<String> _scanDataStreamController =
      StreamController<String>();
  Stream<String> get scanDataStream => _scanDataStreamController.stream;

  void dispose() {
    _scanDataStreamController.close();
  }
}
