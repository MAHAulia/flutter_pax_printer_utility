// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPaxPrinterUtility {
  static const MethodChannel _channel = MethodChannel('flutter_pax_printer_utility');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Gets the current status of the printer.
  ///
  /// This method returns the current status of the printer as a [PrinterStatus] enum.
  ///
  /// Returns a [Future] that completes with the printer status.
  static Future<PrinterStatus> get getStatus async {
    final String? status = await _channel.invokeMethod('getStatus');
    switch (status) {
      case "Success":
        return PrinterStatus.SUCCESS;
      case "Printer is busy":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Out of paper":
        return PrinterStatus.OUT_OF_PAPER;
      case "The format of print data packet error":
        return PrinterStatus.FORMAT_PRINT_PACKET_ERROR;
      case "Printer malfunctions":
        return PrinterStatus.PRINTER_MALFUCTION;
      case "Printer over heats":
        return PrinterStatus.PRINTER_OVER_HEATS;
      case "Printer voltage is too low":
        return PrinterStatus.PRINTER_VOLTAGE_IS_TO_LOW;
      case "Printing is unfinished":
        return PrinterStatus.PRINTING_IS_UNFINISHED;
      case "The printer has not installed font library":
        return PrinterStatus.FONT_LIBRARY_NOT_INSTALLED;
      case "Data package is too long":
        return PrinterStatus.DATA_PACKAGE_TO_LONG;
      default:
        return PrinterStatus.UNKNOWN;
    }
  }

  /// Prints a receipt with the specified text.
  ///
  /// This method sends the specified [text] to the printer to be printed as a receipt.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printReceipt(String text) async {
    final String? response = await _channel.invokeMethod('printReceipt', {"text": text.replaceAll("\r", "")});
    return response;
  }

  /// Prints a receipt with the specified text and a QR code.
  ///
  /// This method sends the specified [text] and [qrString] to the printer to be printed as a receipt with a QR code.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printReceiptWithQr(String text, String qrString) async {
    final String? response =
        await _channel.invokeMethod('printReceipt', {"text": text.replaceAll("\r", ""), "qr_string": qrString});
    return response;
  }

  /// Prints a receipt with multiple lines of text and a QR code.
  ///
  /// This method sends the specified texts and [qrString] to the printer to be printed as a receipt with a QR code.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printQRReceipt(String text1, String text2, String text3, String text4, String qrString) async {
    Map<String, dynamic> arguments = {
      "text1": text1.replaceAll("\r", ""),
      "text2": text2.replaceAll("\r", ""),
      "text3": text3.replaceAll("\r", ""),
      "text4": text4.replaceAll("\r", ""),
      "qr_string": qrString
    };
    final String? response = await _channel.invokeMethod('printQR', arguments);
    return response;
  }

  /// Initializes the printer.
  ///
  /// This method initializes the printer and prepares it for use.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the initialization.
  static Future<bool?> get init async {
    final bool? status = await _channel.invokeMethod('init');
    return status;
  }

  /// Sets the font type for ASCII and extended code characters.
  ///
  /// This method sets the specified [asciiFontType] and [cFontType] for the printer.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> fontSet(EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) async {
    Map<String, dynamic> arguments = {
      "asciiFontType": asciiFontType.toString(),
      "cFontType": cFontType.toString(),
    };
    final bool? response = await _channel.invokeMethod('fontSet', arguments);
    return response;
  }

  /// Sets the word and line spacing.
  ///
  /// This method sets the specified [wordSpace] and [lineSpace] for the printer.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> spaceSet(int wordSpace, int lineSpace) async {
    Map<String, dynamic> arguments = {
      "wordSpace": wordSpace.toString(),
      "lineSpace": lineSpace.toString(),
    };
    final bool? response = await _channel.invokeMethod('spaceSet', arguments);
    return response;
  }

  /// Prints a string with the specified charset.
  ///
  /// This method prints the specified [text] using the given [charset].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printStr(String text, String? charset) async {
    Map<String, dynamic> arguments = {
      "text": text,
      "charset": charset,
    };
    final bool? response = await _channel.invokeMethod('printStr', arguments);
    return response;
  }

  /// Steps the printer by the specified number of steps.
  ///
  /// This method advances the printer by the given [step] count.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> step(int step) async {
    Map<String, dynamic> arguments = {
      "step": step,
    };
    final bool? response = await _channel.invokeMethod('step', arguments);
    return response;
  }

  /// Prints a bitmap image.
  ///
  /// This method prints the specified [bitmap] image.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printBitmap(Uint8List bitmap) async {
    Map<String, dynamic> arguments = {
      "bitmap": bitmap,
    };
    final bool? response = await _channel.invokeMethod('printBitmap', arguments);
    return response;
  }

  /// Prints an image from a URL.
  ///
  /// This method prints the image located at the specified [url].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printImageUrl(String url) async {
    Map<String, dynamic> arguments = {
      "url": url,
    };
    final bool? response = await _channel.invokeMethod('printImageUrl', arguments);
    return response;
  }

  /// Prints an image from an asset.
  ///
  /// This method prints the image located at the specified asset [img].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printImageAsset(String img) async {
    Uint8List byte = await FlutterPaxPrinterUtility().getImageFromAsset(img);
    Map<String, dynamic> arguments = {
      "bitmap": byte,
    };
    final bool? response = await _channel.invokeMethod('printImageAsset', arguments);
    return response;
  }

  /// Gets the image bytes from an asset.
  ///
  /// This method loads the image located at the specified [iconPath] and returns its bytes.
  ///
  /// Returns a [Future] that completes with the image bytes as a [Uint8List].
  Future<Uint8List> getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  /// Reads the bytes of a file.
  ///
  /// This method reads the file located at the specified [path] and returns its bytes.
  ///
  /// Returns a [Future] that completes with the file bytes as a [Uint8List].
  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  /// Prints a QR code with the specified text and dimensions.
  ///
  /// This method prints a QR code containing the given [text] with the specified [width] and [height].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printQRCode(String text, int width, int height) async {
    Map<String, dynamic> arguments = {
      "text": text,
      "width": width,
      "height": height,
    };
    final bool? response = await _channel.invokeMethod('printQRCode', arguments);
    return response;
  }

  /// Sets the left indentation for printing.
  ///
  /// This method sets the left indentation of the printer to the specified [indent] value.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> leftIndents(int indent) async {
    Map<String, dynamic> arguments = {
      "indent": indent,
    };
    final bool? response = await _channel.invokeMethod('leftIndents', arguments);
    return response;
  }

  /// Starts the printer.
  ///
  /// This method starts the printing.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> start() async {
    final String? response = await _channel.invokeMethod('start');
    return response;
  }

  static Future<int?> getDotLine() async {
    final int? response = await _channel.invokeMethod('getDotLine');
    return response;
  }

  /// Sets the gray level for printing.
  ///
  /// This method sets the gray level of the printer to the specified [level].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setGray(int level) async {
    Map<String, dynamic> arguments = {
      "level": level,
    };
    final bool? response = await _channel.invokeMethod('setGray', arguments);
    return response;
  }

  /// Sets the double width mode for printing.
  ///
  /// This method sets the double width mode of the printer based on the specified [isAscDouble] and [isLocalDouble] values.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setDoubleWidth(bool isAscDouble, bool isLocalDouble) async {
    Map<String, dynamic> arguments = {
      "isAscDouble": isAscDouble,
      "isLocalDouble": isLocalDouble,
    };
    final bool? response = await _channel.invokeMethod('setDoubleWidth', arguments);
    return response;
  }

  /// Sets the double height mode for printing.
  ///
  /// This method sets the double height mode of the printer based on the specified [isAscDouble] and [isLocalDouble] values.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setDoubleHeight(bool isAscDouble, bool isLocalDouble) async {
    Map<String, dynamic> arguments = {
      "isAscDouble": isAscDouble,
      "isLocalDouble": isLocalDouble,
    };
    final bool? response = await _channel.invokeMethod('setDoubleHeight', arguments);
    return response;
  }

  /// Sets the invert mode for printing.
  ///
  /// This method sets the invert mode of the printer based on the specified [isInvert] value.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setInvert(bool isInvert) async {
    Map<String, dynamic> arguments = {
      "isInvert": isInvert,
    };
    final bool? response = await _channel.invokeMethod('setInvert', arguments);
    return response;
  }

  /// Cuts the paper.
  ///
  /// This method instructs the printer to cut the paper based on the specified [mode].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> cutPaper(int mode) async {
    Map<String, dynamic> arguments = {
      "mode": mode,
    };
    final bool? response = await _channel.invokeMethod('cutPaper', arguments);
    return response;
  }
}

