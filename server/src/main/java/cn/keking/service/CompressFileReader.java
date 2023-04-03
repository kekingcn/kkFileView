package cn.keking.service;
import cn.keking.config.ConfigConstants;
import cn.keking.model.FileType;
import cn.keking.web.filter.BaseUrlFilter;
import net.sf.sevenzipjbinding.ExtractOperationResult;
import net.sf.sevenzipjbinding.IInArchive;
import net.sf.sevenzipjbinding.SevenZip;
import net.sf.sevenzipjbinding.SevenZipException;
import net.sf.sevenzipjbinding.impl.RandomAccessFileInStream;
import net.sf.sevenzipjbinding.simple.ISimpleInArchive;
import net.sf.sevenzipjbinding.simple.ISimpleInArchiveItem;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Component;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author yudian-it
 * create 2017/11/27
 */
@Component
public class CompressFileReader {
    private final FileHandlerService fileHandlerService;
    public CompressFileReader(FileHandlerService fileHandlerService) {
        this.fileHandlerService = fileHandlerService;
    }
    private static final String fileDir = ConfigConstants.getFileDir();
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

    public String getUtf8String(String str) {
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
                e.printStackTrace();
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
    public static boolean isMessyCode(String strName) {
        //去除字符串中的空格 制表符 换行 回车
        Pattern p = Pattern.compile("\\s*|\t*|\r*|\n*");
        Matcher m = p.matcher(strName);
        String after = m.replaceAll("").replaceAll("\\+", "").replaceAll("#", "").replaceAll("&", "");
        //去除字符串中的标点符号
        String temp = after.replaceAll("\\p{P}", "");
        //处理之后转换成字符数组
        char[] ch = temp.trim().toCharArray();
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
    public String unRar(String paths, String passWord, String fileName) {
        List<String> imgUrls = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String archiveFileName = fileHandlerService.getFileNameFromPath(paths);
        RandomAccessFile randomAccessFile = null;
        IInArchive inArchive = null;
        try {
            randomAccessFile = new RandomAccessFile(paths, "r");
            inArchive = SevenZip.openInArchive(null, new RandomAccessFileInStream(randomAccessFile));
            String folderName = paths.substring(paths.lastIndexOf(File.separator) + 1);
            String extractPath = paths.substring(0, paths.lastIndexOf(folderName));
            ISimpleInArchive   simpleInArchive = inArchive.getSimpleInterface();
            final String[] str = {null};
            for (final ISimpleInArchiveItem item : simpleInArchive.getArchiveItems()) {
                if (!item.isFolder()) {
                    ExtractOperationResult result;
                    result = item.extractSlow(data -> {
                        try {
                             str[0] = getUtf8String(item.getPath());
                            if (isMessyCode(str[0])){
                                str[0] = new String(item.getPath().getBytes(StandardCharsets.ISO_8859_1), "gbk");
                            }
                            str[0] = str[0].replace("\\",  File.separator); //Linux 下路径错误
                            String  str1 = str[0].substring(0, str[0].lastIndexOf(File.separator)+ 1);
                            File file = new File(extractPath, folderName + "_" + File.separator + str1);
                            if (!file.exists()) {
                                file.mkdirs();
                            }
                            OutputStream out = new FileOutputStream( extractPath+ folderName + "_" + File.separator + str[0], true);
                            IOUtils.write(data, out);
                            out.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        return data.length;
                    }, passWord);
                    if (result == ExtractOperationResult.OK) {
                        FileType type = FileType.typeFromUrl(str[0]);
                        if (type.equals(FileType.PICTURE)) {
                          //  System.out.println( baseUrl +folderName + "_" + str[0]);
                            imgUrls.add(baseUrl +folderName + "_/" + str[0].replace("\\", "/"));
                        }
                        fileHandlerService.putImgCache(fileName, imgUrls);
                    } else {
                        return "error";
                    }
                }
            }
            return archiveFileName + "_";
        } catch (Exception e) {
            String Str1 = String.valueOf(e);
            if (Str1.contains("Password")) {
                return "Password";
            }
            return null;
        } finally {
            if (inArchive != null) {
                try {
                    inArchive.close();
                } catch (SevenZipException e) {
                    System.err.println("Error closing archive: " + e);
                }
            }
            if (randomAccessFile != null) {
                try {
                    randomAccessFile.close();
                } catch (IOException e) {
                    System.err.println("Error closing file: " + e);
                }
            }
        }
    }
    /**
     * 读取文件目录树
     */
    public static List<ZtreeNodeVo> getTree(String rootPath) {
        List<ZtreeNodeVo> nodes = new ArrayList<>();
        File file = new File(fileDir+rootPath);
        ZtreeNodeVo node = traverse(file);
        nodes.add(node);
        return nodes;
    }
    private static ZtreeNodeVo traverse(File file) {
        ZtreeNodeVo pathNodeVo = new ZtreeNodeVo();
        pathNodeVo.setId(file.getAbsolutePath().replace(fileDir, "").replace("\\", "/"));
        pathNodeVo.setName(file.getName());
        pathNodeVo.setPid(file.getParent().replace(fileDir, "").replace("\\", "/"));
        if (file.isDirectory()) {
            List<ZtreeNodeVo> subNodeVos = new ArrayList<>();
            File[] subFiles = file.listFiles();
            if (subFiles == null) {
                return pathNodeVo;
            }
            for (File subFile : subFiles) {
                ZtreeNodeVo subNodeVo = traverse(subFile);
                subNodeVos.add(subNodeVo);
            }
            pathNodeVo.setChildren(subNodeVos);
        }
        return pathNodeVo;
    }
}
