import 'dart:io';

import 'package:drcode/main.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  TextEditingController qrcodeController = TextEditingController();
  Barcode? result;
  QRViewController? scancontroller;
  final GlobalKey scanKey = GlobalKey(debugLabel: 'QR');
  @override
  void dispose() {
    scancontroller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await scancontroller!.pauseCamera();
    } else {
      scancontroller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("QRCODE SCANNER"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code))
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await scancontroller!.toggleFlash();
              },
              icon: Icon(Icons.flash_off),
            ),
            Expanded(child: Container(child: buildQrView(context))),
            Text(result != null ? '${result!.code}' : "ok"),
            TextFormField(
              controller: qrcodeController,
              decoration: const InputDecoration(
                  hintText: "Type your QRcode here",
                  border: OutlineInputBorder()),
            ),
          ]),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: scanKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
            // cutOutBottomOffset: MediaQuery.of(context).size.width*0.8,
            //borderWidth: 10,
            //     borderRadius: 10,
            // borderLength: 20,
            borderColor: Colors.white),
      );

  void onQRViewCreated(QRViewController scancontroller) {
    setState(() => this.scancontroller = scancontroller);
    scancontroller.scannedDataStream.listen((result) {
      setState(() => this.result = result);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(codevalue: '${result.code}'),
          ));
    });
  }
}
