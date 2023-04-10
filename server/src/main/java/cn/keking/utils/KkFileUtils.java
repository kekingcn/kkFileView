package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class KkFileUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(KkFileUtils.class);

    public static final String DEFAULT_FILE_ENCODING = "UTF-8";

    private static final List<String> illegalFileStrList = new ArrayList<>();

    static {
        illegalFileStrList.add("../");
        illegalFileStrList.add("./");
        illegalFileStrList.add("..\\");
        illegalFileStrList.add(".\\");
        illegalFileStrList.add("\\..");
        illegalFileStrList.add("\\.");
        illegalFileStrList.add("..");
        illegalFileStrList.add("...");
    }

    /**
     * 检查文件名是否合规
     * @param fileName 文件名
     * @return 合规结果,true:不合规，false:合规
     */
    public static boolean isIllegalFileName(String fileName){
        for (String str: illegalFileStrList){
            if(fileName.contains(str)){
                return true;
            }
        }
        return false;
    }
    /**
     * 检查是否是数字
     * @param str 文件名
     * @return 合规结果,true:不合规，false:合规
     */
    public static boolean isInteger(String str) {
        if(StringUtils.hasText(str)){
            boolean strResult = str.matches("-?[0-9]+.?[0-9]*");
            return strResult ;
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
        return url.getProtocol().toLowerCase().startsWith("file") || url.getProtocol().toLowerCase().startsWith("http");
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
        if(StringUtils.hasText(input)){
            //input = input.replaceAll("\\{", "%7B").replaceAll("}", "%7D").replaceAll("\\\\", "%5C");
            return HtmlUtils.htmlEscape(input, "UTF-8");
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
            for (String type : ConfigConstants.getprohibit()) {
            if (type.equals(fileType))
                return false;
        }
        return !ObjectUtils.isEmpty(fileType);
    }

}
