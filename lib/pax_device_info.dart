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

  /// Returns the terminal information the PAX SDK reports, keyed by
  /// `ETermInfoKey` name: for example `MODEL`, `SN`, `AP_VER` (application
  /// processor firmware), `SP_VER` (secure processor firmware), `BIOS_VER`
  /// and `MON_VER`. Keys the terminal does not report are left out.
  ///
  /// The SDK does not report a separate version or serial number for the
  /// built-in printer; these are the terminal's.
  ///
  /// Throws a [PlatformException] with code `PAX_ERROR` if the SDK is
  /// unavailable.
  static Future<Map<String, String>> getTermInfo() async {
    final Map<Object?, Object?>? info =
        await _channel.invokeMethod<Map<Object?, Object?>>('getTermInfo');
    return {
      for (final entry in (info ?? const {}).entries)
        '${entry.key}': '${entry.value}'
    };
  }
}
