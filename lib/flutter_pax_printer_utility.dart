// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';

import 'package:flutter/services.dart';

/// Prints on PAX terminals through the PAX NeptuneLiteApi SDK.
///
/// All calls run in order on one background thread. When the printer reports
/// an error (for example no paper, or a setting the terminal does not
/// support), the call throws a [PlatformException] with code `PRINTER_ERROR`;
/// its `details` is the SDK's error code. Other native failures, such as a
/// device without the PAX services, throw with code `PAX_ERROR`.
class FlutterPaxPrinterUtility {
  static const MethodChannel _channel =
      MethodChannel('flutter_pax_printer_utility');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Gets the current status of the printer.
  ///
  /// This method returns the current status of the printer as a [PrinterStatus] enum.
  ///
  /// Returns a [Future] that completes with the printer status.
  static Future<PrinterStatus> get getStatus async {
    final String? status = await _channel.invokeMethod('getStatus');
    switch (status) {
      case "Success":
        return PrinterStatus.SUCCESS;
      case "Printer is busy":
        return PrinterStatus.PRINTER_IS_BUSY;
      case "Out of paper":
        return PrinterStatus.OUT_OF_PAPER;
      case "The format of print data packet error":
        return PrinterStatus.FORMAT_PRINT_PACKET_ERROR;
      case "Printer malfunctions":
        return PrinterStatus.PRINTER_MALFUCTION;
      case "Printer over heats":
        return PrinterStatus.PRINTER_OVER_HEATS;
      case "Printer voltage is too low":
        return PrinterStatus.PRINTER_VOLTAGE_IS_TO_LOW;
      case "Printing is unfinished":
        return PrinterStatus.PRINTING_IS_UNFINISHED;
      case "The printer has not installed font library":
        return PrinterStatus.FONT_LIBRARY_NOT_INSTALLED;
      case "Data package is too long":
        return PrinterStatus.DATA_PACKAGE_TO_LONG;
      default:
        return PrinterStatus.UNKNOWN;
    }
  }

