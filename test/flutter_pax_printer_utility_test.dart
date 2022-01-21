import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_pax_printer_utility');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterPaxPrinterUtility.platformVersion, '42');
  });
}
