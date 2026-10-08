package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import java.io.File;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class KkFileUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(KkFileUtils.class);

    public static final String DEFAULT_FILE_ENCODING = "UTF-8";

    // 路径遍历关键字列表
    private static final Set<String> illegalFileStrList;

    static {
        Set<String> set = new HashSet<>();

        // 基本路径遍历
        Collections.addAll(set, "../", "./", "..\\", ".\\", "\\..", "\\.", "..", "...", "....", ".....");

        // URL编码的路径遍历
        Collections.addAll(set, "%2e%2e%2f", "%2e%2e/", "..%2f", "%2e%2e%5c", "%2e%2e\\", "..%5c",
                "%252e%252e%252f", "%252e%252e/", "..%252f");

        // Unicode编码绕过
        Collections.addAll(set, "\\u002e\\u002e\\u002f", "\\U002e\\U002e\\U002f",
                "\u00c0\u00ae\u00c0\u00ae", "\u00c1\u009c\u00c1\u009c");

        // 特殊分隔符
        Collections.addAll(set, "|..|", "|../|", "|..\\|");

        // Windows特殊路径
        Collections.addAll(set, "\\\\?\\", "\\\\.\\");

        // 转换为不可变集合
        illegalFileStrList = Collections.unmodifiableSet(set);
    }

    /**
     * 检查文件名是否合规
     *
     * @param fileName 文件名
     * @return 合规结果, true:不合规，false:合规
     */
    public static boolean isIllegalFileName(String fileName) {
        for (String str : illegalFileStrList) {
            if (fileName.contains(str)) {
                return true;
            }
        }
        return false;
    }
    public static boolean validateFileNameLength(String fileName) {
        if (fileName == null) {
            return false;
        }
        // 文件名长度限制：255个字符（不包含路径）
        int windowsMaxLength = 255;
        if (fileName.length() > windowsMaxLength) {
            System.err.println("文件名长度超过限制（255个字符）");
            return false;
        }
        return true;
    }

    /**
     * 检查是否是数字
     *
     * @param str 文件名
     * @return 合规结果, true:不合规，false:合规
     */
    public static boolean isInteger(String str) {
        if (StringUtils.hasText(str)) {
            boolean strResult = str.matches("-?[0-9]+.?[0-9]*");
            return strResult;
        }
        return false;
    }

    /**
     * 判断url是否是http资源
     *
     * @param url url
     * @return 是否http
     */
    public static boolean isHttpUrl(URL url) {
        return url.getProtocol().toLowerCase().startsWith("http") || url.getProtocol().toLowerCase().startsWith("https");
    }

    /**
     * 判断url是否是file资源
     *
     */
    public static boolean isFileUrl(URL url) {
        return url.getProtocol().toLowerCase().startsWith("file");
    }

    /**
     * 判断当前操作系统是否为Windows
     */
    static boolean isWindows() {
        return System.getProperty("os.name").toLowerCase().contains("windows");
    }

    /**
     * 判断url是否是ftp资源
     *
     * @param url url
     * @return 是否ftp
     */
    public static boolean isFtpUrl(URL url) {
        return "ftp".equalsIgnoreCase(url.getProtocol());
    }

    /**
     * 删除单个文件
     *
     * @param fileName 要删除的文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    public static boolean deleteFileByName(String fileName) {
        File file = new File(fileName);
        // 如果文件路径所对应的文件存在，并且是一个文件，则直接删除
        if (file.exists() && file.isFile()) {
            if (file.delete()) {
                LOGGER.info("删除单个文件" + fileName + "成功！");
                return true;
            } else {
                LOGGER.info("删除单个文件" + fileName + "失败！");
                return false;
            }
        } else {
            LOGGER.info("删除单个文件失败：" + fileName + "不存在！");
            return false;
        }
    }


    public static String htmlEscape(String input) {
        if (StringUtils.hasText(input)) {
            //input = input.replaceAll("\\{", "%7B").replaceAll("}", "%7D").replaceAll("\\\\", "%5C");
            String htmlStr = HtmlUtils.htmlEscape(input, "UTF-8");
            //& -> &amp;
            return htmlStr.replace("&amp;", "&");
        }
        return input;
    }


    /**
     * 通过文件名获取文件后缀
     *
     * @param fileName 文件名称
     * @return 文件后缀
     */
    public static String suffixFromFileName(String fileName) {
        return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
    }


    /**
     * 根据文件路径删除文件
     *
     * @param filePath 绝对路径
     */
    public static void deleteFileByPath(String filePath) {
        File file = new File(filePath);
        if (file.exists() && !file.delete()) {
            LOGGER.warn("压缩包源文件删除失败:{}！", filePath);
        }
    }

    /**
     * 删除目录及目录下的文件
     *
     * @param dir 要删除的目录的文件路径
     * @return 目录删除成功返回true，否则返回false
     */
    public static boolean deleteDirectory(String dir) {
        // 如果dir不以文件分隔符结尾，自动添加文件分隔符
        if (!dir.endsWith(File.separator)) {
            dir = dir + File.separator;
        }
        File dirFile = new File(dir);
        // 如果dir对应的文件不存在，或者不是一个目录，则退出
        if ((!dirFile.exists()) || (!dirFile.isDirectory())) {
            LOGGER.info("删除目录失败：" + dir + "不存在！");
            return false;
        }
        boolean flag = true;
        // 删除文件夹中的所有文件包括子目录
        File[] files = dirFile.listFiles();
        for (int i = 0; i < Objects.requireNonNull(files).length; i++) {
            // 删除子文件
            if (files[i].isFile()) {
                flag = KkFileUtils.deleteFileByName(files[i].getAbsolutePath());
                if (!flag) {
                    break;
                }
            } else if (files[i].isDirectory()) {
                // 删除子目录
                flag = KkFileUtils.deleteDirectory(files[i].getAbsolutePath());
                if (!flag) {
                    break;
                }
            }
        }

        if (!dirFile.delete() || !flag) {
            LOGGER.info("删除目录失败！");
            return false;
        }
        return true;
    }

    /**
     * 判断文件是否允许上传
     *
     * @param file 文件扩展名
     * @return 是否允许上传
     */
    public static boolean isAllowedUpload(String file) {
        String fileType = suffixFromFileName(file);
        for (String type : ConfigConstants.getProhibit()) {
            if (type.equals(fileType)){
                return false;
            }
        }
        return !ObjectUtils.isEmpty(fileType);
    }

    /**
     * 判断文件是否存在
     *
     * @param filePath 文件路径
     * @return 是否存在 true:存在，false:不存在
     */
    public static boolean isExist(String filePath) {
        File file = new File(filePath);
        return file.exists();
    }
    /**
     * 判断是否是数字
     */
    public static boolean isNumeric(String str){
        Pattern pattern = Pattern.compile("[0-9]*");
        if (ObjectUtils.isEmpty(str)){
            return false;
        }
        Matcher isNum = pattern.matcher(str);
        return isNum.matches();
    }

    /**
     * 根据文件源 URL 生成稳定的短哈希，用于隔离不同路径下同名文件的物理缓存，
     * 避免转换产物被互相覆盖（kkFileView #791）。
     * 取 MD5 前 12 位十六进制，结果不含路径分隔符，可直接拼入文件名。
     *
     * @param url 文件源 URL（与 getFileAttribute 中规范化后的 url 保持一致即可）
     * @return 12 位十六进制短哈希；url 为 null 时返回 "null"
     */
    public static String urlCacheKey(String url) {
        if (url == null) {
            return "null";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(url.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(24);
            for (int i = 0; i < 12 && i < digest.length; i++) {
                sb.append(String.format("%02x", digest[i] & 0xff));
            }
            return sb.toString();
        } catch (Exception e) {
            // MD5 为 JDK 必带算法，正常情况下不会进入此分支
            throw new IllegalStateException("MD5 algorithm not available", e);
        }
    }
}
