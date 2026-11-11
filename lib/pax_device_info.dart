import 'dart:async';

import 'package:flutter/services.dart';

/// Information about the PAX terminal the app is running on.
class PaxDeviceInfo {
  static const MethodChannel _channel = MethodChannel('pax_device_info');

  /// Returns the terminal's serial number, as reported by the PAX SDK.
  ///
  /// Reads `ETermInfoKey.SN` from the terminal info first and falls back to
  /// the SDK's base info. Throws a [PlatformException] with code `PAX_ERROR`
  /// if the SDK is unavailable or reports no serial number.
  static Future<String?> getSerial() async {
    return await _channel.invokeMethod<String>('getSerialNumber');
  }
}
