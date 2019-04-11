package cn.keking.config;

/**
 * @auther: chenjh
 * @time: 2019/4/10 17:22
 * @description
 */
public class ConfigConstants {

    private static String[] simText = {};
    private static String[] media = {};
    private static String convertedFileCharset;

    public static String[] getSimText() {
        return simText;
    }

    public static void setSimText(String[] simText) {
        ConfigConstants.simText = simText;
    }

    public static String[] getMedia() {
        return media;
    }

    public static void setMedia(String[] media) {
        ConfigConstants.media = media;
    }

    public static String getConvertedFileCharset() {
        return convertedFileCharset;
    }

    public static void setConvertedFileCharset(String convertedFileCharset) {
        ConfigConstants.convertedFileCharset = convertedFileCharset;
    }

}
