# flutter_pax_printer_utility

#### This package based on [PAX Device with NetptuneLiteApi](https://docs.hips.com/docs/pax-a920 "PAX Device") SDK

## Important: 
  **THIS PACKAGE WILL WORK ONLY IN ANDROID!**

## Installation  

```bash
flutter pub add flutter_pax_printer_utility
```


## Set minify and shrink on your buildtype gradle

```bash
add this line in your build.gradle
buildTypes {
    release {
        .
        .
        .
        minifyEnabled false
        shrinkResources false
    }
}
```

## What this package can do
- [✅] Initialize the printer => use init
- [✅] Get Printer Status => use getStatus
- [✅] Set setGray level => use setGray
- [✅] Set Print => use setInvert
- [✅] Change font set => use fontSet
- [✅] Change space set => use spaceSet
- [✅] Write some text => use printStr
- [✅] Jump (n) lines => use step
- [✅] Bold mode on/off => use setDoubleWidth and setDoubleHeight to true
- [✅] Print QR codes => use printQRCode
- [✅] Cut paper - Dedicated method just to cut the line
- [✅] Print image from asset or from web (example show how to print both) => use printImageUrl
- [✅] Print Bitmap => use printBitmap
- [✅] Print Image From Asset => use printImageAsset
- [✅] Set Left Indents => use leftIndents
- [✅] Get the terminal's serial number => use `PaxDeviceInfo.getSerial()` (import `package:flutter_pax_printer_utility/pax_device_info.dart`)
- [✅] Draw a divider line => use printDivider (solid or dashed)
- [✅] Print barcodes => use printBarcode with a `PaxBarcodeFormat` (see [Barcodes](#barcodes))
- [✅] Print rows like a receipt with custom width and alignment => use printRow (see [Rows](#rows))
- [✅] Get the terminal's model and firmware versions => use `PaxDeviceInfo.getTermInfo()`. The PAX SDK has no separate serial number or version for the built-in printer, so these are the terminal's.
- [✅] Get the paper size => use getPaperSize (`PaxPaperSize.MM_58` / `MM_80`). Terminals that don't support it return `UNKNOWN`; the A910S is one of them.
- [ ] Combine with ESC/POS code you already have. Not possible: the PAX SDK has no way to send raw ESC/POS bytes to the printer.

## Barcodes
Barcodes are encoded on the device and added to the print job as an image:

```dart
await FlutterPaxPrinterUtility.printBarcode('600123456789', PaxBarcodeFormat.EAN_13);
await FlutterPaxPrinterUtility.printBarcode('TFN-000123', PaxBarcodeFormat.CODE_128, height: 80);
await FlutterPaxPrinterUtility.start();
```

Supported formats: `CODE_128`, `CODE_39`, `CODE_93`, `CODABAR`, `EAN_8`, `EAN_13`, `UPC_A`, `UPC_E`, `ITF`, `QR_CODE`, `PDF_417`, `DATA_MATRIX`, `AZTEC`.
Data that isn't valid for the format (for example letters in an EAN-13) throws a `PlatformException` with code `INVALID_BARCODE`; a barcode wider than the paper throws `BARCODE_TOO_WIDE`.

## Rows
`printRow` lays out columns in the current font, wrapping long text within its column:

```dart
final width = FlutterPaxPrinterUtility.charsPerLine(EFontTypeAscii.FONT_12_24); // 32 on 58mm paper
await FlutterPaxPrinterUtility.printRow([
  const PrintColumn('2', width: 4),
  const PrintColumn('Coffee'),
  const PrintColumn('R 50.00', width: 10, align: PrintAlign.RIGHT),
], charsPerLine: width);
await FlutterPaxPrinterUtility.printDivider(dashed: true);
```

Columns with a `width` get exactly that many characters; the others share the rest by `flex`. `formatRow` returns the laid-out text without printing it.

## Other Functions
- Template Print Receipt With QR => printReceiptWithQr
- Template Print Receipt => printReceipt
- Template Print QR with info => printQRReceipt

## If you have an PAX Terminal printer and need help with integration process, just [Contact Me](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)

 - [Github](https://github.com/AuliaVailo)
 - [Email](mailto:abdul.haq.aulia@gmail.com)
 - [Youtube](https://www.youtube.com/channel/UC02Kasrd4--IzX2mNcI2tWg)
 - [Linkdin](https://www.linkedin.com/in/moh-abdul-haq-aulia-29a925169/)

## Tested Devices

```bash
PAX A920 
PAX A910S
```

## Buy me a coffee
If you want to support this package, you can [☕️ Buy Me a Coffee](https://www.buymeacoffee.com/abdulhaqaulia) <br>or you can scan this qr for support with [☕️ Saweria](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)
