package cn.keking.utils;


import com.lowagie.text.Document;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.sun.media.jai.codec.ImageCodec;
import com.sun.media.jai.codec.ImageEncoder;
import com.sun.media.jai.codec.JPEGEncodeParam;

import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;
import java.io.*;

public class ConvertPicUtil {

    /**
     *  图片 转  JPG。
     *  支持输入格式如下：BMP、GIF、FlashPix、JPEG、PNG、PMN、TIFF、WBMP
     * @param strInputFile 输入文件的路径和文件名
     * @param strOutputFile 输出文件的路径和文件名
     * @return
     */
    public static File convertPic2Jpg(String strInputFile, String strOutputFile) {
        // 读取源图片文件
        RenderedOp roInput = JAI.create("fileload", strInputFile);
        try {
            strOutputFile = strOutputFile.replaceAll("\\\\", "/");
            File fileJpgPath = new File(strOutputFile.substring(0, strOutputFile.lastIndexOf("/")));
            if(!fileJpgPath.exists()){
                fileJpgPath.mkdirs();
            }

            File fileJpg=new File(strOutputFile);
            OutputStream ops = new FileOutputStream(fileJpg);
            // 文件存储输出流
            JPEGEncodeParam param = new JPEGEncodeParam();
            ImageEncoder image = ImageCodec.createImageEncoder("JPEG", ops,
                    param); // 指定输出格式
            // 解析输出流进行输出
            image.encode(roInput);
            // 关闭流
            ops.close();

            return fileJpg;
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 将Jpg图片转换为Pdf文件
     * @param strJpgFile 输入的jpg的路径和文件名
     * @param strPdfFile 输出的pdf的路径和文件名
     * @return
     */
    public static File convertJpg2Pdf(String strJpgFile, String strPdfFile) {
        Document document = new Document();
        // 设置文档页边距
        document.setMargins(0,0,0,0);
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(strPdfFile);
            PdfWriter.getInstance(document, fos);
            // 打开文档
            document.open();
            // 获取图片的宽高
            Image image = Image.getInstance(strJpgFile);
            float floatImageHeight=image.getScaledHeight();
            float floatImageWidth=image.getScaledWidth();
            // 设置页面宽高与图片一致
            Rectangle rectangle = new Rectangle(floatImageWidth, floatImageHeight);
            document.setPageSize(rectangle);
            // 图片居中
            image.setAlignment(Image.ALIGN_CENTER);
            //新建一页添加图片
            document.newPage();
            document.add(image);
        } catch (Exception ioe) {
            ioe.printStackTrace();
            return null;
        } finally {
            //关闭文档
            document.close();
            try {
                fos.flush();
                fos.close();

                File filePDF = new File(strPdfFile);
                return filePDF;
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

        return null;
    }

}

