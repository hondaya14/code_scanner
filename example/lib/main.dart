import 'package:code_scanner/code_scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CodeScannerExample());
}

class CodeScannerExample extends StatefulWidget {
  @override
  _CodeScannerExampleState createState() => _CodeScannerExampleState();
}

class _CodeScannerExampleState extends State<CodeScannerExample> {
  CodeScannerController controller;
  @override
  void initState() {
    super.initState();
    this.controller = CodeScannerController();
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CodeScanner(
              controller: controller,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 500),
              padding: const EdgeInsets.all(5.0),
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xcc222222),
                border: Border.all(color: Color(0xcc222222)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Scan code',
                style: TextStyle(color: Colors.white, fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 400),
              padding: const EdgeInsets.all(5.0),
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xcc222222),
                border: Border.all(color: Color(0xcc222222)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: StreamBuilder<String>(
                stream: controller.scanDataStream,
                builder: (context, snapshot) {
                  return Text(
                    'Data: ${snapshot.data}',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 600),
              child: FloatingActionButton(
                child: Icon(Icons.lightbulb_outline),
                backgroundColor: Color(0xcc222222),
                onPressed: () async {
                  await controller.toggleLight();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
