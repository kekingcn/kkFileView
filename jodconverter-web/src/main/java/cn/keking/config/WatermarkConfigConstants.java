package cn.keking.config;

import org.springframework.beans.factory.annotation.Value;

/**
 * @author chenjh
 * @since 2020/5/13 17:44
 */
public class WatermarkConfigConstants {

    private static String WATERMARK_TXT;
    private static String WATERMARK_X_SPACE;
    private static String WATERMARK_Y_SPACE;
    private static String WATERMARK_FONT;
    private static String WATERMARK_FONTSIZE;
    private static String WATERMARK_COLOR;
    private static String WATERMARK_ALPHA;
    private static String WATERMARK_WIDTH;
    private static String WATERMARK_HEIGHT;
    private static String WATERMARK_ANGLE;

    public static String DEFAULT_WATERMARK_TXT = "";
    public static String DEFAULT_WATERMARK_X_SPACE = "10";
    public static String DEFAULT_WATERMARK_Y_SPACE = "10";
    public static String DEFAULT_WATERMARK_FONT = "微软雅黑";
    public static String DEFAULT_WATERMARK_FONTSIZE = "18px";
    public static String DEFAULT_WATERMARK_COLOR = "black";
    public static String DEFAULT_WATERMARK_ALPHA = "0.2";
    public static String DEFAULT_WATERMARK_WIDTH = "240";
    public static String DEFAULT_WATERMARK_HEIGHT = "80";
    public static String DEFAULT_WATERMARK_ANGLE = "10";

    public static String getWatermarkTxt() {
        return WATERMARK_TXT;
    }

    public static void setWatermarkTxtValue(String watermarkTxt) {
        WATERMARK_TXT = watermarkTxt;
    }

    @Value("${watermark.txt:}")
    public void setWatermarkTxt(String watermarkTxt) {
        setWatermarkTxtValue(watermarkTxt);
    }

    public static String getWatermarkXSpace() {
        return WATERMARK_X_SPACE;
    }

    public static void setWatermarkXSpaceValue(String watermarkXSpace) {
        WATERMARK_X_SPACE = watermarkXSpace;
    }

    @Value("${watermark.x.space:10}")
    public void setWatermarkXSpace(String watermarkXSpace) {
        setWatermarkXSpaceValue(watermarkXSpace);
    }

    public static String getWatermarkYSpace() {
        return WATERMARK_Y_SPACE;
    }

    public static void setWatermarkYSpaceValue(String watermarkYSpace) {
        WATERMARK_Y_SPACE = watermarkYSpace;
    }

    @Value("${watermark.y.space:10}")
    public void setWatermarkYSpace(String watermarkYSpace) {
        setWatermarkYSpaceValue(watermarkYSpace);
    }

    public static String getWatermarkFont() {
        return WATERMARK_FONT;
    }

    public static void setWatermarkFontValue(String watermarkFont) {
        WATERMARK_FONT = watermarkFont;
    }

    @Value("${watermark.font:微软雅黑}")
    public void setWatermarkFont(String watermarkFont) {
        setWatermarkFontValue(watermarkFont);
    }

    public static String getWatermarkFontsize() {
        return WATERMARK_FONTSIZE;
    }

    public static void setWatermarkFontsizeValue(String watermarkFontsize) {
        WATERMARK_FONTSIZE = watermarkFontsize;
    }

    @Value("${watermark.fontsize:18px}")
    public void setWatermarkFontsize(String watermarkFontsize) {
        setWatermarkFontsizeValue(watermarkFontsize);
    }

    public static String getWatermarkColor() {
        return WATERMARK_COLOR;
    }

    public static void setWatermarkColorValue(String watermarkColor) {
        WATERMARK_COLOR = watermarkColor;
    }

    @Value("${watermark.color:black}")
    public void setWatermarkColor(String watermarkColor) {
        setWatermarkColorValue(watermarkColor);
    }

    public static String getWatermarkAlpha() {
        return WATERMARK_ALPHA;
    }

    public static void setWatermarkAlphaValue(String watermarkAlpha) {
        WATERMARK_ALPHA = watermarkAlpha;
    }

    @Value("${watermark.alpha:0.2}")
    public void setWatermarkAlpha(String watermarkAlpha) {
        setWatermarkAlphaValue(watermarkAlpha);
    }

    public static String getWatermarkWidth() {
        return WATERMARK_WIDTH;
    }

    public static void setWatermarkWidthValue(String watermarkWidth) {
        WATERMARK_WIDTH = watermarkWidth;
    }

    @Value("${watermark.width:240}")
    public void setWatermarkWidth(String watermarkWidth) {
        WATERMARK_WIDTH = watermarkWidth;
    }

    public static String getWatermarkHeight() {
        return WATERMARK_HEIGHT;
    }

    public static void setWatermarkHeightValue(String watermarkHeight) {
        WATERMARK_HEIGHT = watermarkHeight;
    }

    @Value("${watermark.height:80}")
    public void setWatermarkHeight(String watermarkHeight) {
        WATERMARK_HEIGHT = watermarkHeight;
    }

    public static String getWatermarkAngle() {
        return WATERMARK_ANGLE;
    }

    public static void setWatermarkAngleValue(String watermarkAngle) {
        WATERMARK_ANGLE = watermarkAngle;
    }

    @Value("${watermark.angle:10}")
    public void setWatermarkAngle(String watermarkAngle) {
        WATERMARK_ANGLE = watermarkAngle;
    }


}
