package cn.keking.utils;

import java.io.File;

/**
 * @auther: chenjh
 * @time: 2019/4/15 9:11
 * @description
 */
public class HomePathUtils {

    public static String getHomePath() {
        String userDir = System.getenv("KKFILEVIEW_BIN_FOLDER");
        if (userDir == null) {
            userDir = System.getProperty("user.dir");
        }
        if (userDir.endsWith("bin")) {
            userDir = userDir.substring(0, userDir.length() - 4);
        } else {
            String separator = File.separator;
            userDir = userDir + separator + "jodconverter-web" + separator + "src" + separator +  "main";
        }
        return userDir;
    }

}
