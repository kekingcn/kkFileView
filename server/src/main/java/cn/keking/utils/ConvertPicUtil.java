package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.web.filter.BaseUrlFilter;
import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.io.FileChannelRandomAccessSource;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.RandomAccessFileOrArray;
import com.itextpdf.text.pdf.codec.TiffImage;
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
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;

public class ConvertPicUtil {

    private static final int FIT_WIDTH = 500;
    private static final int FIT_HEIGHT = 900;
    private final static Logger logger = LoggerFactory.getLogger(ConvertPicUtil.class);
    private final static String fileDir = ConfigConstants.getFileDir();
    /**
     * Tif 转  JPG。
     *
     * @param strInputFile  输入文件的路径和文件名
     * @param strOutputFile 输出文件的路径和文件名
     * @return boolean 是否转换成功
     */
    public static List<String> convertTif2Jpg(String strInputFile, String strOutputFile, boolean forceUpdatedCache) throws Exception {
        List<String> listImageFiles = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        if (!new File(strInputFile).exists()) {
            logger.info("找不到文件【" + strInputFile + "】");
            return null;
        }
        strOutputFile = strOutputFile.replaceAll(".jpg", "");
        FileSeekableStream fileSeekStream = null;
        try {
            JPEGEncodeParam jpegEncodeParam = new JPEGEncodeParam();
            TIFFEncodeParam tiffEncodeParam = new TIFFEncodeParam();
            tiffEncodeParam.setCompression(TIFFEncodeParam.COMPRESSION_GROUP4);
            tiffEncodeParam.setLittleEndian(false);
            fileSeekStream = new FileSeekableStream(strInputFile);
            ImageDecoder imageDecoder = ImageCodec.createImageDecoder("TIFF", fileSeekStream, null);
            int intTifCount = imageDecoder.getNumPages();
            // logger.info("该tif文件共有【" + intTifCount + "】页");
            // 处理目标文件夹，如果不存在则自动创建
            File fileJpgPath = new File(strOutputFile);
            if (!fileJpgPath.exists() && !fileJpgPath.mkdirs()) {
                logger.error("{} 创建失败", strOutputFile);
            }
            // 循环，处理每页tif文件，转换为jpg
            for (int i = 0; i < intTifCount; i++) {
                String strJpg= strOutputFile + "/" + i + ".jpg";
                File fileJpg = new File(strJpg);
                // 如果文件不存在，则生成
                if (forceUpdatedCache|| !fileJpg.exists()) {
                    RenderedImage renderedImage = imageDecoder.decodeAsRenderedImage(i);
                    ParameterBlock pb = new ParameterBlock();
                    pb.addSource(renderedImage);
                    pb.add(fileJpg.toString());
                    pb.add("JPEG");
                    pb.add(jpegEncodeParam);
                    RenderedOp renderedOp = JAI.create("filestore", pb);
                    renderedOp.dispose();
                    // logger.info("每页分别保存至： " + fileJpg.getCanonicalPath());
                }
                strJpg = baseUrl+strJpg.replace(fileDir, "");
                listImageFiles.add(strJpg);
            }
        } catch (IOException e) {
            if (!e.getMessage().contains("Bad endianness tag (not 0x4949 or 0x4d4d)") ) {
                logger.error("TIF转JPG异常，文件路径：" + strInputFile, e);
            }
            throw new Exception(e);
        } finally {
            if (fileSeekStream != null) {
                fileSeekStream.close();
            }
        }
        return listImageFiles;
    }

    /**
     * 将Jpg图片转换为Pdf文件
     *
     * @param strJpgFile 输入的jpg的路径和文件名
     * @param strPdfFile 输出的pdf的路径和文件名
     */
    public static String convertJpg2Pdf(String strJpgFile, String strPdfFile) throws Exception {
        Document document = new Document();
        RandomAccessFileOrArray rafa = null;
        FileOutputStream outputStream = null;
        try {
            RandomAccessFile aFile = new RandomAccessFile(strJpgFile, "r");
            FileChannel inChannel = aFile.getChannel();
            FileChannelRandomAccessSource fcra =  new FileChannelRandomAccessSource(inChannel);
            rafa = new RandomAccessFileOrArray(fcra);
            int pages = TiffImage.getNumberOfPages(rafa);
            outputStream = new FileOutputStream(strPdfFile);
            PdfWriter.getInstance(document, outputStream);
            document.open();
            Image image;
            for (int i = 1; i <= pages; i++) {
             image = TiffImage.getTiffImage(rafa, i);
             image.scaleToFit(FIT_WIDTH, FIT_HEIGHT);
             document.add(image);
            }
        } catch (IOException e) {
            if (!e.getMessage().contains("Bad endianness tag (not 0x4949 or 0x4d4d)") ) {
                logger.error("TIF转JPG异常，文件路径：" + strPdfFile, e);
            }
            throw new Exception(e);
        } finally {
            if (document != null) {
                document.close();
            }
            if (rafa != null) {
                rafa.close();
            }
            if (outputStream != null) {
                outputStream.close();
            }
        }
        return strPdfFile;
    }
}