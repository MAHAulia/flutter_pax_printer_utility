package com.mahatech.flutter_pax_printer_utility;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Log;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.pdf417.encoder.Dimensions;

import java.util.EnumMap;
import java.util.Map;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public final class QRCodeUtil {
    private QRCodeUtil() {}

    public static Bitmap encodeAsBitmap(String source, int width, int height) {
        try {
            return encodeBarcode(source, BarcodeFormat.QR_CODE, width, height);
        } catch (IllegalArgumentException | WriterException e) {
            // Unsupported format
            return null;
        }
    }

    /// Encodes [source] as a black-on-white barcode bitmap of at least width x height.
    /// zxing may return a larger bitmap when the data needs more room than requested.
    /// Throws IllegalArgumentException or WriterException when the data is not valid
    /// for the format (for example letters in an EAN-13).
    public static Bitmap encodeBarcode(String source, BarcodeFormat format, int width, int height)
            throws WriterException {
        return encodeBarcode(source, format, width, height, Integer.MAX_VALUE);
    }

    /// Like encodeBarcode, but keeps PDF417 within [maxWidth] dots. zxing picks PDF417's
    /// column count from the data alone and adds a 30-module quiet zone per side, which
    /// easily overflows 58mm paper; this caps the columns and uses a 10-module margin.
    public static Bitmap encodeBarcode(String source, BarcodeFormat format, int width, int height,
            int maxWidth) throws WriterException {
        Map<EncodeHintType, Object> hints = null;
        if (format == BarcodeFormat.PDF_417 && maxWidth != Integer.MAX_VALUE) {
            final int margin = 10;
            // A PDF417 row is 17 modules per data column plus 69 for start/stop and row indicators.
            final int maxColumns = Math.max(1, Math.min(30, (maxWidth - 2 * margin - 69) / 17));
            hints = new EnumMap<>(EncodeHintType.class);
            hints.put(EncodeHintType.MARGIN, margin);
            hints.put(EncodeHintType.PDF417_DIMENSIONS, new Dimensions(1, maxColumns, 3, 90));
            width = Math.min(width, maxWidth);
        }
        BitMatrix result = new MultiFormatWriter().encode(source, format, width, height, hints);
        return toBitmap(result);
    }

    private static Bitmap toBitmap(BitMatrix matrix) {
        final int w = matrix.getWidth();
        final int h = matrix.getHeight();
        final int[] pixels = new int[w * h];

        for (int y = 0; y < h; y++) {
            final int offset = y * w;
            for (int x = 0; x < w; x++) {
                pixels[offset + x] = matrix.get(x, y) ? Color.BLACK : Color.WHITE;
            }
        }

        final Bitmap bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        // The row stride is the matrix width, not the requested width: they differ
        // when zxing needs more room than requested.
        bitmap.setPixels(pixels, 0, w, 0, 0, w, h);
        return bitmap;
    }

    /// A solid or dashed horizontal line, [width] dots wide and [thickness] dots tall.
    public static Bitmap dividerBitmap(int width, int thickness, boolean dashed) {
        final Bitmap bitmap = Bitmap.createBitmap(width, thickness, Bitmap.Config.ARGB_8888);
        bitmap.eraseColor(Color.WHITE);
        final int dash = 12;
        final int gap = 8;
        for (int x = 0; x < width; x++) {
            boolean black = !dashed || (x % (dash + gap)) < dash;
            if (black) {
                for (int y = 0; y < thickness; y++) {
                    bitmap.setPixel(x, y, Color.BLACK);
                }
            }
        }
        return bitmap;
    }

    /// Largest image download accepted, in bytes.
    static final int MAX_IMAGE_BYTES = 10 * 1024 * 1024;
    /// Images are downsampled (by powers of two) until neither side exceeds this.
    /// Paper is at most 576 dots wide, so this only affects images far larger than
    /// anything that can be printed, and keeps them from exhausting memory.
    static final int MAX_IMAGE_SIDE = 2048;

    /// Downloads and decodes the image at [src], or returns null if it cannot be
    /// fetched (HTTP error, timeout, more than MAX_IMAGE_BYTES) or decoded.
    public static Bitmap getBitmapFromURL(String src) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(src);
            connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);
            connection.setDoInput(true);
            connection.connect();
            final int status = connection.getResponseCode();
            if (status != HttpURLConnection.HTTP_OK) {
                Log.e("PAX", "Image download failed: HTTP " + status + " for " + src);
                return null;
            }
            final byte[] bytes;
            try (InputStream input = connection.getInputStream()) {
                bytes = readAtMost(input, MAX_IMAGE_BYTES);
            }
            if (bytes == null) {
                Log.e("PAX", "Image larger than " + MAX_IMAGE_BYTES + " bytes: " + src);
                return null;
            }
            return decodeBounded(bytes);
        } catch (IOException | ClassCastException e) {
            // ClassCastException: not an http(s) URL.
            Log.e("PAX", "Image download failed for " + src + ": " + e);
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    /// Reads the whole stream, or returns null once it exceeds [limit] bytes.
    private static byte[] readAtMost(InputStream input, int limit) throws IOException {
        final ByteArrayOutputStream out = new ByteArrayOutputStream();
        final byte[] buffer = new byte[16 * 1024];
        int n;
        while ((n = input.read(buffer)) != -1) {
            if (out.size() + n > limit) {
                return null;
            }
            out.write(buffer, 0, n);
        }
        return out.toByteArray();
    }

    /// Decodes [bytes], downsampling so neither side exceeds MAX_IMAGE_SIDE.
    static Bitmap decodeBounded(byte[] bytes) {
        final BitmapFactory.Options bounds = new BitmapFactory.Options();
        bounds.inJustDecodeBounds = true;
        BitmapFactory.decodeByteArray(bytes, 0, bytes.length, bounds);
        int sample = 1;
        while (bounds.outWidth / sample > MAX_IMAGE_SIDE || bounds.outHeight / sample > MAX_IMAGE_SIDE) {
            sample *= 2;
        }
        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inSampleSize = sample;
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
    }

}