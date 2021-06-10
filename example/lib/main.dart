import 'package:code_scanner/code_scanner.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: CodeScannerHome()));
}

class CodeScannerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scanner example'),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CodeScannerExample()),
            );
          },
          child: Icon(Icons.camera_alt),
        ),
      ),
    );
  }
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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        leading: IconButton(
          key: Key('closeButton'),
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context, '');
          },
        ),
      ),
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
            margin: const EdgeInsets.only(top: 350),
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
                  'Scan Data: ${snapshot.data}',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 450),
            padding: const EdgeInsets.all(5.0),
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xcc222222),
              border: Border.all(color: Color(0xcc222222)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: StreamBuilder<String>(
                stream: controller.readDataStream,
                builder: (context, snapshot) {
                  return (snapshot.hasData)
                      ? Text(
                          'Read Data: ${snapshot.data}',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          'Read Failure',
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          textAlign: TextAlign.center,
                        );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 600),
                child: FloatingActionButton(
                  heroTag: "hero1",
                  child: Icon(Icons.lightbulb_outline),
                  backgroundColor: Color(0xcc222222),
                  onPressed: () async {
                    await controller.toggleLight();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 600),
                child: FloatingActionButton(
                  heroTag: "hero2",
                  child: Icon(Icons.photo_library),
                  backgroundColor: Color(0xcc222222),
                  onPressed: () async {
                    await controller.readDataFromGallery();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
