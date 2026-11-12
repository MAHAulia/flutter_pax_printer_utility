import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';

void main() {
  group('formatRow', () {
    test('shares the line between flex columns and aligns text', () {
      final row = FlutterPaxPrinterUtility.formatRow([
        const PrintColumn('Item', flex: 3),
        const PrintColumn('10.00', align: PrintAlign.RIGHT),
      ], charsPerLine: 32);
      expect(row, 'Item                       10.00');
      expect(row.length, 32);
    });

    test('fixed widths are kept and the flex column takes the rest', () {
      final row = FlutterPaxPrinterUtility.formatRow([
        const PrintColumn('2', width: 3),
        const PrintColumn('Coffee'),
        const PrintColumn('R 25.00', width: 9, align: PrintAlign.RIGHT),
      ], charsPerLine: 32);
      expect(row, '2  Coffee                R 25.00');
      expect(row.length, 32);
    });

    test('centres text', () {
      final row = FlutterPaxPrinterUtility.formatRow(
          [const PrintColumn('TOTAL', align: PrintAlign.CENTER)],
          charsPerLine: 11);
      expect(row, '   TOTAL   ');
    });

    test('wraps long text at spaces within its column', () {
      final row = FlutterPaxPrinterUtility.formatRow([
        const PrintColumn('Diesel 50ppm premium blend', width: 13),
        const PrintColumn('1.00', align: PrintAlign.RIGHT),
      ], charsPerLine: 20);
      expect(row.split('\n'), [
        'Diesel 50ppm    1.00',
        'premium blend       ',
      ]);
    });

    test('hard-breaks a word longer than its column', () {
      final row = FlutterPaxPrinterUtility.formatRow(
          [const PrintColumn('ABCDEFGHIJ', width: 4)],
          charsPerLine: 4);
      expect(row.split('\n'), ['ABCD', 'EFGH', 'IJ  ']);
    });

    test('rejects fixed widths wider than the line', () {
      expect(
          () => FlutterPaxPrinterUtility.formatRow([
                const PrintColumn('a', width: 20),
                const PrintColumn('b', width: 20),
              ], charsPerLine: 32),
          throwsArgumentError);
    });

    test('rejects a flex column squeezed to nothing', () {
      expect(
          () => FlutterPaxPrinterUtility.formatRow([
                const PrintColumn('a', width: 32),
                const PrintColumn('b'),
              ], charsPerLine: 32),
          throwsArgumentError);
    });
  });

  test('charsPerLine divides the paper width by the font width', () {
    expect(
        FlutterPaxPrinterUtility.charsPerLine(EFontTypeAscii.FONT_12_24), 32);
    expect(FlutterPaxPrinterUtility.charsPerLine(EFontTypeAscii.FONT_8_16), 48);
    expect(
        FlutterPaxPrinterUtility.charsPerLine(EFontTypeAscii.FONT_12_24,
            paperSize: PaxPaperSize.MM_80),
        48);
  });

  group('platform calls', () {
    const channel = MethodChannel('flutter_pax_printer_utility');
    final calls = <MethodCall>[];
    Object? reply;

    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(() {
      calls.clear();
      reply = true;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return reply;
      });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('printBarcode sends format name, size defaults and paper width',
        () async {
      await FlutterPaxPrinterUtility.printBarcode(
          '123456789012', PaxBarcodeFormat.EAN_13);
      await FlutterPaxPrinterUtility.printBarcode(
          'hello', PaxBarcodeFormat.DATA_MATRIX);
      expect(calls[0].method, 'printBarcode');
      expect(calls[0].arguments, {
        'data': '123456789012',
        'format': 'EAN_13',
        'width': 384,
        'height': 100,
        'maxWidth': 384,
      });
      expect(calls[1].arguments['width'], 256);
      expect(calls[1].arguments['height'], 256);
    });

    test('printDivider sends the paper width', () async {
      await FlutterPaxPrinterUtility.printDivider(
          dashed: true, paperSize: PaxPaperSize.MM_80);
      expect(calls.single.arguments,
          {'width': 576, 'thickness': 2, 'dashed': true});
    });

    test('printRow prints the formatted row with a newline', () async {
      await FlutterPaxPrinterUtility.printRow([
        const PrintColumn('A'),
        const PrintColumn('B', align: PrintAlign.RIGHT)
      ], charsPerLine: 4);
      expect(calls.single.method, 'printStr');
      expect(calls.single.arguments['text'], 'A  B\n');
    });

    test('printReceiptWithQr calls the QR receipt template', () async {
      reply = 'Success';
      await FlutterPaxPrinterUtility.printReceiptWithQr('Hi\r\n', 'https://x');
      expect(calls.single.method, 'printReceiptWithQr');
      expect(
          calls.single.arguments, {'text': 'Hi\n', 'qr_string': 'https://x'});
    });

    test('getPaperSize maps the SDK sizes in inches', () async {
      reply = 2;
      expect(await FlutterPaxPrinterUtility.getPaperSize, PaxPaperSize.MM_58);
      reply = 3;
      expect(await FlutterPaxPrinterUtility.getPaperSize, PaxPaperSize.MM_80);
      for (final other in [-1, 0, 1, 4]) {
        reply = other;
        expect(
            await FlutterPaxPrinterUtility.getPaperSize, PaxPaperSize.UNKNOWN);
      }
    });
  });
}
