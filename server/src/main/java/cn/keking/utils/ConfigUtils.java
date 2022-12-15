package cn.keking.utils;


import java.io.File;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

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

    public static String getUserDir() {
        String userDir = System.getProperty("user.dir");
        String binFolder = getEnvOrDefault("KKFILEVIEW_BIN_FOLDER", userDir);

        File pluginPath = new File(binFolder);

        // 如果指定了 bin 或其父目录，则返回父目录
        if (new File(pluginPath, "bin").exists()) {
            return pluginPath.getAbsolutePath();

        } else if (pluginPath.exists() && pluginPath.getName().equals("bin")) {
            return pluginPath.getParentFile().getAbsolutePath();

        } else {
            return firstExists(new File(pluginPath, MAIN_DIRECTORY_NAME),
                    new File(pluginPath.getParentFile(), MAIN_DIRECTORY_NAME));
            }
        }

    public static String getCustomizedConfigPath() {
        String homePath = getHomePath();
        String separator = java.io.File.separator;
        return homePath + separator + "config" + separator + "application.properties";
    }

    public synchronized static void restorePropertiesFromEnvFormat(Properties properties) {
        Iterator<Map.Entry<Object, Object>> iterator = properties.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<Object, Object> entry = iterator.next();
            String key = entry.getKey().toString();
            String value = entry.getValue().toString();
            if (value.trim().startsWith("${") && value.trim().endsWith("}")) {
                int beginIndex = value.indexOf(":");
                if (beginIndex < 0) {
                    beginIndex = value.length() - 1;
                }
                int endIndex = value.length() - 1;
                String envKey = value.substring(2, beginIndex);
                String envValue = System.getenv(envKey);
                if (envValue == null || "".equals(envValue.trim())) {
                    value = value.substring(beginIndex + 1, endIndex);
                } else {
                    value = envValue;
                }
                properties.setProperty(key, value);
            }
        }
    }
}
