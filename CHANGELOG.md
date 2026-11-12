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

* (update) Updated NeptuneLiteApi from V4.09.00 to V4.26.00 (20260408), including the SDK's native libraries for 32-bit ARM
* (update) Added `PaxDeviceInfo.getSerial()` to read the terminal's serial number
* (update) Added `printBarcode` with `PaxBarcodeFormat` (Code 128/39/93, Codabar, EAN-8/13, UPC-A/E, ITF, QR, PDF417, Data Matrix, Aztec)
* (update) Added `printDivider` for solid or dashed divider lines
* (update) Added `printRow`, `formatRow`, `PrintColumn` and `charsPerLine` for receipt-style rows with column widths and alignment
* (update) Added `getPaperSize` (`PaxPaperSize`) and `PaxDeviceInfo.getTermInfo()` (terminal model and firmware versions)
* (fix) QR bitmaps use the encoded width as the row stride instead of the requested width, which made `setPixels` throw whenever zxing returned a different size
* (fix) All printer calls run in order on one background thread and reply on the main thread. `start()` (and the `printReceipt`/`printQR` templates) no longer block the app's UI while a slip prints, and a second print job can't start before the first one finishes
* (fix) `printImageUrl` replies on the main thread and returns whether the image printed
* (fix) `printBitmap` skips a missing image instead of passing it to the printer* (breaking) Printer errors are no longer swallowed: calls throw a `PlatformException` with code `PRINTER_ERROR` (`details`: the PAX SDK error code) instead of returning `true` or an empty status. Unknown status codes are returned as "Unknown printer status N"
* (fix) `printReceiptWithQr` printed the receipt without its QR code: it called the plain `printReceipt` template
* (fix) `printBitmap`, `printImageAsset` and `printQRCode` return `false` when there is no image to print, instead of `true`
* (fix) Calls such as `getStatus` work before `init`
* (fix) `printImageUrl` downloads on its own thread, so a slow server no longer holds up other printer calls; it gives up after 30 seconds, rejects HTTP errors and images over 10 MB, and downsamples very large images
* (breaking) The plugin's manifest now requests only `com.pax.permission.PRINTER` and `INTERNET`. Apps that use the camera, Bluetooth, storage or other PAX modules (card readers, PED) must declare those permissions themselves
* (update) Ships the PAX SDK's ProGuard/R8 keep rules, so release builds work with `minifyEnabled` and `shrinkResources` on
* (fix) Removed native libraries built for the wrong ABI (a 32-bit `libDCL.so` in `arm64-v8a`, ARM binaries in `x86`) and the duplicate `armeabi` folder, halving the plugin's native libraries
* (update) The minimum Flutter version is 3.7.3, matching the Dart 2.19.2 minimum
* (update) README: usage examples for every feature, error codes, and release builds
* (fix) `spaceSet` accepts the SDK's full 0-255 range; values above 127 used to fail. Values outside 0-255 throw an `ArgumentError`
