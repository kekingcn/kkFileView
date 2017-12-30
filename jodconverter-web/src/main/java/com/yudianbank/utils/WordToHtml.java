package com.yudianbank.utils;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;
import java.util.function.Function;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;

import com.github.junrar.Archive;
import com.github.junrar.exception.RarException;
import com.github.junrar.rarfile.FileHeader;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.zip.ZipArchiveInputStream;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.apache.poi.xwpf.converter.core.FileImageExtractor;
import org.apache.poi.xwpf.converter.core.FileURIResolver;
import org.apache.poi.xwpf.converter.xhtml.XHTMLConverter;
import org.apache.poi.xwpf.converter.xhtml.XHTMLOptions;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

public class WordToHtml {
    /**          这是2007版本 转html 已测试成功的代码  07和03版要用两种代码转 但因为后面说要用
     * 38      * 2007版本word转换成html
     * 39      * @throws IOException
     * 40
     */

    public static String Word2007ToHtml(InputStream inputStream) throws IOException {
        // 1) 加载word文档生成 XWPFDocument对象
        XWPFDocument document = new XWPFDocument(inputStream);

        // 2) 解析 XHTML配置 (这里设置IURIResolver来设置图片存放的目录)
//        File imageFolderFile = new File("/Users/zuoxiaohui/IdeaProjects/yudian-preview-boot/yudian-preview-boot/src/main/resources/picture/");
        File imageFolderFile = new File("/Users/zuoxiaohui/IdeaProjects/yudian-preview-boot/yudian-preview-boot/src/main/resources/static/");
        XHTMLOptions options = XHTMLOptions.create().URIResolver(new FileURIResolver(imageFolderFile));
        options.setExtractor(new FileImageExtractor(imageFolderFile));
        options.setIgnoreStylesIfUnused(false);
        options.setFragment(true);

        File file = new File("/Users/zuoxiaohui/Test/" + "test.html");
        // 3) 将 XWPFDocument转换成XHTML
        OutputStream out = new FileOutputStream(file);
        XHTMLConverter.getInstance().convert(document, out, options);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        XHTMLConverter.getInstance().convert(document, baos, options);
        String content = baos.toString();
        System.out.println(content);
        baos.close();
        return content;


    }

    public static void main(String[] args) throws IOException, ArchiveException, RarException {
        System.out.println(URLEncoder.encode(" ", "UTF-8"));
        System.out.println(URLDecoder.decode(" http://keking.ufile.ucloud.com.cn/20171230213253_2017%E5%B9%B4%20%E5%BA%A6%E7%BB%A9%E6%95%88%E8%80%83%E6%A0%B8%E8%A1%A8%E5%8F%8A%E8%AF%84%E4%BC%98%E6%8E%A8%E8%8D%90%E8%A1%A8.xlsxUCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=Pbi/J6UcOZcvGwhAwExe3SpxrGo=", "UTF-8"));
    }

}
