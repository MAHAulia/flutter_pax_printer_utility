package com.mahatech.flutter_pax_printer_utility;

import static java.lang.Byte.parseByte;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Printer;

import androidx.annotation.NonNull;

import com.pax.dal.entity.EFontTypeAscii;
import com.pax.dal.entity.EFontTypeExtCode;

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
  private static PrinterUtility printerUtility;
  private static QRCodeUtil qrcodeUtility;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_pax_printer_utility");
    channel.setMethodCallHandler(this);
    printerUtility =
            new PrinterUtility(flutterPluginBinding.getApplicationContext());
            qrcodeUtility = new QRCodeUtil();
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

      EFontTypeAscii asciiFontType;
      EFontTypeExtCode cFontType;

      if (asciiFontTypeString.equals("FONT_8_16")) {
        asciiFontType = EFontTypeAscii.FONT_8_16;
      } else if (asciiFontTypeString.equals("FONT_16_24")) {
        asciiFontType = EFontTypeAscii.FONT_16_24;
      }else if (asciiFontTypeString.equals("FONT_12_24")) {
        asciiFontType = EFontTypeAscii.FONT_12_24;
      }else if (asciiFontTypeString.equals("FONT_8_32")) {
        asciiFontType = EFontTypeAscii.FONT_8_32;
      }else if (asciiFontTypeString.equals("FONT_16_48")) {
        asciiFontType = EFontTypeAscii.FONT_16_48;
      }else if (asciiFontTypeString.equals("FONT_12_48")) {
        asciiFontType = EFontTypeAscii.FONT_12_48;
      }else if (asciiFontTypeString.equals("FONT_16_16")) {
        asciiFontType = EFontTypeAscii.FONT_16_16;
      }else if (asciiFontTypeString.equals("FONT_32_24")) {
        asciiFontType = EFontTypeAscii.FONT_32_24;
      }else if (asciiFontTypeString.equals("FONT_24_24")) {
        asciiFontType = EFontTypeAscii.FONT_24_24;
      }else if (asciiFontTypeString.equals("FONT_16_32")) {
        asciiFontType = EFontTypeAscii.FONT_16_32;
      }else if (asciiFontTypeString.equals("FONT_32_48")) {
        asciiFontType = EFontTypeAscii.FONT_32_48;
      }else if (asciiFontTypeString.equals("FONT_24_48")) {
        asciiFontType = EFontTypeAscii.FONT_24_48;
      } else {
        asciiFontType = EFontTypeAscii.FONT_8_16;
      }

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
      Thread thread = new Thread(new Runnable() {
        @Override
        public void run() {
          try  {
            printerUtility.printBitmap(qrcodeUtility.getBitmapFromURL(url));
            result.success(true);
          } catch (Exception e) {
            e.printStackTrace();
          }
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

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
