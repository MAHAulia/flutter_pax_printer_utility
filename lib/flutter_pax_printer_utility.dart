// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'package:flutter/services.dart';

class FlutterPaxPrinterUtility {
  static const MethodChannel _channel =
      MethodChannel('flutter_pax_printer_utility');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<PrinterStatus> get getStatus async {
    final String? status = await _channel.invokeMethod('getStatus');
    switch (status) {
      case "Success":
        return PrinterStatus.SUCCESS;
      case "Printer is busy":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Out of paper":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "The format of print data packet error":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Printer malfunctions":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Printer over heats":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Printer voltage is too low":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Printing is unfinished":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "The printer has not installed font library":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Data package is too long":
        return PrinterStatus.PRINTER_IS_BUSY;
      default:
        return PrinterStatus.UNKNOWN;
    }
  }

  static Future<String?> printReceipt(String text) async {
    final String? response = await _channel
        .invokeMethod('printReceipt', {"text": text.replaceAll("\r", "")});
    return response;
  }

  static Future<String?> printReceiptWithQr(
      String text, String qrString) async {
    final String? response = await _channel.invokeMethod('printReceipt',
        {"text": text.replaceAll("\r", ""), "qr_string": qrString});
    return response;
  }

  static Future<String?> printQRReceipt(String text1, String text2,
      String text3, String text4, String qrString) async {
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

  static Future<bool?> get init async {
    final bool? status = await _channel.invokeMethod('init');
    return status;
  }

  static Future<bool?> fontSet(
      EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) async {
    Map<String, dynamic> arguments = {
      "asciiFontType": asciiFontType.toString(),
      "cFontType": cFontType.toString(),
    };
    final bool? response = await _channel.invokeMethod('fontSet', arguments);
    return response;
  }

  static Future<bool?> spaceSet(int wordSpace, int lineSpace) async {
    Map<String, dynamic> arguments = {
      "wordSpace": wordSpace.toString(),
      "lineSpace": lineSpace.toString(),
    };
    final bool? response = await _channel.invokeMethod('spaceSet', arguments);
    return response;
  }

  static Future<bool?> printStr(String text, String? charset) async {
    Map<String, dynamic> arguments = {
      "text": text,
      "charset": charset,
    };
    final bool? response = await _channel.invokeMethod('printStr', arguments);
    return response;
  }

  static Future<bool?> step(int step) async {
    Map<String, dynamic> arguments = {
      "step": step,
    };
    final bool? response = await _channel.invokeMethod('step', arguments);
    return response;
  }

  static Future<bool?> printBitmap(Uint8List bitmap) async {
    Map<String, dynamic> arguments = {
      "bitmap": bitmap,
    };
    final bool? response =
        await _channel.invokeMethod('printBitmap', arguments);
    return response;
  }

  static Future<bool?> printImageUrl(String url) async {
    Map<String, dynamic> arguments = {
      "url": url,
    };
    final bool? response =
        await _channel.invokeMethod('printImageUrl', arguments);
    return response;
  }

  static Future<bool?> printImageAsset(String img) async {
    Uint8List byte = await FlutterPaxPrinterUtility().getImageFromAsset(img);
    Map<String, dynamic> arguments = {
      "bitmap": byte,
    };
    final bool? response =
        await _channel.invokeMethod('printImageAsset', arguments);
    return response;
  }

  Future<Uint8List> getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  static Future<bool?> printQRCode(String text, int width, int height) async {
    Map<String, dynamic> arguments = {
      "text": text,
      "width": width,
      "height": height,
    };
    final bool? response =
        await _channel.invokeMethod('printQRCode', arguments);
    return response;
  }

  static Future<bool?> leftIndents(int indent) async {
    Map<String, dynamic> arguments = {
      "indent": indent,
    };
    final bool? response =
        await _channel.invokeMethod('leftIndents', arguments);
    return response;
  }

  static Future<String?> start() async {
    final String? response = await _channel.invokeMethod('start');
    return response;
  }

  static Future<int?> getDotLine() async {
    final int? response = await _channel.invokeMethod('getDotLine');
    return response;
  }

  static Future<bool?> setGray(int level) async {
    Map<String, dynamic> arguments = {
      "level": level,
    };
    final bool? response = await _channel.invokeMethod('setGray', arguments);
    return response;
  }

  static Future<bool?> setDoubleWidth(
      bool isAscDouble, bool isLocalDouble) async {
    Map<String, dynamic> arguments = {
      "isAscDouble": isAscDouble,
      "isLocalDouble": isLocalDouble,
    };
    final bool? response =
        await _channel.invokeMethod('setDoubleWidth', arguments);
    return response;
  }

  static Future<bool?> setDoubleHeight(
      bool isAscDouble, bool isLocalDouble) async {
    Map<String, dynamic> arguments = {
      "isAscDouble": isAscDouble,
      "isLocalDouble": isLocalDouble,
    };
    final bool? response =
        await _channel.invokeMethod('setDoubleHeight', arguments);
    return response;
  }

  static Future<bool?> setInvert(bool isInvert) async {
    Map<String, dynamic> arguments = {
      "isInvert": isInvert,
    };
    final bool? response = await _channel.invokeMethod('setInvert', arguments);
    return response;
  }

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

/// asciiFontType - EFontTypeAscii
///
/// EFontTypeAscii.FONT_8_16:8x16 font (Basic)
///
/// EFontTypeAscii.FONT_12_24:12x24 font (Basic)
///
/// EFontTypeAscii.FONT_8_32:8x16 font (enlarge vertically)
///
/// EFontTypeAscii.FONT_12_48:12x24 font (enlarge vertically)
///
/// EFontTypeAscii.FONT_16_16:8x16 font (enlarge horizontally)
///
/// EFontTypeAscii.FONT_24_24:12x24 font (enlarge horizontally)
///
/// EFontTypeAscii.FONT_16_32:8x16 font (enlarge on both levels)
///
/// EFontTypeAscii.FONT_24_48:12x24 font (enlarge on both levels)
class EFontTypeAscii {
  final String _value;
  const EFontTypeAscii._internal(this._value);

  @override
  toString() => _value;

  static const FONT_8_16 = EFontTypeAscii._internal('FONT_8_16');

  static const FONT_16_24 = EFontTypeAscii._internal('FONT_16_24');
  static const FONT_12_24 = EFontTypeAscii._internal('FONT_12_24');
  static const FONT_8_32 = EFontTypeAscii._internal('FONT_8_32');

  static const FONT_16_48 = EFontTypeAscii._internal('FONT_16_48');
  static const FONT_12_48 = EFontTypeAscii._internal('FONT_12_48');
  static const FONT_16_16 = EFontTypeAscii._internal('FONT_16_16');

  static const FONT_32_24 = EFontTypeAscii._internal('FONT_32_24');
  static const FONT_24_24 = EFontTypeAscii._internal('FONT_24_24');
  static const FONT_16_32 = EFontTypeAscii._internal('FONT_16_32');

  static const FONT_32_48 = EFontTypeAscii._internal('FONT_32_48');
  static const FONT_24_48 = EFontTypeAscii._internal('FONT_24_48');
}

/// fontTypeExtCode - EFontTypeExtCode font set for extended code characters
///
/// FONT_16_16 -16x16 font (Basic)
///
/// FONT_24_24 -24x24 font (Basic)
///
/// FONT_16_32 -16x16 font (enlarge vertically)
///
/// FONT_24_48 -24x24 font (enlarge vertically)
///
/// FONT_48_24 -16x16 font (enlarge horizontally)
///
/// FONT_32_32 -24x24 font (enlarge horizontally)
///
/// FONT_48_24 -16x16 font (enlarge on both levels)
///
/// FONT_48_48 -24x24 font (enlarge on both levels)
class EFontTypeExtCode {
  final String _value;
  const EFontTypeExtCode._internal(this._value);

  @override
  toString() => _value;

  static const FONT_16_16 = EFontTypeExtCode._internal('FONT_16_16');
  static const FONT_24_24 = EFontTypeExtCode._internal('FONT_24_24');
  static const FONT_16_32 = EFontTypeExtCode._internal('FONT_16_32');
  static const FONT_24_48 = EFontTypeExtCode._internal('FONT_24_48');
  static const FONT_32_16 = EFontTypeExtCode._internal('FONT_32_16');
  static const FONT_48_24 = EFontTypeExtCode._internal('FONT_48_24');
  static const FONT_32_32 = EFontTypeExtCode._internal('FONT_32_32');
  static const FONT_48_48 = EFontTypeExtCode._internal('FONT_48_48');
}
