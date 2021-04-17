
import 'dart:async';

import 'package:flutter/services.dart';

class CodeScanner {
  static const MethodChannel _channel =
      const MethodChannel('code_scanner');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
