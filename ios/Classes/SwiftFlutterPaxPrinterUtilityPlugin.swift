import Flutter
import UIKit

public class SwiftFlutterPaxPrinterUtilityPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_pax_printer_utility", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPaxPrinterUtilityPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
