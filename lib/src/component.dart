import 'package:flutter/cupertino.dart';

class Components {
  // normal border
  static Widget defaultScanBorder(scanFrameSize, frameColor, frameWidth) {
    return Center(
      child: Container(
        width: scanFrameSize.width,
        height: scanFrameSize.height,
        decoration: BoxDecoration(
          border: Border.all(
            width: frameWidth,
            color: frameColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