  /// Prints a receipt with the specified text.
  ///
  /// This method sends the specified [text] to the printer to be printed as a receipt.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printReceipt(String text) async {
    final String? response = await _channel
        .invokeMethod('printReceipt', {"text": text.replaceAll("\r", "")});
    return response;
  }

  /// Prints a receipt with the specified text and a QR code.
  ///
  /// This method sends the specified [text] and [qrString] to the printer to be printed as a receipt with a QR code.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printReceiptWithQr(
      String text, String qrString) async {
    final String? response = await _channel.invokeMethod('printReceiptWithQr',
        {"text": text.replaceAll("\r", ""), "qr_string": qrString});
    return response;
  }

  /// Prints a receipt with multiple lines of text and a QR code.
  ///
  /// This method sends the specified texts and [qrString] to the printer to be printed as a receipt with a QR code.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> printQRReceipt(String text1, String text2,
      String text3, String text4, String qrString) async {
    Map<String, dynamic> arguments = {
      "text1": text1.replaceAll("\r", ""),
      "text2": text2.replaceAll("\r", ""),
      "text3": text3.replaceAll("\r", ""),
      "text4": text4.replaceAll("\r", ""),
      "qr_string": qrString
    };
    final String? response = await _channel.invokeMethod('printQR', arguments);
    return response;
  }

  /// Initializes the printer.
  ///
  /// This method initializes the printer and prepares it for use.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the initialization.
  static Future<bool?> get init async {
    final bool? status = await _channel.invokeMethod('init');
    return status;
  }

  /// Sets the font type for ASCII and extended code characters.
  ///
  /// This method sets the specified [asciiFontType] and [cFontType] for the printer.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> fontSet(
      EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) async {
    Map<String, dynamic> arguments = {
      "asciiFontType": asciiFontType.toString(),
      "cFontType": cFontType.toString(),
    };
    final bool? response = await _channel.invokeMethod('fontSet', arguments);
    return response;
  }

  /// Sets the word and line spacing.
  ///
  /// [wordSpace] is extra dots between characters and [lineSpace] extra dots
  /// between lines, each 0-255 (the default for both is 0 on thermal
  /// printers). The setting lasts until the next [spaceSet] or [init].
  ///
  /// Throws an [ArgumentError] if either value is outside 0-255.
  static Future<bool?> spaceSet(int wordSpace, int lineSpace) async {
    RangeError.checkValueInInterval(wordSpace, 0, 255, 'wordSpace');
    RangeError.checkValueInInterval(lineSpace, 0, 255, 'lineSpace');
    Map<String, dynamic> arguments = {
      "wordSpace": wordSpace.toString(),
      "lineSpace": lineSpace.toString(),
    };
    final bool? response = await _channel.invokeMethod('spaceSet', arguments);
    return response;
  }

  /// Prints a string with the specified charset.
  ///
  /// This method prints the specified [text] using the given [charset].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printStr(String text, String? charset) async {
    Map<String, dynamic> arguments = {
      "text": text,
      "charset": charset,
    };
    final bool? response = await _channel.invokeMethod('printStr', arguments);
    return response;
  }

  /// Steps the printer by the specified number of steps.
  ///
  /// This method advances the printer by the given [step] count.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> step(int step) async {
    Map<String, dynamic> arguments = {
      "step": step,
    };
    final bool? response = await _channel.invokeMethod('step', arguments);
    return response;
  }

  /// Prints a bitmap image.
  ///
  /// This method prints the specified [bitmap] image.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printBitmap(Uint8List bitmap) async {
    Map<String, dynamic> arguments = {
      "bitmap": bitmap,
    };
    final bool? response =
        await _channel.invokeMethod('printBitmap', arguments);
    return response;
  }

  /// Prints an image from a URL.
  ///
  /// This method prints the image located at the specified [url]. The download
  /// starts straight away; the image still prints in its place in the job.
  ///
  /// Returns `false`, without printing anything, if the image cannot be
  /// downloaded or decoded within 30 seconds (an HTTP error, a timeout, or an
  /// image over 10 MB). Very large images are downsampled.
  static Future<bool?> printImageUrl(String url) async {
    Map<String, dynamic> arguments = {
      "url": url,
    };
    final bool? response =
        await _channel.invokeMethod('printImageUrl', arguments);
    return response;
  }

  /// Prints an image from an asset.
  ///
  /// This method prints the image located at the specified asset [img].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> printImageAsset(String img) async {
    Uint8List byte = await FlutterPaxPrinterUtility().getImageFromAsset(img);
    Map<String, dynamic> arguments = {
      "bitmap": byte,
    };
    final bool? response =
        await _channel.invokeMethod('printImageAsset', arguments);
    return response;
  }

  /// Gets the image bytes from an asset.
  ///
  /// This method loads the image located at the specified [iconPath] and returns its bytes.
  ///
  /// Returns a [Future] that completes with the image bytes as a [Uint8List].
  Future<Uint8List> getImageFromAsset(String iconPath) async {
    return await readFileBytes(iconPath);
  }

  /// Reads the bytes of a file.
  ///
  /// This method reads the file located at the specified [path] and returns its bytes.
  ///
  /// Returns a [Future] that completes with the file bytes as a [Uint8List].
  Future<Uint8List> readFileBytes(String path) async {
    ByteData fileData = await rootBundle.load(path);
    Uint8List fileUnit8List = fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
    return fileUnit8List;
  }

  /// Prints a QR code with the specified text and dimensions.
  ///
  /// This method prints a QR code containing the given [text] with the specified [width] and [height].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
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

  /// Prints a barcode of [data] in the given [format].
  ///
  /// The barcode is encoded on the device (zxing) and printed as a bitmap, so it
  /// is added to the current print job like any other line; call [start] to print.
  ///
  /// [width] and [height] are minimums in printer dots: zxing makes the barcode
  /// larger when the data needs more room. [height] defaults to 100 for 1D
  /// formats and to [width] for square 2D formats (QR, Data Matrix, Aztec).
  /// [paperSize] sets the widest barcode allowed (384 dots on 58mm paper).
  ///
  /// Returns `true` if the barcode was added to the job. Throws a
  /// [PlatformException] with code `INVALID_BARCODE` if [data] is not valid for
  /// [format] (for example letters in an EAN-13), or `BARCODE_TOO_WIDE` if the
  /// encoded barcode is wider than the paper.
  static Future<bool?> printBarcode(String data, PaxBarcodeFormat format,
      {int? width,
      int? height,
      PaxPaperSize paperSize = PaxPaperSize.MM_58}) async {
    final int w = width ?? (format.isSquare ? 256 : paperSize.dots);
    final int h = height ?? (format.isSquare ? w : (format.is2D ? 150 : 100));
    final bool? response = await _channel.invokeMethod('printBarcode', {
      "data": data,
      "format": format.name,
      "width": w,
      "height": h,
      "maxWidth": paperSize.dots,
    });
    return response;
  }

  /// Prints a horizontal divider line across the paper.
  ///
  /// [thickness] is in printer dots. Set [dashed] for a dashed line. The line
  /// is as wide as [paperSize] (384 dots on 58mm paper).
  ///
  /// Returns `true` if the line was added to the current print job.
  static Future<bool?> printDivider(
      {int thickness = 2,
      bool dashed = false,
      PaxPaperSize paperSize = PaxPaperSize.MM_58}) async {
    final bool? response = await _channel.invokeMethod('printDivider', {
      "width": paperSize.dots,
      "thickness": thickness,
      "dashed": dashed,
    });
    return response;
  }

  /// Prints one row of [columns], like a receipt line ("Item ...... 10.00").
  ///
  /// The row is laid out by [formatRow] and printed with [printStr], so the
  /// current font applies. [charsPerLine] must match the font and paper; use
  /// [FlutterPaxPrinterUtility.charsPerLine] to work it out (32 for
  /// `FONT_12_24` on 58mm paper).
  static Future<bool?> printRow(List<PrintColumn> columns,
      {int charsPerLine = 32, String? charset}) async {
    return printStr(
        '${formatRow(columns, charsPerLine: charsPerLine)}\n', charset);
  }

  /// Lays out [columns] as fixed-width text, [charsPerLine] characters wide.
  ///
  /// Columns with a [PrintColumn.width] get exactly that many characters; the
  /// rest share the remaining space by [PrintColumn.flex]. Text that does not
  /// fit wraps onto extra lines within its column, breaking at spaces where
  /// possible. Lines are separated by `\n` with no trailing newline.
  ///
  /// Throws an [ArgumentError] if the fixed widths do not fit in
  /// [charsPerLine] or a column would end up narrower than one character.
  static String formatRow(List<PrintColumn> columns, {int charsPerLine = 32}) {
    if (columns.isEmpty) {
      throw ArgumentError.value(columns, 'columns', 'must not be empty');
    }
    final int fixed = columns.fold(0, (sum, c) => sum + (c.width ?? 0));
    final int flexTotal =
        columns.fold(0, (sum, c) => sum + (c.width == null ? c.flex : 0));
    final int remaining = charsPerLine - fixed;
    if (remaining < 0) {
      throw ArgumentError(
          'Column widths ($fixed) exceed charsPerLine ($charsPerLine)');
    }

    // Share the remaining characters between flex columns; the last flex
    // column takes whatever rounding leaves over.
    final widths = <int>[];
    int flexLeft = remaining;
    final int lastFlex = columns.lastIndexWhere((c) => c.width == null);
    for (int i = 0; i < columns.length; i++) {
      final c = columns[i];
      if (c.width != null) {
        widths.add(c.width!);
      } else if (i == lastFlex) {
        widths.add(flexLeft);
      } else {
        final int w = remaining * c.flex ~/ flexTotal;
        widths.add(w);
        flexLeft -= w;
      }
    }
    for (int i = 0; i < widths.length; i++) {
      if (widths[i] < 1) {
        throw ArgumentError('Column $i would be ${widths[i]} characters wide; '
            'widen charsPerLine or reduce the other columns');
      }
    }

    final cells = <List<String>>[
      for (int i = 0; i < columns.length; i++) _wrap(columns[i].text, widths[i])
    ];
    final int lineCount = cells.fold(0, (m, c) => c.length > m ? c.length : m);
    final lines = <String>[];
    for (int line = 0; line < lineCount; line++) {
      final buffer = StringBuffer();
      for (int i = 0; i < columns.length; i++) {
        final String text = line < cells[i].length ? cells[i][line] : '';
        buffer.write(_align(text, widths[i], columns[i].align));
      }
      lines.add(buffer.toString());
    }
    return lines.join('\n');
  }

  /// How many characters of [font] fit on one line of [paperSize] paper.
  ///
  /// For example 32 for `FONT_12_24` and 48 for `FONT_8_16` on 58mm paper.
  /// Halve it while double width is on ([setDoubleWidth]).
  static int charsPerLine(EFontTypeAscii font,
      {PaxPaperSize paperSize = PaxPaperSize.MM_58}) {
    final int fontWidth = int.parse(font.toString().split('_')[1]);
    return paperSize.dots ~/ fontWidth;
  }

  /// Gets the paper size the printer is set up for.
  ///
  /// Uses the PAX SDK's `IPrinter.getPrinterSize()`, which reports the paper
  /// width in inches: 2 (58mm) or 3 (80mm). PAX documents it as supported on
  /// the SK700 only (NeptuneLiteApi V4.26); other terminals, such as the
  /// A910S, return [PaxPaperSize.UNKNOWN], as does any other value.
  static Future<PaxPaperSize> get getPaperSize async {
    final int? size = await _channel.invokeMethod('getPrinterSize');
    switch (size) {
      case 2:
        return PaxPaperSize.MM_58;
      case 3:
        return PaxPaperSize.MM_80;
      default:
        return PaxPaperSize.UNKNOWN;
    }
  }

  static List<String> _wrap(String text, int width) {
    final lines = <String>[];
    for (final paragraph in text.replaceAll('\r', '').split('\n')) {
      String rest = paragraph;
      if (rest.isEmpty) {
        lines.add('');
        continue;
      }
      while (rest.length > width) {
        int cut = rest.lastIndexOf(' ', width);
        if (cut <= 0) cut = width;
        lines.add(rest.substring(0, cut).trimRight());
        rest = rest.substring(cut).trimLeft();
      }
      if (rest.isNotEmpty || lines.isEmpty) lines.add(rest);
    }
    return lines;
  }

  static String _align(String text, int width, PrintAlign align) {
    switch (align) {
      case PrintAlign.LEFT:
        return text.padRight(width);
      case PrintAlign.RIGHT:
        return text.padLeft(width);
      case PrintAlign.CENTER:
        final int left = (width - text.length) ~/ 2;
        return (' ' * left + text).padRight(width);
    }
  }

  /// Sets the left indentation for printing.
  ///
  /// This method sets the left indentation of the printer to the specified [indent] value.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> leftIndents(int indent) async {
    Map<String, dynamic> arguments = {
      "indent": indent,
    };
    final bool? response =
        await _channel.invokeMethod('leftIndents', arguments);
    return response;
  }

  /// Starts the printer.
  ///
  /// This method starts the printing.
  ///
  /// Returns a [Future] that completes with the printer's response as a [String].
  static Future<String?> start() async {
    final String? response = await _channel.invokeMethod('start');
    return response;
  }

  static Future<int?> getDotLine() async {
    final int? response = await _channel.invokeMethod('getDotLine');
    return response;
  }

  /// Sets the gray level for printing.
  ///
  /// This method sets the gray level of the printer to the specified [level].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setGray(int level) async {
    Map<String, dynamic> arguments = {
      "level": level,
    };
    final bool? response = await _channel.invokeMethod('setGray', arguments);
    return response;
  }

  /// Sets the double width mode for printing.
  ///
  /// This method sets the double width mode of the printer based on the specified [isAscDouble] and [isLocalDouble] values.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
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

  /// Sets the double height mode for printing.
  ///
  /// This method sets the double height mode of the printer based on the specified [isAscDouble] and [isLocalDouble] values.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setDoubleHeight(
      bool isAscDouble, bool isLocalDouble) async {
    Map<String, dynamic> arguments = {
      "isAscDouble": isAscDouble,
      "isLocalDouble": isLocalDouble,
    };
    final bool? response =
        await _channel.invokeMethod('setDoubleHeight', arguments);
    return response;
  }

  /// Sets the invert mode for printing.
  ///
  /// This method sets the invert mode of the printer based on the specified [isInvert] value.
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> setInvert(bool isInvert) async {
    Map<String, dynamic> arguments = {
      "isInvert": isInvert,
    };
    final bool? response = await _channel.invokeMethod('setInvert', arguments);
    return response;
  }

  /// Cuts the paper.
  ///
  /// This method instructs the printer to cut the paper based on the specified [mode].
  ///
  /// Returns a [Future] that completes with a boolean indicating the success of the operation.
  static Future<bool?> cutPaper(int mode) async {
    Map<String, dynamic> arguments = {
      "mode": mode,
    };
    final bool? response = await _channel.invokeMethod('cutPaper', arguments);
    return response;
  }
}

