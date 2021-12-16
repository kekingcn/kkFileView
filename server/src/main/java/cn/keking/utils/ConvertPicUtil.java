package cn.keking.utils;


import com.lowagie.text.Document;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.pdf.RandomAccessFileOrArray;
import com.lowagie.text.pdf.codec.TiffImage;
import com.sun.media.jai.codec.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;
import java.awt.image.RenderedImage;
import java.awt.image.renderable.ParameterBlock;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ConvertPicUtil {

    private final static Logger logger = LoggerFactory.getLogger(ConvertPicUtil.class);

    /**
     * Tif 转  JPG。
     * @param strInputFile  输入文件的路径和文件名
     * @param strOutputFile 输出文件的路径和文件名
     * @return boolean 是否转换成功
     */
    public static List<String> convertTif2Jpg(String strInputFile, String strOutputFile) {
        List<String> listImageFiles = new ArrayList<>();

        if (strInputFile == null || "".equals(strInputFile.trim())) {
            return null;
        }
        if (!new File(strInputFile).exists()) {
            logger.info("找不到文件【" + strInputFile + "】");
            return null;
        }

        strInputFile = strInputFile.replaceAll("\\\\", "/");
        strOutputFile = strOutputFile.replaceAll("\\\\", "/");

        FileSeekableStream fileSeekStream = null;
        try {
            JPEGEncodeParam jpegEncodeParam = new JPEGEncodeParam();

            TIFFEncodeParam tiffEncodeParam = new TIFFEncodeParam();
            tiffEncodeParam.setCompression(TIFFEncodeParam.COMPRESSION_GROUP4);
            tiffEncodeParam.setLittleEndian(false);

            String strFilePrefix = strInputFile.substring(strInputFile.lastIndexOf("/") + 1, strInputFile.lastIndexOf("."));

            fileSeekStream = new FileSeekableStream(strInputFile);
            ImageDecoder imageDecoder = ImageCodec.createImageDecoder("TIFF", fileSeekStream, null);
            int intTifCount = imageDecoder.getNumPages();
            logger.info("该tif文件共有【" + intTifCount + "】页");

            String strJpgPath = "";
            String strJpgUrl = "";
            if (intTifCount == 1) {
                // 如果是单页tif文件，则转换的目标文件夹就在指定的位置
                strJpgPath = strOutputFile.substring(0, strOutputFile.lastIndexOf("/"));
            } else {
                // 如果是多页tif文件，则在目标文件夹下，按照文件名再创建子目录，将转换后的文件放入此新建的子目录中
                strJpgPath = strOutputFile.substring(0, strOutputFile.lastIndexOf("."));
            }

            // 处理目标文件夹，如果不存在则自动创建
            File fileJpgPath = new File(strJpgPath);
            if (!fileJpgPath.exists()) {
                fileJpgPath.mkdirs();
            }

            // 循环，处理每页tif文件，转换为jpg
            for (int i = 0; i < intTifCount; i++) {
                String strJpg = "";
                if(intTifCount == 1){
                    strJpg = strJpgPath + "/" + strFilePrefix + ".jpg";
                    strJpgUrl = strFilePrefix + ".jpg";
                }else{
                    strJpg = strJpgPath + "/" + i + ".jpg";
                    strJpgUrl = strFilePrefix + "/" + i + ".jpg";
                }

                File fileJpg = new File(strJpg);

                // 如果文件不存在，则生成
                if(!fileJpg.exists()){
                    RenderedImage renderedImage = imageDecoder.decodeAsRenderedImage(i);
                    ParameterBlock pb = new ParameterBlock();
                    pb.addSource(renderedImage);
                    pb.add(fileJpg.toString());
                    pb.add("JPEG");
                    pb.add(jpegEncodeParam);

                    RenderedOp renderedOp = JAI.create("filestore", pb);
                    renderedOp.dispose();

                    logger.info("每页分别保存至： " + fileJpg.getCanonicalPath());
                }else{
                    logger.info("JPG文件已存在： " + fileJpg.getCanonicalPath());
                }

                listImageFiles.add(strJpgUrl);
            }

            return listImageFiles;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (fileSeekStream != null) {
                try {
                    fileSeekStream.close();
                } catch (IOException e) {
                }
                fileSeekStream = null;
            }
        }
    }


    /**
     * 将Jpg图片转换为Pdf文件
     *
     * @param strJpgFile 输入的jpg的路径和文件名
     * @param strPdfFile 输出的pdf的路径和文件名
     * @return
     */
    public static File convertJpg2Pdf(String strJpgFile, String strPdfFile) {
        Document document = new Document();
        // 设置文档页边距
        document.setMargins(0, 0, 0, 0);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(strPdfFile);
            PdfWriter.getInstance(document, fos);
            // 打开文档
            document.open();
            // 获取图片的宽高
            Image image = Image.getInstance(strJpgFile);
            float floatImageHeight = image.getScaledHeight();
            float floatImageWidth = image.getScaledWidth();
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


    /**
     * 将Tif图片转换为Pdf文件（支持多页Tif）
     *
     * @param strTifFile 输入的tif的路径和文件名
     * @param strPdfFile 输出的pdf的路径和文件名
     * @return
     */
    public static File convertTif2Pdf(String strTifFile, String strPdfFile) {
        try {
            RandomAccessFileOrArray rafa = new RandomAccessFileOrArray(strTifFile);

            Document document = new Document();
            // 设置文档页边距
            document.setMargins(0, 0, 0, 0);

            PdfWriter.getInstance(document, new FileOutputStream(strPdfFile));
            document.open();
            int intPages = TiffImage.getNumberOfPages(rafa);
            Image image;
            File filePDF;

            if(intPages == 1){
                String strJpg = strTifFile.substring(0, strTifFile.lastIndexOf(".")) + ".jpg";
                File fileJpg = new File(strJpg);
                List<String> listPic2Jpg = convertTif2Jpg(strTifFile, strJpg);

                if(listPic2Jpg != null && fileJpg.exists()){
                    filePDF = convertJpg2Pdf(strJpg, strPdfFile);
                }

            }else{
                for (int i = 1; i <= intPages; i++) {
                    image = TiffImage.getTiffImage(rafa, i);
                    // 设置页面宽高与图片一致
                    Rectangle pageSize = new Rectangle(image.getScaledWidth(), image.getScaledHeight());
                    document.setPageSize(pageSize);
                    // 图片居中
                    image.setAlignment(Image.ALIGN_CENTER);
                    //新建一页添加图片
                    document.newPage();
                    document.add(image);
                }

                document.close();
            }

            rafa.close();

            filePDF = new File(strPdfFile);

            return filePDF;
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return null;
    }

}