package org.artofsolving.jodconverter.util;


import java.io.File;

/**
 * @author : kl
 **/
public class ConfigUtils {

    private static final String MAIN_DIRECTORY_NAME = "server";
    private static final String OFFICE_PLUGIN_NAME = "office-plugin";

    public static String getHomePath() {
        String userDir = System.getenv("KKFILEVIEW_BIN_FOLDER");
        if (userDir == null) {
            userDir = System.getProperty("user.dir");
        }
        if (userDir.endsWith("bin")) {
            userDir = userDir.substring(0, userDir.length() - 4);
        } else {
            String separator = File.separator;
            if (userDir.endsWith(MAIN_DIRECTORY_NAME)) {
                userDir = userDir + separator + "src" + separator +  "main";
            } else {
                userDir = userDir + separator + MAIN_DIRECTORY_NAME + separator + "src" + separator + "main";
            }
        }
        return userDir;
    }

    // 获取环境变量，如果找不到则返回默认值
    @SuppressWarnings("SameParameterValue")
    private static String getEnvOrDefault(String key, String def) {
        String value = System.getenv(key);
        return value == null ? def : value;
    }

    // 返回参数列表中第一个真实存在的路径，或者 null
    private static String firstExists(File... paths) {
        for (File path : paths) {
            if (path.exists()) {
                return path.getAbsolutePath();
            }
        }
        return null;
    }

    public static String getOfficePluginPath() {
        String userDir = System.getProperty("user.dir");
        String binFolder = getEnvOrDefault("KKFILEVIEW_BIN_FOLDER", userDir);

        File pluginPath = new File(binFolder);

        // 如果指定了 bin 或其父目录，则返回父目录
        // 否则在当前目录和父目录中寻找 office-plugin
        if (new File(pluginPath, "bin").exists()) {
            return pluginPath.getAbsolutePath();

        } else if (pluginPath.exists() && pluginPath.getName().equals("bin")) {
            return pluginPath.getParentFile().getAbsolutePath();

        } else {
            return firstExists(
                    new File(pluginPath, OFFICE_PLUGIN_NAME),
                    new File(pluginPath.getParentFile(), OFFICE_PLUGIN_NAME)
            );
            }
        }

    public static String getCustomizedConfigPath() {
        String homePath = getHomePath();
        String separator = java.io.File.separator;
        return homePath + separator + "config" + separator + "application.properties";
    }
}
