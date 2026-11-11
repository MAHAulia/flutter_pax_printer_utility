package com.mahatech.flutter_pax_printer_utility;

import static java.lang.Byte.parseByte;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Looper;
import android.util.Printer;

import androidx.annotation.NonNull;

import com.pax.dal.IDAL;
import com.pax.dal.entity.BaseInfo;
import com.pax.dal.entity.EFontTypeAscii;
import com.pax.dal.entity.EFontTypeExtCode;
import com.pax.dal.entity.ETermInfoKey;

import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterPaxPrinterUtilityPlugin */
public class FlutterPaxPrinterUtilityPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  /// Separate channel for terminal information, used by PaxDeviceInfo in Dart.
  private MethodChannel deviceInfoChannel;
  private static PrinterUtility printerUtility;
  private static QRCodeUtil qrcodeUtility;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_pax_printer_utility");
    channel.setMethodCallHandler(this);
    printerUtility =
            new PrinterUtility(flutterPluginBinding.getApplicationContext());
            qrcodeUtility = new QRCodeUtil();

    deviceInfoChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "pax_device_info");
    deviceInfoChannel.setMethodCallHandler((call, result) -> {
      if (call.method.equals("getSerialNumber")) {
        getSerialNumber(result);
      } else if (call.method.equals("getTermInfo")) {
        getTermInfo(result);
      } else {
        result.notImplemented();
      }
    });
  }

  /// Replies with the terminal info the SDK reports (model, firmware versions, SN, ...),
  /// keyed by ETermInfoKey name. Keys the terminal does not report are left out.
  private void getTermInfo(@NonNull Result result) {
    try {
      IDAL dal = printerUtility.getDal();
      if (dal == null) {
        result.error("PAX_ERROR", "Failed to get DAL instance", null);
        return;
      }
      Map<ETermInfoKey, String> termInfo = dal.getSys().getTermInfo();
      Map<String, String> info = new java.util.HashMap<>();
      if (termInfo != null) {
        for (Map.Entry<ETermInfoKey, String> entry : termInfo.entrySet()) {
          if (entry.getKey() != null && entry.getValue() != null) {
            info.put(entry.getKey().name(), entry.getValue());
          }
        }
      }
      result.success(info);
    } catch (Exception e) {
      result.error("PAX_ERROR", e.getMessage(), null);
    }
  }

  /// Replies with the terminal's serial number: ETermInfoKey.SN from the
  /// terminal info, falling back to BaseInfo.getSn().
  private void getSerialNumber(@NonNull Result result) {
    try {
      IDAL dal = printerUtility.getDal();
      if (dal == null) {
        result.error("PAX_ERROR", "Failed to get DAL instance", null);
        return;
      }

      try {
        Map<ETermInfoKey, String> termInfo = dal.getSys().getTermInfo();
        if (termInfo != null) {
          String serialNumber = termInfo.get(ETermInfoKey.SN);
          if (serialNumber != null && !serialNumber.isEmpty()) {
            result.success(serialNumber);
            return;
          }
        }
      } catch (Exception e) {
        // getTermInfo is not supported on every terminal; fall back to getBaseInfo.
      }

      BaseInfo baseInfo = dal.getSys().getBaseInfo();
      if (baseInfo == null) {
        result.error("PAX_ERROR", "Failed to get base info from device", null);
        return;
      }
      String serialNumber = baseInfo.getSn();
      if (serialNumber == null || serialNumber.isEmpty()) {
        result.error("PAX_ERROR", "Device serial number is empty", null);
        return;
      }
      result.success(serialNumber);
    } catch (Exception e) {
      result.error("PAX_ERROR", e.getMessage(), null);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("init")) { // instant bind or init
      printerUtility.getDal();
      printerUtility.init();
      result.success(true);
    } else if (call.method.equals("getStatus")) {
      String status = printerUtility.getStatus();
      result.success(status);
    }  else if (call.method.equals("printReceipt")) { // instant print receipt
      String text = call.argument("text");
      printerUtility.getDal();
      printerUtility.init();
      printerUtility.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16);
      printerUtility.spaceSet(parseByte("0"), parseByte("10"));
      printerUtility.setGray(1);
      printerUtility.printStr(text, null);
      printerUtility.printStr("", null);
      printerUtility.step(150);
      final String status = printerUtility.start();
      result.success(status);
    } else if (call.method.equals("printReceiptWithQr")) { // instant print receipt
      String text = call.argument("text");
      String qrString = call.argument("qr_string");
      printerUtility.getDal();
      printerUtility.init();
      printerUtility.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16);
      printerUtility.spaceSet(parseByte("0"), parseByte("10"));
      printerUtility.setGray(1);
      printerUtility.printStr(text, null);
      printerUtility.printStr("", null);
      if (qrString != null) {
        printerUtility.printBitmap(qrcodeUtility.encodeAsBitmap(qrString, 512, 512 ));
        printerUtility.printStr("", null);
      }
      printerUtility.step(150);
      final String status = printerUtility.start();
      result.success(status);
    } else if (call.method.equals("printQR")) { // instant print qrcode
      String text1 = call.argument("text1");
      String text2 = call.argument("text2");
      String text3 = call.argument("text3");
      String text4 = call.argument("text4");
      String qrString = call.argument("qr_string");
      printerUtility.getDal();
      printerUtility.init();
      printerUtility.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16);
      printerUtility.spaceSet(parseByte("0"), parseByte("10"));
      printerUtility.setGray(1);
      printerUtility.printStr(text1, null);
      printerUtility.printStr("", null);
      printerUtility.printStr(text2, null);
      printerUtility.printStr(text3, null);
      printerUtility.printStr("", null);
      printerUtility.printBitmap(qrcodeUtility.encodeAsBitmap(qrString, 512, 512 ));
      printerUtility.printStr("", null);
      printerUtility.printStr(text4, null);
      printerUtility.step(150);
      final String status = printerUtility.start();
      result.success(status);
    } else if (call.method.equals("fontSet")) {
      String asciiFontTypeString = call.argument("asciiFontType");
      String cFontTypeString = call.argument("cFontType");

      EFontTypeAscii asciiFontType = asciiFontTypeFromName(asciiFontTypeString);
      EFontTypeExtCode cFontType;

      if (cFontTypeString.equals("FONT_16_16")) {
        cFontType = EFontTypeExtCode.FONT_16_16;
      } else if (cFontTypeString.equals("FONT_24_24")) {
        cFontType = EFontTypeExtCode.FONT_24_24;
      }else if (cFontTypeString.equals("FONT_16_32")) {
        cFontType = EFontTypeExtCode.FONT_16_32;
      }else if (cFontTypeString.equals("FONT_24_48")) {
        cFontType = EFontTypeExtCode.FONT_24_48;
      }else if (cFontTypeString.equals("FONT_32_16")) {
        cFontType = EFontTypeExtCode.FONT_32_16;
      }else if (cFontTypeString.equals("FONT_48_24")) {
        cFontType = EFontTypeExtCode.FONT_48_24;
      }else if (cFontTypeString.equals("FONT_32_32")) {
        cFontType = EFontTypeExtCode.FONT_32_32;
      }else if (cFontTypeString.equals("FONT_48_48")) {
        cFontType = EFontTypeExtCode.FONT_48_48;
      } else {
        cFontType = EFontTypeExtCode.FONT_16_16;
      }
      
      printerUtility.fontSet(asciiFontType, cFontType);
      result.success(true);
    } else if (call.method.equals("spaceSet")) {
      String wordSpace = call.argument("wordSpace");
      String lineSpace = call.argument("lineSpace");
      printerUtility.spaceSet(parseByte(wordSpace), parseByte(lineSpace));
      result.success(true);
    } else if (call.method.equals("printStr")) {
      String text = call.argument("text");
      String charset = call.argument("charset");
      printerUtility.printStr(text, charset);
      result.success(true);
    } else if (call.method.equals("step")) {
      int step = call.argument("step");
      printerUtility.step(step);
      result.success(true);
    } else if (call.method.equals("printBitmap")) {
      byte[] bytes = call.argument("bitmap");
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
      printerUtility.printBitmap(bitmap);
      result.success(true);
    } else if (call.method.equals("printImageUrl")) {
      String url = call.argument("url");
      // Download off the main thread, but reply on it: Flutter requires
      // MethodChannel results to be sent from the platform thread.
      final Handler mainHandler = new Handler(Looper.getMainLooper());
      Thread thread = new Thread(new Runnable() {
        @Override
        public void run() {
          boolean printed = false;
          try {
            printed = printerUtility.printBitmap(qrcodeUtility.getBitmapFromURL(url));
          } catch (Exception e) {
            e.printStackTrace();
          }
          final boolean reply = printed;
          mainHandler.post(new Runnable() {
            @Override
            public void run() {
              result.success(reply);
            }
          });
        }
      });

      thread.start();
    }  else if (call.method.equals("printImageAsset")) {
      byte[] bytes = call.argument("bitmap");
      Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
      printerUtility.printBitmap(bitmap);
      result.success(true);
    } else if (call.method.equals("printQRCode")) {
      String qrString = call.argument("text");
      int width = call.argument("width");
      int height = call.argument("height");
      printerUtility.printBitmap(qrcodeUtility.encodeAsBitmap(qrString, width, height ));
      result.success(true);
    } else if (call.method.equals("printBarcode")) {
      String data = call.argument("data");
      String formatName = call.argument("format");
      int width = call.argument("width");
      int height = call.argument("height");
      int maxWidth = call.argument("maxWidth");
      Bitmap barcode;
      try {
        barcode = QRCodeUtil.encodeBarcode(data, com.google.zxing.BarcodeFormat.valueOf(formatName), width, height, maxWidth);
      } catch (Exception e) {
        result.error("INVALID_BARCODE", "Cannot encode \"" + data + "\" as " + formatName + ": " + e.getMessage(), null);
        return;
      }
      if (barcode.getWidth() > maxWidth) {
        result.error("BARCODE_TOO_WIDE", formatName + " barcode needs " + barcode.getWidth()
                + " dots but the paper is " + maxWidth + " dots wide; shorten the data", null);
        return;
      }
      result.success(printerUtility.printBitmap(barcode));
    } else if (call.method.equals("printDivider")) {
      int width = call.argument("width");
      int thickness = call.argument("thickness");
      boolean dashed = call.argument("dashed");
      result.success(printerUtility.printBitmap(QRCodeUtil.dividerBitmap(width, thickness, dashed)));
    } else if (call.method.equals("getPrinterSize")) {
      result.success(printerUtility.getPrinterSize());
    } else if (call.method.equals("start")) {
      final String status = printerUtility.start();
      result.success(status);
    } else if (call.method.equals("leftIndents")) {
      int indent = call.argument("indent");
      printerUtility.leftIndents(indent);
      result.success(true);
    } else if (call.method.equals("getDotLine")) {
      int dontLine = printerUtility.getDotLine();
      result.success(dontLine);
    } else if (call.method.equals("setGray")) {
      int level = call.argument("level");
      printerUtility.setGray(level);
      result.success(true);
    } else if (call.method.equals("setDoubleWidth")) {
      boolean isAscDouble = call.argument("isAscDouble");
      boolean isLocalDouble = call.argument("isLocalDouble");
      printerUtility.setDoubleWidth(isAscDouble, isLocalDouble);
      result.success(true);
    } else if (call.method.equals("setDoubleHeight")) {
      boolean isAscDouble = call.argument("isAscDouble");
      boolean isLocalDouble = call.argument("isLocalDouble");
      printerUtility.setDoubleHeight(isAscDouble, isLocalDouble);
      result.success(true);
    } else if (call.method.equals("setInvert")) {
      boolean isInvert = call.argument("isInvert");
      printerUtility.setInvert(isInvert);
      result.success(true);
    } else if (call.method.equals("cutPaper")) {
      int mode = call.argument("mode");
      printerUtility.cutPaper(mode);
      result.success(true);
    } else {
      result.notImplemented();
    }
  }

  /// Maps a Dart EFontTypeAscii name to the PAX SDK constant, defaulting to FONT_8_16.
  ///
  /// The PAX SDK marks FONT_16_24, FONT_16_48, FONT_32_24 and FONT_32_48 as deprecated
  /// without naming a replacement. They still print on current terminals and are part
  /// of this plugin's public Dart API, so they stay supported; the warning is suppressed
  /// here only.
  @SuppressWarnings("deprecation")
  private static EFontTypeAscii asciiFontTypeFromName(String name) {
    if (name.equals("FONT_8_16")) {
      return EFontTypeAscii.FONT_8_16;
    } else if (name.equals("FONT_16_24")) {
      return EFontTypeAscii.FONT_16_24;
    } else if (name.equals("FONT_12_24")) {
      return EFontTypeAscii.FONT_12_24;
    } else if (name.equals("FONT_8_32")) {
      return EFontTypeAscii.FONT_8_32;
    } else if (name.equals("FONT_16_48")) {
      return EFontTypeAscii.FONT_16_48;
    } else if (name.equals("FONT_12_48")) {
      return EFontTypeAscii.FONT_12_48;
    } else if (name.equals("FONT_16_16")) {
      return EFontTypeAscii.FONT_16_16;
    } else if (name.equals("FONT_32_24")) {
      return EFontTypeAscii.FONT_32_24;
    } else if (name.equals("FONT_24_24")) {
      return EFontTypeAscii.FONT_24_24;
    } else if (name.equals("FONT_16_32")) {
      return EFontTypeAscii.FONT_16_32;
    } else if (name.equals("FONT_32_48")) {
      return EFontTypeAscii.FONT_32_48;
    } else if (name.equals("FONT_24_48")) {
      return EFontTypeAscii.FONT_24_48;
    } else {
      return EFontTypeAscii.FONT_8_16;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    deviceInfoChannel.setMethodCallHandler(null);
  }
}
