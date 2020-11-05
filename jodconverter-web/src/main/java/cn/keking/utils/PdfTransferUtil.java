package cn.keking.utils;

import lombok.extern.slf4j.Slf4j;
import org.icepdf.core.pobjects.Document;
import org.icepdf.core.pobjects.Page;
import org.icepdf.core.util.GraphicsRenderingHints;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * @author lr
 *  
 */
@Slf4j
public class PdfTransferUtil {

    //*********************************pdf to image **********************************************************

    /**
     * 将指定pdf字节数组转换为指定格式图片二进制数组
     *
     * @param pdfBytes  PDF字节数组
     * @param imageType 转换图片格式  默认png
     * @param zoom      缩略图显示倍数，1表示不缩放，0.3则缩小到30%
     * @return List<byte [ ]>
     * @throws Exception
     */
    public List<byte[]> pdf2Image(byte[] pdfBytes, String imageType, float zoom) throws Exception {
        Document document = new Document();
        document.setByteArray(pdfBytes, 0, pdfBytes.length, null);
        return pageExtraction(document, imageType, 0f, zoom);
    }

    /**
     * 将指定pdf输入流转换为指定格式图片二进制数组
     *
     * @param inputPDF  PDF二进制流
     * @param imageType 转换图片格式 默认png
     * @param zoom      缩略图显示倍数，1表示不缩放，0.3则缩小到30%
     * @return List<byte [ ]>
     * @throws Exception
     */
    public List<byte[]> pdf2Image(InputStream inputPDF, String imageType, float zoom) throws Exception {
        Document document = new Document();
        document.setInputStream(inputPDF, null);
        return pageExtraction(document, imageType, 0f, zoom);
    }

    /**
     * 将指定pdf文件转换为指定格式图片二进制数组
     *
     * @param pdfPath   原文件路径，例如d:/test.pdf
     * @param imageType 转换图片格式 默认png
     * @param zoom      缩略图显示倍数，1表示不缩放，0.3则缩小到30%
     * @return List<byte [ ]>
     * @throws Exception
     */
    public List<byte[]> pdf2Image(String pdfPath, String imageType, float zoom) throws Exception {
        Document document = new Document();
        document.setFile(pdfPath);
        return pageExtraction(document, imageType, 0f, zoom);
    }
    //*********************************pdf to image **********************************************************

    private List<byte[]> pageExtraction(Document document, String imageType, float rotation, float zoom) {
        // setup two threads to handle image extraction.
        // 线程为最大线程的一半
        ExecutorService executorService = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());
        try {
            // create a list of callables.
            int pages = document.getNumberOfPages();
            List<byte[]> result = new ArrayList<byte[]>(pages);
            List<Callable<byte[]>> callables = new ArrayList<Callable<byte[]>>(pages);
            for (int i = 0; i < pages; i++) {
                callables.add(new CapturePage(document, i, imageType, rotation, zoom));
            }
            List<Future<byte[]>> listFuture = executorService.invokeAll(callables);
            executorService.submit(new DocumentCloser(document)).get();
            for (Future<byte[]> future : listFuture) {
                result.add(future.get());
            }
            return result;
        } catch (Exception ex) {
            log.error(" pdf 转换图片错误  Error handling PDF document " + ex);
        } finally {
            executorService.shutdown();
        }
        return null;
    }

    public class CapturePage implements Callable<byte[]> {
        private Document document;
        private int pageNumber;
        private String imageType;
        private float rotation;
        private float zoom;

        private CapturePage(Document document, int pageNumber, String imageType, float rotation, float zoom) {
            this.document = document;
            this.pageNumber = pageNumber;
            this.imageType = imageType;
            this.rotation = rotation;
            this.zoom = zoom;
        }

        @Override
        public byte[] call() throws Exception {
            BufferedImage image = (BufferedImage) document.getPageImage(pageNumber, GraphicsRenderingHints.SCREEN, Page.BOUNDARY_CROPBOX, rotation, zoom);
            ByteArrayOutputStream bs = new ByteArrayOutputStream();
            ImageOutputStream imOut = ImageIO.createImageOutputStream(bs);
            ImageIO.write(image, imageType, imOut);
            image.flush();
            return bs.toByteArray();
        }
    }

    /**
     * Disposes the document.
     */
    public class DocumentCloser implements Callable<Void> {
        private Document document;

        private DocumentCloser(Document document) {
            this.document = document;
        }

        @Override
        public Void call() {
            if (document != null) {
                document.dispose();
                log.info("Document disposed");
            }
            return null;
        }
    }

}