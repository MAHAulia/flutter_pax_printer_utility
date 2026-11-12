# flutter_pax_printer_utility

#### This package based on [PAX Device with NeptuneLiteApi](https://docs.hips.com/docs/pax-a920 "PAX Device") SDK

## Important: 
  **THIS PACKAGE WILL WORK ONLY IN ANDROID!**

## Installation

```bash
flutter pub add flutter_pax_printer_utility
```

```dart
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
// Only for the serial number and terminal info:
import 'package:flutter_pax_printer_utility/pax_device_info.dart';
```

## Release builds

The plugin ships the PAX SDK's ProGuard/R8 keep rules, so release builds work
with `minifyEnabled` and `shrinkResources` on; no build changes are needed.

## Quick start

Printing works in two steps: calls such as `printStr`, `printRow` and
`printBarcode` add to a print job, and `start` prints it. `init` starts a new
job (it clears anything not yet printed and resets the font and spacing).

```dart
await FlutterPaxPrinterUtility.init;
await FlutterPaxPrinterUtility.printStr('Hello from PAX\n', null);
await FlutterPaxPrinterUtility.step(150); // feed 150 dots of blank paper after the text
final String? status = await FlutterPaxPrinterUtility.start(); // "Success", "Out of paper", ...
```

`init`, `getStatus` and `getPaperSize` are getters, so they have no `()`.
All calls run in order on one background thread, and `start` waits until the
slip has printed without blocking the app's UI.

## Printer status

```dart
final PrinterStatus status = await FlutterPaxPrinterUtility.getStatus;
if (status == PrinterStatus.OUT_OF_PAPER) {
  // ask the user to load paper
}
```

## Text

```dart
await FlutterPaxPrinterUtility.init;

// Font: an ASCII font and a font for other characters, named width_height in dots.
await FlutterPaxPrinterUtility.fontSet(
    EFontTypeAscii.FONT_12_24, EFontTypeExtCode.FONT_24_24);

// Extra dots between characters and between lines.
await FlutterPaxPrinterUtility.spaceSet(0, 10);

// Print darkness: 1 is the default; 50-500 sets a percentage of the default.
await FlutterPaxPrinterUtility.setGray(1);

// Left margin in dots (0-300).
await FlutterPaxPrinterUtility.leftIndents(20);

// '\n' starts a new line. The charset defaults to UTF-8 when null.
await FlutterPaxPrinterUtility.printStr('Thank you for your purchase\n', null);

// Double width / height: the first flag is for ASCII characters, the second for others.
await FlutterPaxPrinterUtility.setDoubleWidth(true, true);
await FlutterPaxPrinterUtility.setDoubleHeight(true, true);
await FlutterPaxPrinterUtility.printStr('TOTAL R 99.00\n', null);
await FlutterPaxPrinterUtility.setDoubleWidth(false, false);
await FlutterPaxPrinterUtility.setDoubleHeight(false, false);

// White text on black.
await FlutterPaxPrinterUtility.setInvert(true);
await FlutterPaxPrinterUtility.printStr(' PAID \n', null);
await FlutterPaxPrinterUtility.setInvert(false);

await FlutterPaxPrinterUtility.step(150);
await FlutterPaxPrinterUtility.start();
```

The PAX SDK has no bold setting; double width and height are the closest
alternative.

## Rows

`printRow` lays out columns in the current font, wrapping long text within its column:

```dart
final width = FlutterPaxPrinterUtility.charsPerLine(EFontTypeAscii.FONT_12_24); // 32 on 58mm paper
await FlutterPaxPrinterUtility.printRow([
  const PrintColumn('2', width: 4),
  const PrintColumn('Coffee'),
  const PrintColumn('R 50.00', width: 10, align: PrintAlign.RIGHT),
], charsPerLine: width);
```

Columns with a `width` get exactly that many characters; the others share the
rest by `flex` (default 1). `align` is `LEFT`, `CENTER` or `RIGHT`.
`formatRow` returns the laid-out text without printing it. `charsPerLine`
takes the paper size too (`paperSize: PaxPaperSize.MM_80`); halve it while
double width is on.

## Dividers

```dart
await FlutterPaxPrinterUtility.printDivider();                          // solid, 2 dots thick
await FlutterPaxPrinterUtility.printDivider(dashed: true, thickness: 1);
await FlutterPaxPrinterUtility.printDivider(paperSize: PaxPaperSize.MM_80);
```

## Barcodes and QR codes

Barcodes are encoded on the device and added to the print job as an image:

```dart
await FlutterPaxPrinterUtility.printBarcode('600123456789', PaxBarcodeFormat.EAN_13);
await FlutterPaxPrinterUtility.printBarcode('ABC-000123', PaxBarcodeFormat.CODE_128, height: 80);
await FlutterPaxPrinterUtility.printBarcode('https://example.com', PaxBarcodeFormat.QR_CODE, width: 300);

// QR code with an explicit size in dots.
await FlutterPaxPrinterUtility.printQRCode('https://example.com', 300, 300);
await FlutterPaxPrinterUtility.start();
```

Supported formats: `CODE_128`, `CODE_39`, `CODE_93`, `CODABAR`, `EAN_8`, `EAN_13`, `UPC_A`, `UPC_E`, `ITF`, `QR_CODE`, `PDF_417`, `DATA_MATRIX`, `AZTEC`.
Data that isn't valid for the format (for example letters in an EAN-13) throws a `PlatformException` with code `INVALID_BARCODE`; a barcode wider than the paper throws `BARCODE_TOO_WIDE`.

