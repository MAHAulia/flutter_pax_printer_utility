// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:bitmap/bitmap.dart';
import 'package:flutter/services.dart';

class FlutterPaxPrinterUtility {
  static const MethodChannel _channel =
      MethodChannel('flutter_pax_printer_utility');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool?> get bindPrinter async {
    final bool? status = await _channel.invokeMethod('bindPrinter');
    return status;
  }

  static Future<String?> get getStatus async {
    final String? status = await _channel.invokeMethod('getStatus');
    return status;
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

  static Future<String?> printQRReceipt(
      String text1, String text2, String text3, String qrString) async {
    Map<String, dynamic> arguments = {
      "text1": text1.replaceAll("\r", ""),
      "text2": text2.replaceAll("\r", ""),
      "text3": text3.replaceAll("\r", ""),
      "qr_string": qrString
    };
    final String? response = await _channel.invokeMethod('printQR', arguments);
    return response;
  }

  static Future<bool?> init() async {
    final bool? response = await _channel.invokeMethod('init');
    return response;
  }

  static Future<bool?> fontSet(
      EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) async {
    Map<String, dynamic> arguments = {
      "asciiFontType": asciiFontType,
      "cFontType": cFontType,
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

  static Future<bool?> printBitmap(Bitmap bitmap) async {
    Map<String, dynamic> arguments = {
      "bitmap": bitmap,
    };
    final bool? response =
        await _channel.invokeMethod('printBitmap', arguments);
    return response;
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

  static Future<bool?> leftIndents(String indent) async {
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

class EFontTypeAscii {
  final Uint8List _value;
  const EFontTypeAscii._internal(this._value);

  @override
  toString() => 'Enum.$_value';

  static final FONT_8_16 =
      EFontTypeAscii._internal(Uint8List.fromList('0'.codeUnits));

  static final FONT_16_24 =
      EFontTypeAscii._internal(Uint8List.fromList('1'.codeUnits));
  static final FONT_12_24 =
      EFontTypeAscii._internal(Uint8List.fromList('1'.codeUnits));
  static final FONT_8_32 =
      EFontTypeAscii._internal(Uint8List.fromList('2'.codeUnits));

  static final FONT_16_48 =
      EFontTypeAscii._internal(Uint8List.fromList('3'.codeUnits));
  static final FONT_12_48 =
      EFontTypeAscii._internal(Uint8List.fromList('3'.codeUnits));
  static final FONT_16_16 =
      EFontTypeAscii._internal(Uint8List.fromList('4'.codeUnits));

  static final FONT_32_24 =
      EFontTypeAscii._internal(Uint8List.fromList('5'.codeUnits));
  static final FONT_24_24 =
      EFontTypeAscii._internal(Uint8List.fromList('5'.codeUnits));
  static final FONT_16_32 =
      EFontTypeAscii._internal(Uint8List.fromList('6'.codeUnits));

  static final FONT_32_48 =
      EFontTypeAscii._internal(Uint8List.fromList('7'.codeUnits));
  static final FONT_24_48 =
      EFontTypeAscii._internal(Uint8List.fromList('7'.codeUnits));
}

class EFontTypeExtCode {
  final Uint8List _value;
  const EFontTypeExtCode._internal(this._value);

  @override
  toString() => 'Enum.$_value';

  static final FONT_16_16 =
      EFontTypeExtCode._internal(Uint8List.fromList('0'.codeUnits));
  static final FONT_24_24 =
      EFontTypeExtCode._internal(Uint8List.fromList('1'.codeUnits));
  static final FONT_16_32 =
      EFontTypeExtCode._internal(Uint8List.fromList('2'.codeUnits));
  static final FONT_24_48 =
      EFontTypeExtCode._internal(Uint8List.fromList('3'.codeUnits));
  static final FONT_32_16 =
      EFontTypeExtCode._internal(Uint8List.fromList('4'.codeUnits));
  static final FONT_48_24 =
      EFontTypeExtCode._internal(Uint8List.fromList('5'.codeUnits));
  static final FONT_32_32 =
      EFontTypeExtCode._internal(Uint8List.fromList('6'.codeUnits));
  static final FONT_48_48 =
      EFontTypeExtCode._internal(Uint8List.fromList('7'.codeUnits));
}
