package com.mahatech.flutter_pax_printer_utility;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;

import com.pax.dal.IDAL;
import com.pax.dal.IPrinter;
import com.pax.dal.entity.EFontTypeAscii;
import com.pax.dal.entity.EFontTypeExtCode;
import com.pax.dal.exceptions.PrinterDevException;
import com.pax.neptunelite.api.NeptuneLiteUser;

/// Thin wrapper around the PAX SDK printer.
///
/// Printer errors are not swallowed: every call throws the SDK's PrinterDevException,
/// which the plugin reports to Dart as a PRINTER_ERROR PlatformException.
public class PrinterUtility {
    private static final String TAG = "PAX";
    /// PrinterDevException code for "not support" (PRINTER#100).
    static final int PRINTER_NOT_SUPPORTED = 100;

    private final Context _context;
    private static IDAL dal;
    private static IPrinter printer;

    public PrinterUtility(Context context) {
        this._context = context;
    }

    /// The PAX DAL, or null if the SDK could not provide one.
    public IDAL getDal() {
        if (dal == null) {
            try {
                long start = System.currentTimeMillis();
                dal = NeptuneLiteUser.getInstance().getDal(this._context);
                Log.i(TAG, "Get dal cost: " + (System.currentTimeMillis() - start) + " ms");
            } catch (Exception e) {
                Log.e(TAG, "Could not get the PAX DAL", e);
            }
        }
        return dal;
    }

    private IDAL requireDal() {
        IDAL d = getDal();
        if (d == null) {
            throw new IllegalStateException(
                    "PAX DAL is not available; is this a PAX terminal with the PAX services installed?");
        }
        return d;
    }

    /// The SDK printer, fetched without init() if init has not been called yet.
    private IPrinter printer() {
        if (printer == null) {
            printer = requireDal().getPrinter();
        }
        return printer;
    }

    public void init() throws PrinterDevException {
        printer = requireDal().getPrinter();
        printer.init();
    }

    public String getStatus() throws PrinterDevException {
        return statusCode2Str(printer().getStatus());
    }

    public void fontSet(EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) throws PrinterDevException {
        printer().fontSet(asciiFontType, cFontType);
    }

    public void spaceSet(byte wordSpace, byte lineSpace) throws PrinterDevException {
        printer().spaceSet(wordSpace, lineSpace);
    }

    /// The font, spacing and gray level the printReceipt / printQR templates use.
    /// A terminal that does not support one of these settings still prints the
    /// template with its default; any other printer error is thrown.
    public void applyTemplateStyle() throws PrinterDevException {
        try {
            fontSet(EFontTypeAscii.FONT_8_16, EFontTypeExtCode.FONT_16_16);
            spaceSet((byte) 0, (byte) 10);
            setGray(1);
        } catch (PrinterDevException e) {
            if (e.getErrCode() != PRINTER_NOT_SUPPORTED) {
                throw e;
            }
            Log.i(TAG, "Template style not fully supported by this terminal: " + e.getMessage());
        }
    }

    public void printStr(String str, String charset) throws PrinterDevException {
        printer().printStr(str, charset);
    }

    public void step(int b) throws PrinterDevException {
        printer().step(b);
    }

    /// Adds [bitmap] to the print job. Returns false, without printing, if there is
    /// no bitmap (an image that could not be loaded, decoded or encoded).
    public boolean printBitmap(Bitmap bitmap) throws PrinterDevException {
        if (bitmap == null) {
            Log.e(TAG, "No bitmap to print (image could not be loaded, decoded or encoded)");
            return false;
        }
        printer().printBitmap(bitmap);
        return true;
    }

    /// Cached getPrinterSize answer; null until the terminal has given a definite one.
    private static Integer printerSize;

    /// The PAX SDK's paper size code (getPrinterSize), or -1 if the terminal cannot report it.
    ///
    /// The answer is cached for the life of the app. On terminals without support
    /// (for example the A910S) the SDK prints a stack trace to System.err on every call,
    /// so it is only asked once.
    public int getPrinterSize() {
        if (printerSize != null) {
            return printerSize;
        }
        try {
            // printer() fetches the printer without init(), which would clear a pending job.
            final IPrinter p = printer();
            printerSize = getPrinterSizeQuietly(p);
            Log.i(TAG, "Printer size " + printerSize);
            return printerSize;
        } catch (PrinterDevException e) {
            if (e.getErrCode() == PRINTER_NOT_SUPPORTED) {
                // A definite answer, so remember it and stop asking.
                printerSize = -1;
                Log.i(TAG, "Paper size not reported by this terminal: " + e.getMessage());
            } else {
                Log.w(TAG, "Could not read paper size: " + e);
            }
            return -1;
        } catch (RuntimeException | AbstractMethodError e) {
            // No DAL yet, or firmware without the method: don't cache, it may work later.
            Log.w(TAG, "Could not read paper size: " + e);
            return -1;
        }
    }

    /// Calls getPrinterSize() with System.err muted. On unsupported terminals the
    /// SDK prints its own internal PrintException stack trace before throwing
    /// PrinterDevException, which getPrinterSize() already handles; muting stops that
    /// expected failure showing up as a W/System.err stack trace. System.err is restored
    /// straight after this single call.
    private static synchronized int getPrinterSizeQuietly(IPrinter p) throws PrinterDevException {
        final java.io.PrintStream err = System.err;
        System.setErr(new java.io.PrintStream(new java.io.OutputStream() {
            @Override
            public void write(int b) {
                // discard
            }
        }));
        try {
            return p.getPrinterSize();
        } finally {
            System.setErr(err);
        }
    }

    /// Prints the job. Blocks until the slip has printed, and returns the SDK's
    /// status as text ("Success", "Out of paper", ...).
    public String start() throws PrinterDevException {
        int res = printer().start();
        Log.i(TAG, "start: " + res);
        return statusCode2Str(res);
    }

    public void leftIndents(int indent) throws PrinterDevException {
        printer().leftIndent(indent);
    }

    public int getDotLine() throws PrinterDevException {
        return printer().getDotLine();
    }

    public void setGray(int level) throws PrinterDevException {
        printer().setGray(level);
    }

    public void setDoubleWidth(boolean isAscDouble, boolean isLocalDouble) throws PrinterDevException {
        printer().doubleWidth(isAscDouble, isLocalDouble);
    }

    public void setDoubleHeight(boolean isAscDouble, boolean isLocalDouble) throws PrinterDevException {
        printer().doubleHeight(isAscDouble, isLocalDouble);
    }

    public void setInvert(boolean isInvert) throws PrinterDevException {
        printer().invert(isInvert);
    }

    public void cutPaper(int mode) throws PrinterDevException {
        printer().cutPaper(mode);
    }

    public String statusCode2Str(int status) {
        switch (status) {
            case 0:
                return "Success";
            case 1:
                return "Printer is busy";
            case 2:
                return "Out of paper";
            case 3:
                return "The format of print data packet error";
            case 4:
                return "Printer malfunctions";
            case 8:
                return "Printer over heats";
            case 9:
                return "Printer voltage is too low";
            case 240:
                return "Printing is unfinished";
            case 252:
                return "The printer has not installed font library";
            case 254:
                return "Data package is too long";
            default:
                return "Unknown printer status " + status;
        }
    }
}