enum PrinterStatus {
  UNKNOWN,
  SUCCESS,
  PRINTER_IS_BUSY,
  OUT_OF_PAPER,
  FORMAT_PRINT_PACKET_ERROR,
  PRINTER_MALFUCTION,
  PRINTER_OVER_HEATS,
  PRINTER_VOLTAGE_IS_TO_LOW,
  PRINTING_IS_UNFINISHED,
  FONT_LIBRARY_NOT_INSTALLED,
  DATA_PACKAGE_TO_LONG
}

/// Represents different font types for ASCII characters.
///
/// This class provides a set of predefined font types that can be used
/// to specify the font size for ASCII characters. Each font type is
/// represented by a unique string value.
///
/// asciiFontType - EFontTypeAscii
class EFontTypeAscii {
  final String _value;
  const EFontTypeAscii._internal(this._value);

  @override
  toString() => _value;

  /// Font type with size 8x16 pixels.
  ///
  /// This font type represents characters that are 8 pixels wide and 16 pixels tall.
  static const FONT_8_16 = EFontTypeAscii._internal('FONT_8_16');

  /// Font type with size 16x24 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 24 pixels tall.
  static const FONT_16_24 = EFontTypeAscii._internal('FONT_16_24');

  /// Font type with size 12x24 pixels.
  ///
  /// This font type represents characters that are 12 pixels wide and 24 pixels tall.
  static const FONT_12_24 = EFontTypeAscii._internal('FONT_12_24');

