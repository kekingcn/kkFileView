package cn.keking.utils;
import cn.keking.config.ConfigConstants;
import cn.keking.service.ZtreeNodeVo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.LinkOption;
import java.nio.file.DirectoryStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author : Gao
 * create : 2023-04-08
 **/
public class RarUtils {
    private static final Logger logger = LoggerFactory.getLogger(RarUtils.class);

    public static byte[] getUTF8BytesFromGBKString(String gbkStr) {
        int n = gbkStr.length();
        byte[] utfBytes = new byte[3 * n];
        int k = 0;
        for (int i = 0; i < n; i++) {
            int m = gbkStr.charAt(i);
            if (m < 128 && m >= 0) {
                utfBytes[k++] = (byte) m;
                continue;
            }
            utfBytes[k++] = (byte) (0xe0 | (m >> 12));
            utfBytes[k++] = (byte) (0x80 | ((m >> 6) & 0x3f));
            utfBytes[k++] = (byte) (0x80 | (m & 0x3f));
        }
        if (k < utfBytes.length) {
            byte[] tmp = new byte[k];
            System.arraycopy(utfBytes, 0, tmp, 0, k);
            return tmp;
        }
        return utfBytes;
    }

    public static String getUtf8String(String str) {
        if (str != null && str.length() > 0) {
            String needEncodeCode = "ISO-8859-1";
            String neeEncodeCode = "ISO-8859-2";
            String gbkEncodeCode = "GBK";
            try {
                if (Charset.forName(needEncodeCode).newEncoder().canEncode(str)) {
                    str = new String(str.getBytes(needEncodeCode), StandardCharsets.UTF_8);
                }
                if (Charset.forName(neeEncodeCode).newEncoder().canEncode(str)) {
                    str = new String(str.getBytes(neeEncodeCode), StandardCharsets.UTF_8);
                }
                if (Charset.forName(gbkEncodeCode).newEncoder().canEncode(str)) {
                    str = new String(getUTF8BytesFromGBKString(str), StandardCharsets.UTF_8);
                }
            } catch (UnsupportedEncodingException e) {
                logger.error("Failed to convert string encoding: {}", str, e);
            }
        }
        return str;
    }
    /**
     * 判断是否是中日韩文字
     */
    private static boolean isChinese(char c) {
        Character.UnicodeBlock ub = Character.UnicodeBlock.of(c);
        return ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_COMPATIBILITY_IDEOGRAPHS
                || ub == Character.UnicodeBlock.CJK_UNIFIED_IDEOGRAPHS_EXTENSION_A
                || ub == Character.UnicodeBlock.GENERAL_PUNCTUATION
                || ub == Character.UnicodeBlock.CJK_SYMBOLS_AND_PUNCTUATION
                || ub == Character.UnicodeBlock.HALFWIDTH_AND_FULLWIDTH_FORMS;
    }
    public static boolean judge(char c){
        return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z');
    }
    public static String specialSymbols(String str) {
        //去除压缩包文件字符串中特殊符号
        Pattern p = Pattern.compile("\\s|\t|\r|\n|\\+|#|&|=|�|\\p{P}");
  //    Pattern p = Pattern.compile("\\s|\\+|#|&|=|\\p{P}");
        Matcher m = p.matcher(str);
        return m.replaceAll("");
    }
    public static boolean isMessyCode(String strName) {
        //去除字符串中的空格 制表符 换行 回车
        strName = specialSymbols(strName);
        //处理之后转换成字符数组
        char[] ch = strName.trim().toCharArray();
        for (char c : ch) {
            //判断是否是数字或者英文字符
            if (!judge(c)) {
                //判断是否是中日韩文
                if (!isChinese(c)) {
                    //如果不是数字或者英文字符也不是中日韩文则表示是乱码返回true
                    return true;
                }
            }
        }
        //表示不是乱码 返回false
        return false;
    }

    /**
     * 读取文件目录树
     */
    public static List<ZtreeNodeVo> getTree(String rootPath) throws IOException {
        Path fileRoot = Paths.get(ConfigConstants.getFileDir()).toRealPath();
        Path archiveRoot = fileRoot.resolve(rootPath).normalize();
        if (archiveRoot.equals(fileRoot) || !archiveRoot.startsWith(fileRoot)) {
            throw new SecurityException("Only an individual archive directory may be listed");
        }
        archiveRoot = archiveRoot.toRealPath();
        if (archiveRoot.equals(fileRoot) || !archiveRoot.startsWith(fileRoot) || !Files.isDirectory(archiveRoot)) {
            throw new SecurityException("Archive directory escapes file storage");
        }
        return List.of(traverse(archiveRoot, fileRoot, archiveRoot));
    }

    private static ZtreeNodeVo traverse(Path file, Path fileRoot, Path archiveRoot) throws IOException {
        ZtreeNodeVo node = new ZtreeNodeVo();
        node.setId(fileRoot.relativize(file).toString().replace('\\', '/'));
        node.setName(file.getFileName().toString());
        node.setPid(file.equals(archiveRoot) ? "" : fileRoot.relativize(file.getParent()).toString().replace('\\', '/'));
        if (Files.isDirectory(file, LinkOption.NOFOLLOW_LINKS)) {
            List<ZtreeNodeVo> children = new ArrayList<>();
            try (DirectoryStream<Path> entries = Files.newDirectoryStream(file)) {
                for (Path child : entries) {
                    // Do not follow links into other cached documents or outside storage.
                    if (Files.isSymbolicLink(child)) {
                        continue;
                    }
                    if (Files.isRegularFile(child, LinkOption.NOFOLLOW_LINKS)
                            || Files.isDirectory(child, LinkOption.NOFOLLOW_LINKS)) {
                        children.add(traverse(child, fileRoot, archiveRoot));
                    }
                }
            }
            node.setChildren(children);
        }
        return node;
    }
}