/// Paper widths supported by PAX printers.
enum PaxPaperSize {
  /// 58mm paper, 384 printer dots wide.
  MM_58(384),

  /// 80mm paper, 576 printer dots wide.
  MM_80(576),

  /// The terminal did not report a paper size; treated as 58mm.
  UNKNOWN(384);

  const PaxPaperSize(this.dots);

  /// Printable width in dots.
  final int dots;
}

/// Barcode formats [FlutterPaxPrinterUtility.printBarcode] can print.
enum PaxBarcodeFormat {
  /// Code 128: any ASCII text. The usual choice for general data.
  CODE_128,

  /// Code 39: digits, upper-case letters and `-. $/+%`.
  CODE_39,

  /// Code 93: like Code 39, more compact.
  CODE_93,

  /// Codabar: digits and `-$:/.+`, starting and ending with A-D.
  CODABAR,

  /// EAN-8: 7 digits (check digit added) or 8 digits.
  EAN_8,

  /// EAN-13: 12 digits (check digit added) or 13 digits.
  EAN_13,

  /// UPC-A: 11 digits (check digit added) or 12 digits.
  UPC_A,

  /// UPC-E: 7 or 8 digits starting with 0 or 1.
  UPC_E,

  /// Interleaved 2 of 5: an even number of digits.
  ITF,

