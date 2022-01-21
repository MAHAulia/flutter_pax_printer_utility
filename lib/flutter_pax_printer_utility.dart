import 'dart:async';

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
    final String? version = await _channel
        .invokeMethod('printReceipt', {"text": text.replaceAll("\r", "")});
    return version;
  }
}
