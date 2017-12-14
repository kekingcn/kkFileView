package com.yudianbank.utils;

import java.io.*;
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
        File file = new File("C:\\Users\\yudian-it\\Downloads\\Downloads.zip");
        System.out.println("Objects.equals(new Integer(1000), new Integer(1000)) :" + Objects.equals(new Integer(1000), new Integer(1000)));
        System.out.println(Integer.valueOf("-129") == Integer.valueOf("-129"));
    }

}
