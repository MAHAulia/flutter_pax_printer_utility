## 0.0.1

* Initial release

## 0.0.2

* Implement other function

## 0.0.3

* Fix Generate QR

## 0.0.4

* Fix Generate QR with template

## 0.1.0

* Add printImageUrl and printImageAsset

## 0.1.1

* Fix set indent function
* Fix implementation of set font size

## 0.1.2

* Fix for release apk by adding some config on build.gradle
* update readme about fix for release apk.

## 0.1.3

* (update) Remove bind bindPrinter
* (update) Replace init() with init
* (update) Replace bindPrinter with init
* (update) Change getStatus response from string to enum PrinterStatus
* (fix) Print Bitmap Function
* (update) Add example Print Bitmap Receipt

## 0.1.4

* (fix) Implemented various printer statuses correctly
* (update) Added better API documentation
* (update) Changed package description 

## 0.1.5

* Updated code to match Dart formatter.
* Updated example app code to remove problems found by dart analyze
* Updated README doc

## 0.1.6

* (update) Updated NeptuneLight to newer version
* (fix) Fixed issues on Android 12 and 64 bit devices
* (update) Updated README doc

## 0.1.7

* (update) Added `PaxDeviceInfo.getSerial()` to read the terminal's serial number
* (update) Added `printBarcode` with `PaxBarcodeFormat` (Code 128/39/93, Codabar, EAN-8/13, UPC-A/E, ITF, QR, PDF417, Data Matrix, Aztec)
* (update) Added `printDivider` for solid or dashed divider lines
* (update) Added `printRow`, `formatRow`, `PrintColumn` and `charsPerLine` for receipt-style rows with column widths and alignment
* (update) Added `getPaperSize` (`PaxPaperSize`) and `PaxDeviceInfo.getTermInfo()` (terminal model and firmware versions)
* (fix) QR bitmaps use the encoded width as the row stride instead of the requested width, which made `setPixels` throw whenever zxing returned a different size
* (fix) `printImageUrl` replies on the main thread and returns whether the image printed
* (fix) `printBitmap` skips a missing image instead of passing it to the printer