  /// QR code (2D).
  QR_CODE,

  /// PDF417 (stacked 2D).
  PDF_417,

  /// Data Matrix (2D).
  DATA_MATRIX,

  /// Aztec (2D).
  AZTEC;

  /// Whether this is a 2D format.
  bool get is2D => index >= QR_CODE.index;

  /// Whether this format is square (QR, Data Matrix, Aztec).
  bool get isSquare => this == QR_CODE || this == DATA_MATRIX || this == AZTEC;
}

/// Text alignment within a [PrintColumn].
enum PrintAlign { LEFT, CENTER, RIGHT }

/// One column of a row printed with [FlutterPaxPrinterUtility.printRow].
class PrintColumn {
  /// The text to print. Long text wraps within the column.
  final String text;

  /// Fixed width in characters. Leave null to share the free space by [flex].
  final int? width;

  /// Share of the free space when [width] is null.
  final int flex;

  /// How the text is aligned within the column.
  final PrintAlign align;

  const PrintColumn(this.text,
      {this.width, this.flex = 1, this.align = PrintAlign.LEFT})
      : assert(width == null || width > 0),
        assert(flex > 0);
}

enum PrinterStatus {
  UNKNOWN,
  SUCCESS,
  PRINTER_IS_BUSY,
  OUT_OF_PAPER,
  FORMAT_PRINT_PACKET_ERROR,
  PRINTER_MALFUCTION,
  PRINTER_OVER_HEATS,
  PRINTER_VOLTAGE_IS_TO_LOW,
  PRINTING_IS_UNFINISHED,
  FONT_LIBRARY_NOT_INSTALLED,
  DATA_PACKAGE_TO_LONG
}

