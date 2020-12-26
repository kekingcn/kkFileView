package org.artofsolving.jodconverter.util;


import java.io.File;

/**
 * @author : kl
 **/
public class ConfigUtils {

    private static final String MAIN_DIRECTORY_NAME = "server";

    public static String getHomePath() {
        String userDir = System.getenv("KKFILEVIEW_BIN_FOLDER");
        if (userDir == null) {
            userDir = System.getProperty("user.dir");
        }
        if (userDir.endsWith("bin")) {
            userDir = userDir.substring(0, userDir.length() - 4);
        } else {
            String separator = File.separator;
            if (userDir.contains(MAIN_DIRECTORY_NAME)) {
                userDir = userDir + separator + "src" + separator +  "main";
            } else {
                userDir = userDir + separator + MAIN_DIRECTORY_NAME + separator + "src" + separator + "main";
            }
        }
        return userDir;
    }

    public static String getCustomizedConfigPath() {
        String homePath = getHomePath();
        String separator = java.io.File.separator;
        return homePath + separator + "config" + separator + "application.properties";
    }
}
