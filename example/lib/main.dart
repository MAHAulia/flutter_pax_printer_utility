import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String statusPrinter = '0';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // getPrinterStatus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterPaxPrinterUtility.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  getPrinterStatus() async {
    String? status = await FlutterPaxPrinterUtility.getStatus;
    setState(() {
      statusPrinter = status!;
    });
  }

  preparePrint() async {
    await FlutterPaxPrinterUtility.init();
    await FlutterPaxPrinterUtility.fontSet(
        EFontTypeAscii.FONT_12_24, EFontTypeExtCode.FONT_16_16);
    await FlutterPaxPrinterUtility.spaceSet(0, 10);
    await FlutterPaxPrinterUtility.setGray(1);
    await FlutterPaxPrinterUtility.printStr("TEST PRINT", null);
    await FlutterPaxPrinterUtility.step(150);
    String? status = await FlutterPaxPrinterUtility.start();
    log(status.toString());
  }

  printQrCode() async {
    await FlutterPaxPrinterUtility.bindPrinter;
    await FlutterPaxPrinterUtility.fontSet(
        EFontTypeAscii.FONT_24_24, EFontTypeExtCode.FONT_24_24);
    await FlutterPaxPrinterUtility.spaceSet(0, 10);
    await FlutterPaxPrinterUtility.setGray(1);
    await FlutterPaxPrinterUtility.printStr('SILAHKAN SCAN QRCODE', null);
    await FlutterPaxPrinterUtility.printStr('\n\n', null);
    await FlutterPaxPrinterUtility.printStr('ID1782363', null);
    await FlutterPaxPrinterUtility.printStr('\n', null);
    await FlutterPaxPrinterUtility.printStr('001', null);
    await FlutterPaxPrinterUtility.printQRCode(
        '190237901273akshfaksdh', 512, 512);
    await FlutterPaxPrinterUtility.printStr('BAKSO', null);
    await FlutterPaxPrinterUtility.step(150);
    var status = await FlutterPaxPrinterUtility.start();
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Running on: $_platformVersion\n'),
                statusPrinter == '1'
                    ? const Text('Status Printer: Connected')
                    : const Text('Status Printer: Disconnected'),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => FlutterPaxPrinterUtility.bindPrinter,
                    child: const Text("BIND PRINTER"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => getPrinterStatus(),
                    child: const Text("GET STATUS PRINTER"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => FlutterPaxPrinterUtility.printReceipt(
                        "TEST PRINT\n\nOK SUCCESS PRINTING\n\n"),
                    child: const Text("TEST PRINT"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => printQrCode(),
                    child: const Text("TEST PRINT QRCODE"),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            try {
              preparePrint();
            } catch (e) {
              log(e.toString());
            }
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.print_rounded),
        ),
      ),
    );
  }
}
