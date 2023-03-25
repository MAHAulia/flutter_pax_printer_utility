import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _platformVersion = 'Unknown';
  String statusPrinter = '0';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getPrinterStatus();
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
    await FlutterPaxPrinterUtility.init;
    PrinterStatus status = await FlutterPaxPrinterUtility.getStatus;
    print(status);
    setState(() {
      if (status == PrinterStatus.SUCCESS) {
        statusPrinter = "1";
      } else {
        statusPrinter = "0";
      }
    });
  }

  printQrCode() async {
    await FlutterPaxPrinterUtility.init;
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

  printImage() async {
    await FlutterPaxPrinterUtility.init;
    await FlutterPaxPrinterUtility.fontSet(
        EFontTypeAscii.FONT_24_24, EFontTypeExtCode.FONT_24_24);
    await FlutterPaxPrinterUtility.spaceSet(0, 10);
    await FlutterPaxPrinterUtility.setGray(1);
    await FlutterPaxPrinterUtility.printStr('TEST PRINT IMAGE', null);
    await FlutterPaxPrinterUtility.printImageAsset(
        'assets/images/maha_bg_white.png');
    await FlutterPaxPrinterUtility.step(150);
    var status = await FlutterPaxPrinterUtility.start();
    return status;
  }

  printImageNetwork() async {
    await FlutterPaxPrinterUtility.init;
    await FlutterPaxPrinterUtility.fontSet(
        EFontTypeAscii.FONT_24_24, EFontTypeExtCode.FONT_24_24);
    await FlutterPaxPrinterUtility.spaceSet(0, 10);
    await FlutterPaxPrinterUtility.setGray(1);
    await FlutterPaxPrinterUtility.printStr('TEST PRINT IMAGE NETWORK', null);
    await FlutterPaxPrinterUtility.printImageUrl(
        "http://pudim.com.br/pudim.jpg");
    await FlutterPaxPrinterUtility.step(150);
    var status = await FlutterPaxPrinterUtility.start();
    return status;
  }

  Future<void> _manualPrintWithBitmap() async {
    setState(() => isLoading = true);
    // Init printer, makesure printer is ready to print
    await FlutterPaxPrinterUtility.init;

    // Set Gray level
    await FlutterPaxPrinterUtility.setGray(3);

    // // for printing image from asset, make sure dimension of file, because we can't set image size manualy here
    await FlutterPaxPrinterUtility.printImageAsset(
        "assets/images/auria_icon.png");

    // Set fontset
    await FlutterPaxPrinterUtility.fontSet(
        EFontTypeAscii.FONT_16_24, EFontTypeExtCode.FONT_16_32);

    await FlutterPaxPrinterUtility.leftIndents(10);
    await FlutterPaxPrinterUtility.printStr(
        "          Aulia Shop     \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "           Jl. Banda     \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "            Bandung      \n", null);
    await FlutterPaxPrinterUtility.printStr("\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "TID    : 123456           \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "Peymen : CASH             \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "Date   : ${DateTime.now().toLocal()}\n", null);
    await FlutterPaxPrinterUtility.printStr("\n", null);
    await FlutterPaxPrinterUtility.setDoubleWidth(true, true);
    await FlutterPaxPrinterUtility.setDoubleHeight(true, true);
    await FlutterPaxPrinterUtility.printStr(
        "           BANK TOYIB     \n", null);
    await FlutterPaxPrinterUtility.setDoubleWidth(false, false);
    await FlutterPaxPrinterUtility.setDoubleHeight(false, false);
    await FlutterPaxPrinterUtility.printStr("\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "STAN   : 123456123        \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "MID    : 0812393          \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "REFF   : 1023701923701    \n", null);
    await FlutterPaxPrinterUtility.printStr("\n\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "Amount :               100.000\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "Tip    :                     0\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "- - - - - - - - - - - - - - - \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "Total  :               100.000\n", null);
    await FlutterPaxPrinterUtility.printStr("\n", null);
    await FlutterPaxPrinterUtility.printStr(
        "       NO SIGN REQUIRED   \n", null);
    await FlutterPaxPrinterUtility.printStr(
        "    ** Payment Success **  \n", null);
    await FlutterPaxPrinterUtility.printStr("\n", null);
    await FlutterPaxPrinterUtility.printStr(
        " FOR DEVELOPMENT PURPOSE ONLY\n", null);
    await FlutterPaxPrinterUtility.printStr("\n\n\n\n", null);
    await FlutterPaxPrinterUtility.step(10);
    await FlutterPaxPrinterUtility.start();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Pax Printer Utitlity'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              'Running on: $_platformVersion\n',
              textAlign: TextAlign.center,
            ),
            statusPrinter == '1'
                ? const Text(
                    'Status Printer: Connected',
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    'Status Printer: Disconnected',
                    textAlign: TextAlign.center,
                  ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await FlutterPaxPrinterUtility.printReceipt(
                    "TEST PRINT\n\nOK SUCCESS PRINTING\n\n");
              },
              child: const Text("TEST PRINT RECEIPT"),
            ),
            ElevatedButton(
              onPressed: () => printQrCode(),
              child: const Text("TEST PRINT WITH QRCODE"),
            ),
            ElevatedButton(
              onPressed: () => printImageNetwork(),
              child: const Text("TEST PRINT IMAGE FROM NETWORK"),
            ),
            ElevatedButton(
              onPressed: () => printImage(),
              child: const Text("TEST PRINT IMAGE FROM ASSET"),
            ),
            ElevatedButton(
              onPressed: _manualPrintWithBitmap,
              child: const Text("TEST PRINT RECEIPT FROM SCRATCH"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ReceiptPage())),
              child: const Text("TEST PRINT RECEIPT FROM BITMAP VIEW"),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example Page For Receipt Page
class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key}) : super(key: key);

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  final GlobalKey _globalKey = GlobalKey();
  bool isLoading = false;

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
    return null;
  }

  Future<void> _printReceiptBitmap() async {
    setState(() => isLoading = true);
    Uint8List? bitmapWidget = await _capturePng();
    if (bitmapWidget != null) {
      await FlutterPaxPrinterUtility.init;
      await FlutterPaxPrinterUtility.setGray(3);
      await FlutterPaxPrinterUtility.printBitmap(bitmapWidget);
      await FlutterPaxPrinterUtility.printStr("\n\n\n\n", null);
      await FlutterPaxPrinterUtility.start();
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print From Bitmap"),
        actions: [
          IconButton(
              onPressed: _printReceiptBitmap, icon: const Icon(Icons.print)),
        ],
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                  child: ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    width: 150,
                    height: 100,
                    child: Image.asset(
                      'assets/images/auria_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    "Aulia Shop",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Jl. Banda",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Bandung",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  const Text("TID          : 123456"),
                  const Text("Peymen  : CASH"),
                  Text("Date        : ${DateTime.now().toLocal()}"),
                  const SizedBox(height: 10.0),
                  const Text(
                    "BANK TOYIB",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),
                  const Text("STAN          : 123456123"),
                  const Text("MID             : 0812393"),
                  const Text("REFF           : 1023701923701"),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Amount"),
                      Text("100.000"),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Tip"),
                      Text("0"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("TOTAL"),
                      Text("100.000"),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    "NO SIGN REQUIRED",
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "** Payment Success **",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "FOR DEVELOPMENT PURPOSE ONLY",
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
