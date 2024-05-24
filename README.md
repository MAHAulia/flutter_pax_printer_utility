# flutter_pax_printer_utility

#### This package based on [PAX Device with NetptuneLiteApi](https://docs.hips.com/docs/pax-a920 "PAX Device") SDK

## Important: 
  **THIS PACKAGE WILL WORK ONLY IN ANDROID!**

## Installation  

```bash
flutter pub add flutter_pax_printer_utility
```


## Set minify and shrink on your buildtype gradle

```bash
add this line in your build.gradle
buildTypes {
    release {
        .
        .
        .
        minifyEnabled false
        shrinkResources false
    }
}
```

## What this package do
- [✅] Init Printer => use init
- [✅] Get Status Printer => use getStatus
- [✅] set setGray level => use setGray
- [✅] set Print => use setInvert
- [✅] Change font set => use fontSet
- [✅] Change space set => use spaceSet
- [✅] Write some text => use printStr
- [✅] Jump (n) lines => use step
- [✅] Bold mode on/off => use setDoubleWidth and setDoubleHeight to true
- [✅] Print Qrcodes => use printQRCode
- [✅] Cut paper - Dedicated method just to cut the line
- [✅] Print image from asset or from web (example show how to print both) => use printImageUrl
- [✅] Print Bitmap => use printBitmap
- [✅] Print Image From Asset => use printImageAsset
- [✅]  Set Left Indents => use leftIndents
- [ ] Draw a divisor line
- [ ] Print all types of Barcodes (see enum below)
- [ ] Print rows like recepit with custom width and alignment
- [ ] Able to combine with some esc/pos code that you already have!
- [ ] Printer serial no - Get the serial number of the printer
- [ ] Printer version - Get the printer's version
- [ ] Printer paper size - Get the paper size ( 0: 80mm 1: 58mm)

## Other Function
- Tempalte Print Receipt With QR => printReceiptWithQr
- Template Print Receipt => printReceipt
- Tempalte Print QR with info => printQRReceipt

## If you have an Pax Terminal printer and need help with integration process, just [Contact Me](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)

 - [Github](https://github.com/AuliaVailo)
 - [Email](mailto:abdul.haq.aulia@gmail.com)
 - [Youtube](https://www.youtube.com/channel/UC02Kasrd4--IzX2mNcI2tWg)
 - [Linkdin](https://www.linkedin.com/in/moh-abdul-haq-aulia-29a925169/)

## Tested Devices

```bash
PAX A920 
PAX A910S
```

## Buy me a coffe
If you want to support this package, you can [☕️ Buy Me a Coffee](https://www.buymeacoffee.com/abdulhaqaulia) <br>or you can scan this qr for support with [☕️ Saweria](https://saweria.co/overlays/qr?streamKey=54dc04b8045bb0355cde915ab1bb85b5&topLabel=MAHA&bottomLabel=Buy+Me+A+Coffe&backgroundColor=%232b9dfaFF&barcodeColor=%23000&username=maha)