## Images

```dart
// From your app's assets (declared in pubspec.yaml).
await FlutterPaxPrinterUtility.printImageAsset('assets/images/logo.png');

// From the web. Returns false if the image can't be downloaded within 30 seconds.
final bool? printed = await FlutterPaxPrinterUtility.printImageUrl('https://example.com/logo.png');

// From encoded image bytes (PNG, JPEG, ...), for example a widget captured with RepaintBoundary.
final Uint8List pngBytes = await renderReceiptWidget(); // your own code
await FlutterPaxPrinterUtility.printBitmap(pngBytes);

await FlutterPaxPrinterUtility.start();
```

## Templates

Each template starts a new job, prints it and returns the status from `start`:

```dart
await FlutterPaxPrinterUtility.printReceipt('My Shop\nTotal: R 99.00\n');
await FlutterPaxPrinterUtility.printReceiptWithQr('My Shop\nScan to pay:\n', 'https://example.com/pay/123');
await FlutterPaxPrinterUtility.printQRReceipt('My Shop', 'Order 123', 'Table 4', 'Thank you', 'https://example.com/order/123');
```

## Paper

```dart
// Paper width: MM_58, MM_80, or UNKNOWN on terminals that can't report it.
final PaxPaperSize paper = await FlutterPaxPrinterUtility.getPaperSize;

// Cut the paper: 0 = full cut, 1 = partial cut. Terminals without a cutter
// throw PRINTER_ERROR (details: 100, "not support").
await FlutterPaxPrinterUtility.cutPaper(0);

// Dot lines printed so far, for aligning pre-printed slips.
final int? dotLine = await FlutterPaxPrinterUtility.getDotLine();
```

PAX documents `getPaperSize` as supported on the SK700 only; other terminals,
such as the A910S, return `UNKNOWN`.

## Terminal information

```dart
final String? serial = await PaxDeviceInfo.getSerial();
final Map<String, String> info = await PaxDeviceInfo.getTermInfo();
print(info['MODEL']);  // for example A910S
print(info['AP_VER']); // firmware version
```

The PAX SDK has no separate serial number or version for the built-in
printer, so these are the terminal's.

## Errors

Calls throw a `PlatformException` when something goes wrong:
- `PRINTER_ERROR`: the printer reported an error, for example a setting the
  terminal does not support. `details` is the PAX SDK's error code.
- `PAX_ERROR`: any other native failure, for example a device without the PAX
  services.
- `INVALID_BARCODE` / `BARCODE_TOO_WIDE`: see [Barcodes and QR codes](#barcodes-and-qr-codes).

`printBitmap`, `printImageAsset`, `printImageUrl` and `printQRCode` return
`false`, without printing, when there is no image to print (bytes that are not
an image, a download that failed, or text that cannot be encoded as a QR code).

```dart
try {
  await FlutterPaxPrinterUtility.cutPaper(0);
} on PlatformException catch (e) {
  if (e.code == 'PRINTER_ERROR') {
    print('Printer error ${e.details}: ${e.message}');
  }
}
```

## What this package can do
- [✅] Initialize the printer => `init`
- [✅] Get the printer status => `getStatus`
- [✅] Set the print darkness => `setGray`
- [✅] Print white on black => `setInvert`
- [✅] Change the font => `fontSet`
- [✅] Change character and line spacing => `spaceSet`
- [✅] Print text => `printStr`
- [✅] Feed paper => `step`
- [✅] Double width / double height text => `setDoubleWidth`, `setDoubleHeight`
- [✅] Print QR codes => `printQRCode` or `printBarcode`
- [✅] Print barcodes => `printBarcode` with a `PaxBarcodeFormat`
- [✅] Cut paper => `cutPaper`
- [✅] Print images from the web, assets or bytes => `printImageUrl`, `printImageAsset`, `printBitmap`
- [✅] Set the left margin => `leftIndents`
- [✅] Print rows like a receipt with custom width and alignment => `printRow`
- [✅] Draw a divider line => `printDivider` (solid or dashed)
- [✅] Get the paper size => `getPaperSize` (SK700 only)
- [✅] Get the terminal's serial number => `PaxDeviceInfo.getSerial()`
- [✅] Get the terminal's model and firmware versions => `PaxDeviceInfo.getTermInfo()`
- [ ] Combine with ESC/POS code you already have. Not possible: the PAX SDK has no way to send raw ESC/POS bytes to the printer.

## If you have an PAX Terminal printer and need help with integration process, just [Contact Me](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)

 - [Github](https://github.com/AuliaVailo)
 - [Email](mailto:abdul.haq.aulia@gmail.com)
 - [Youtube](https://www.youtube.com/channel/UC02Kasrd4--IzX2mNcI2tWg)
 - [LinkedIn](https://www.linkedin.com/in/moh-abdul-haq-aulia-29a925169/)

## Tested Devices

```bash
PAX A920 
PAX A910S
```

## Buy me a coffee
If you want to support this package, you can [☕️ Buy Me a Coffee](https://www.buymeacoffee.com/abdulhaqaulia) <br>or you can scan this qr for support with [☕️ Saweria](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)
