package cn.keking.utils;

import cpdetector.CharsetPrinter;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Objects;

public class KkFileUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(KkFileUtils.class);

    public static final String DEFAULT_FILE_ENCODING = "UTF-8";

    /**
     * 将文件路径替换扩展名后缀。如果原文件路径没有扩展名则直接添加。
     *
     * @param filePath     原文件路径
     * @param newExtension 新的扩展名，如果不以 '.' 开头则自动加上去
     *
     * @return 替换后的新文件路径
     */
    public static String changeExtension(String filePath, String newExtension) {
        newExtension = StringUtils.prependIfMissing(newExtension, ".");  // 如果没有带点则加上去
        return filePath.contains(".") ?
                (filePath.substring(0, filePath.lastIndexOf(".")) + newExtension) :
                (filePath + newExtension);
    }

    /**
     * 删除文件路径的扩展名
     *
     * @param filePath 文件路径
     *
     * @return 处理结果，如果 filePath 为 null 或没有扩展名则返回原值
     */
    public static String removeExtension(String filePath) {
        if (filePath == null) {
            return null;
        } else if (!filePath.contains(".")) {
            return filePath;
        } else if (!filePath.contains("/")) {
            return filePath.substring(0, filePath.lastIndexOf("."));
        } else {
            // 路径中的'.'不属于扩展名分隔符
            int separatorIndex = filePath.lastIndexOf(".", filePath.lastIndexOf("/"));
            return separatorIndex == -1 ? filePath : filePath.substring(0, separatorIndex);
        }
    }

    /**
     * 判断url是否是http资源
     *
     * @param url url
     *
     * @return 是否http
     */
    public static boolean isHttpUrl(URL url) {
        return url.getProtocol().toLowerCase().startsWith("file") || url.getProtocol().toLowerCase().startsWith("http");
    }

    /**
     * 判断url是否是ftp资源
     *
     * @param url url
     *
     * @return 是否ftp
     */
    public static boolean isFtpUrl(URL url) {
        return "ftp".equalsIgnoreCase(url.getProtocol());
    }

    /**
     * 删除单个文件
     *
     * @param fileName 要删除的文件的文件名
     *
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

    /**
     * 检测文件编码格式
     *
     * @param filePath 绝对路径
     *
     * @return 编码格式
     */
    public static String getFileEncode(String filePath) {
        return getFileEncode(new File(filePath));
    }

    /**
     * 检测文件编码格式
     *
     * @param file 检测的文件
     *
     * @return 编码格式
     */
    public static String getFileEncode(File file) {
        CharsetPrinter cp = new CharsetPrinter();
        try {
            String encoding = cp.guessEncoding(file);
            LOGGER.info("检测到文件【{}】编码: {}", file.getAbsolutePath(), encoding);
            return encoding;
        } catch (IOException e) {
            LOGGER.warn("文件编码获取失败，采用默认的编码格式：UTF-8", e);
            return DEFAULT_FILE_ENCODING;
        }
    }

    /**
     * 通过文件名获取文件后缀
     *
     * @param fileName 文件名称
     *
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
     *
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
     * 写文件，自动创建目录
     *
     * @param is         文件内容
     * @param outputPath 文件路径
     *
     * @throws IOException 如果创建目录或写文件失败
     */
    public static void writeFile(InputStream is, String outputPath) throws IOException {
        Path path = Paths.get(outputPath);
        Files.createDirectories(path.getParent());
        try (OutputStream os = Files.newOutputStream(path)) {
            IOUtils.copy(is, os);
        }
    }

    /**
     * 写文件，自动创建目录
     *
     * @param content    文件内容
     * @param outputPath 文件路径
     *
     * @throws IOException 如果创建目录或写文件失败
     */
    public static void writeFile(byte[] content, String outputPath) throws IOException {
        Path path = Paths.get(outputPath);
        Files.createDirectories(path.getParent());
        Files.write(path, content);
    }
}