  /// Font type with size 8x32 pixels.
  ///
  /// This font type represents characters that are 8 pixels wide and 32 pixels tall.
  static const FONT_8_32 = EFontTypeAscii._internal('FONT_8_32');

  /// Font type with size 16x48 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 48 pixels tall.
  static const FONT_16_48 = EFontTypeAscii._internal('FONT_16_48');

  /// Font type with size 12x48 pixels.
  ///
  /// This font type represents characters that are 12 pixels wide and 48 pixels tall.
  static const FONT_12_48 = EFontTypeAscii._internal('FONT_12_48');

  /// Font type with size 16x16 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 16 pixels tall.
  static const FONT_16_16 = EFontTypeAscii._internal('FONT_16_16');

  /// Font type with size 32x24 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 24 pixels tall.
  static const FONT_32_24 = EFontTypeAscii._internal('FONT_32_24');

  /// Font type with size 24x24 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 24 pixels tall.
  static const FONT_24_24 = EFontTypeAscii._internal('FONT_24_24');

  /// Font type with size 16x32 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 32 pixels tall.
  static const FONT_16_32 = EFontTypeAscii._internal('FONT_16_32');

  /// Font type with size 32x48 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 48 pixels tall.
  static const FONT_32_48 = EFontTypeAscii._internal('FONT_32_48');

  /// Font type with size 24x48 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 48 pixels tall.
  static const FONT_24_48 = EFontTypeAscii._internal('FONT_24_48');
}

/// Represents different font types for extended code characters.
///
/// This class provides a set of predefined font types that can be used
/// to specify the font size for extended code characters. Each font type is
/// represented by a unique string value.
class EFontTypeExtCode {
  final String _value;
  const EFontTypeExtCode._internal(this._value);

  @override
  toString() => _value;

  /// Font type with size 16x16 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 16 pixels tall.
  static const FONT_16_16 = EFontTypeExtCode._internal('FONT_16_16');

  /// Font type with size 24x24 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 24 pixels tall.
  static const FONT_24_24 = EFontTypeExtCode._internal('FONT_24_24');

  /// Font type with size 16x32 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 32 pixels tall.
  static const FONT_16_32 = EFontTypeExtCode._internal('FONT_16_32');

  /// Font type with size 24x48 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 48 pixels tall.
  static const FONT_24_48 = EFontTypeExtCode._internal('FONT_24_48');

  /// Font type with size 32x16 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 16 pixels tall.
  static const FONT_32_16 = EFontTypeExtCode._internal('FONT_32_16');

  /// Font type with size 48x24 pixels.
  ///
  /// This font type represents characters that are 48 pixels wide and 24 pixels tall.
  static const FONT_48_24 = EFontTypeExtCode._internal('FONT_48_24');

  /// Font type with size 32x32 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 32 pixels tall.
  static const FONT_32_32 = EFontTypeExtCode._internal('FONT_32_32');

  /// Font type with size 48x48 pixels.
  ///
  /// This font type represents characters that are 48 pixels wide and 48 pixels tall.
  static const FONT_48_48 = EFontTypeExtCode._internal('FONT_48_48');
}
