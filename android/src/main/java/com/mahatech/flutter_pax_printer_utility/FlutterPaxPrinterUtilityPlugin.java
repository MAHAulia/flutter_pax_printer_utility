package com.mahatech.flutter_pax_printer_utility;

import static java.lang.Byte.parseByte;

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

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_pax_printer_utility");
    channel.setMethodCallHandler(this);
    printerUtility =
            new PrinterUtility(flutterPluginBinding.getApplicationContext());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("bindPrinter")) {
      printerUtility.getDal();
      printerUtility.init();
      result.success(true);
    } else if (call.method.equals("getStatus")) {
      String status = printerUtility.getStatus();
      result.success(status);
    } else if (call.method.equals("getStatus")) {
      String status = printerUtility.getStatus();
      result.success(status);
    }  else if (call.method.equals("printReceipt")) {
      String text = call.argument("text");
      printerUtility.getDal();
      printerUtility.init();
      printerUtility.fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16);
      printerUtility.spaceSet(parseByte("0"), parseByte("10"));
      printerUtility.setGray(1);
      printerUtility.printStr(text, null);
      printerUtility.step(150);
      final String status = printerUtility.start();
      result.success(status);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
