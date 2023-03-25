package com.mahatech.flutter_pax_printer_utility;

import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.widget.Toast;

import com.pax.dal.IDAL;
import com.pax.dal.IPrinter;
import com.pax.dal.entity.EFontTypeAscii;
import com.pax.dal.entity.EFontTypeExtCode;
import com.pax.dal.exceptions.PrinterDevException;
import com.pax.neptunelite.api.NeptuneLiteUser;

public class PrinterUtility {
    private Context _context;
    private static  IDAL dal;
    private static IPrinter printer;
    private static PrinterUtility printerUtility;

    public PrinterUtility(Context context) {
        this._context = context;
    }

    public IDAL getDal(){
        if(dal == null){
            try {
                long start = System.currentTimeMillis();
                dal = NeptuneLiteUser.getInstance().getDal(this._context);
                Log.i("Test","Get dal cost:"+(System.currentTimeMillis() - start)+" ms");
                // Toast.makeText(this._context, "Get dal cost:"+(System.currentTimeMillis() - start)+" ms", Toast.LENGTH_LONG).show();
            } catch (Exception e) {
                e.printStackTrace();
                // Toast.makeText(this._context, "error occurred,DAL is null.", Toast.LENGTH_LONG).show();
            }
        }
        return dal;
    }

    public void init() {
        try {
            printer = getDal().getPrinter();
            printer.init();
            Log.i("INIT",  "INIT");
            // Toast.makeText(this._context, "SUCCESS INIT PRINTER", Toast.LENGTH_LONG).show();
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("INIT",  String.valueOf(e));
        }
    }

    public String getStatus() {
        try {
            int status = printer.getStatus();
            Log.i("STATUS",  String.valueOf(status));
            // Toast.makeText(this._context, "STATUS : " + String.valueOf(status), Toast.LENGTH_LONG).show();
            return statusCode2Str(status);
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("STATUS", String.valueOf(e));
            return "";
        }

    }

    public void fontSet(EFontTypeAscii asciiFontType, EFontTypeExtCode cFontType) {
        try {
            printer.fontSet(asciiFontType, cFontType);
            Log.i("FONT",  "SET FONT");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("FONT", String.valueOf(e));
        }

    }

    public void spaceSet(byte wordSpace, byte lineSpace) {
        try {
            printer.spaceSet(wordSpace, lineSpace);
            Log.i("SPACE",  "SPACE SET");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("SPACE", String.valueOf(e));
        }
    }

    public void printStr(String str, String charset) {
        try {
            printer.printStr(str, charset);
            Log.i("PRINT",  "PRINT");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("PRINT", String.valueOf(e));
        }

    }

    public void step(int b) {
        try {
            printer.step(b);
            Log.i("STEP",  "SET STEP");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("STEP", String.valueOf(e));
        }
    }

    public void printBitmap(Bitmap bitmap) {
        try {
            printer.printBitmap(bitmap);
            Log.i("BITMAP",  "PRINT BITMAP");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("BITMAP", String.valueOf(e));
        }
    }

    public void printBitmapFromString(String text, int width, int height) {
        try {
            QRCodeUtil qrcodeUtility = new QRCodeUtil();
            printer.printBitmap(qrcodeUtility.encodeAsBitmap(text, width, height ));
            Log.i("BITMAP",  "PRINT BITMAP");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("BITMAP", String.valueOf(e));
        }
    }


    public String start() {
        try {
            int res = printer.start();
            Log.i("START",  String.valueOf(res));
            return statusCode2Str(res);
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("START", String.valueOf(e));
            return "";
        }

    }

    public void leftIndents(int indent) {
        try {
            printer.leftIndent(indent);
            Log.i("LIND",  "LEFT INDENT");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("LIND", String.valueOf(e));
        }
    }

    public int getDotLine() {
        try {
            int dotLine = printer.getDotLine();
            Log.i("DOT",  "GET DOT");
            return dotLine;
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("DOT", String.valueOf(e));
            return -2;
        }
    }

    public void setGray(int level) {
        try {
            printer.setGray(level);
            Log.i("GRAY",  "SET GRAY");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("GRAY", String.valueOf(e));
        }

    }

    public void setDoubleWidth(boolean isAscDouble, boolean isLocalDouble) {
        try {
            printer.doubleWidth(isAscDouble, isLocalDouble);
            Log.i("DWTH",  "DOUBLE WIDTH");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("DWTH", String.valueOf(e));
        }
    }

    public void setDoubleHeight(boolean isAscDouble, boolean isLocalDouble) {
        try {
            printer.doubleHeight(isAscDouble, isLocalDouble);
            Log.i("DHGH",  "DOUBLE HEIGHT");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("DHGH", String.valueOf(e));
        }

    }

    public void setInvert(boolean isInvert) {
        try {
            printer.invert(isInvert);
            Log.i("INVRT",  "SET INVERT");
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("INVRT", String.valueOf(e));
        }

    }

    public String cutPaper(int mode) {
        try {
            printer.cutPaper(mode);
            Log.i("CUT",  "CUT PAPER");
            return "cut paper successful";
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("CUT", String.valueOf(e));
            return e.toString();
        }
    }

    public String getCutMode() {
        String resultStr = "";
        try {
            int mode = printer.getCutMode();
            Log.i("CUTM",  "GET CUT MODE");
            switch (mode) {
                case 0:
                    resultStr = "Only support full paper cut";
                    break;
                case 1:
                    resultStr = "Only support partial paper cutting ";
                    break;
                case 2:
                    resultStr = "support partial paper and full paper cutting ";
                    break;
                case -1:
                    resultStr = "No cutting knife,not support";
                    break;
                default:
                    break;
            }
            return resultStr;
        } catch (PrinterDevException e) {
            e.printStackTrace();
            Log.e("CUTM", String.valueOf(e));
            return e.toString();
        }
    }

    public String statusCode2Str(int status) {
        String res = "";
        switch (status) {
            case 0:
                res = "Success";
                break;
            case 1:
                res = "Printer is busy";
                break;
            case 2:
                res = "Out of paper";
                break;
            case 3:
                res = "The format of print data packet error";
                break;
            case 4:
                res = "Printer malfunctions";
                break;
            case 8:
                res = "Printer over heats";
                break;
            case 9:
                res = "Printer voltage is too low";
                break;
            case 240:
                res = "Printing is unfinished";
                break;
            case 252:
                res = "The printer has not installed font library";
                break;
            case 254:
                res = "Data package is too long";
                break;
            default:
                break;
        }
        return res;
    }
}
