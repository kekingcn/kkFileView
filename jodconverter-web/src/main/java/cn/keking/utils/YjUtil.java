package cn.keking.utils;

import java.io.File;


public class YjUtil {

    public static String encodePath(String srcPath) {
        if (File.separator.equals("/")) {
            srcPath = srcPath.replace("\\", "/");
        } else {
            srcPath = srcPath.replace("/", "\\");
        }
        return srcPath;
    }
}