/// Represents different font types for ASCII characters.
///
/// This class provides a set of predefined font types that can be used
/// to specify the font size for ASCII characters. Each font type is
/// represented by a unique string value.
///
/// asciiFontType - EFontTypeAscii
class EFontTypeAscii {
  final String _value;
  const EFontTypeAscii._internal(this._value);

  @override
  toString() => _value;

  /// Font type with size 8x16 pixels.
  ///
  /// This font type represents characters that are 8 pixels wide and 16 pixels tall.
  static const FONT_8_16 = EFontTypeAscii._internal('FONT_8_16');

  /// Font type with size 16x24 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 24 pixels tall.
  static const FONT_16_24 = EFontTypeAscii._internal('FONT_16_24');

  /// Font type with size 12x24 pixels.
  ///
  /// This font type represents characters that are 12 pixels wide and 24 pixels tall.
  static const FONT_12_24 = EFontTypeAscii._internal('FONT_12_24');

  /// Font type with size 8x32 pixels.
  ///
  /// This font type represents characters that are 8 pixels wide and 32 pixels tall.
  static const FONT_8_32 = EFontTypeAscii._internal('FONT_8_32');

  /// Font type with size 16x48 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 48 pixels tall.
  static const FONT_16_48 = EFontTypeAscii._internal('FONT_16_48');

  /// Font type with size 12x48 pixels.
  ///
  /// This font type represents characters that are 12 pixels wide and 48 pixels tall.
  static const FONT_12_48 = EFontTypeAscii._internal('FONT_12_48');

  /// Font type with size 16x16 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 16 pixels tall.
  static const FONT_16_16 = EFontTypeAscii._internal('FONT_16_16');

  /// Font type with size 32x24 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 24 pixels tall.
  static const FONT_32_24 = EFontTypeAscii._internal('FONT_32_24');

  /// Font type with size 24x24 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 24 pixels tall.
  static const FONT_24_24 = EFontTypeAscii._internal('FONT_24_24');

  /// Font type with size 16x32 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 32 pixels tall.
  static const FONT_16_32 = EFontTypeAscii._internal('FONT_16_32');

  /// Font type with size 32x48 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 48 pixels tall.
  static const FONT_32_48 = EFontTypeAscii._internal('FONT_32_48');

  /// Font type with size 24x48 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 48 pixels tall.
  static const FONT_24_48 = EFontTypeAscii._internal('FONT_24_48');
}

/// Represents different font types for extended code characters.
///
/// This class provides a set of predefined font types that can be used
/// to specify the font size for extended code characters. Each font type is
/// represented by a unique string value.
class EFontTypeExtCode {
  final String _value;
  const EFontTypeExtCode._internal(this._value);

  @override
  toString() => _value;

  /// Font type with size 16x16 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 16 pixels tall.
  static const FONT_16_16 = EFontTypeExtCode._internal('FONT_16_16');

  /// Font type with size 24x24 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 24 pixels tall.
  static const FONT_24_24 = EFontTypeExtCode._internal('FONT_24_24');

  /// Font type with size 16x32 pixels.
  ///
  /// This font type represents characters that are 16 pixels wide and 32 pixels tall.
  static const FONT_16_32 = EFontTypeExtCode._internal('FONT_16_32');

  /// Font type with size 24x48 pixels.
  ///
  /// This font type represents characters that are 24 pixels wide and 48 pixels tall.
  static const FONT_24_48 = EFontTypeExtCode._internal('FONT_24_48');

  /// Font type with size 32x16 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 16 pixels tall.
  static const FONT_32_16 = EFontTypeExtCode._internal('FONT_32_16');

  /// Font type with size 48x24 pixels.
  ///
  /// This font type represents characters that are 48 pixels wide and 24 pixels tall.
  static const FONT_48_24 = EFontTypeExtCode._internal('FONT_48_24');

  /// Font type with size 32x32 pixels.
  ///
  /// This font type represents characters that are 32 pixels wide and 32 pixels tall.
  static const FONT_32_32 = EFontTypeExtCode._internal('FONT_32_32');

  /// Font type with size 48x48 pixels.
  ///
  /// This font type represents characters that are 48 pixels wide and 48 pixels tall.
  static const FONT_48_48 = EFontTypeExtCode._internal('FONT_48_48');
}
