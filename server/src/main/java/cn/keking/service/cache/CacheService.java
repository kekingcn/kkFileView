package cn.keking.service.cache;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * @author: chenjh
 * @since: 2019/4/2 16:45
 */
public interface CacheService {

    String FILE_PREVIEW_PDF_KEY = "converted-preview-pdf-file";
    String FILE_PREVIEW_IMGS_KEY = "converted-preview-imgs-file";//压缩包内图片文件集合
    String FILE_PREVIEW_PDF_IMGS_KEY = "converted-preview-pdfimgs-file";
    String FILE_PREVIEW_MEDIA_CONVERT_KEY = "converted-preview-media-file";
    String TASK_QUEUE_NAME = "convert-task";

    Integer DEFAULT_PDF_CAPACITY = 500000;
    Integer DEFAULT_IMG_CAPACITY = 500000;
    Integer DEFAULT_PDFIMG_CAPACITY = 500000;
    Integer DEFAULT_MEDIACONVERT_CAPACITY = 500000;

    void initPDFCachePool(Integer capacity);
    void initIMGCachePool(Integer capacity);
    void initPdfImagesCachePool(Integer capacity);
    void initMediaConvertCachePool(Integer capacity);
    void putPDFCache(String key, String value);
    void putImgCache(String key, List<String> value);
    Map<String, String> getPDFCache();
    String getPDFCache(String key);
    Map<String, List<String>> getImgCache();
    List<String> getImgCache(String key);
    Integer getPdfImageCache(String key);
    void putPdfImageCache(String pdfFilePath, int num);
    Map<String, String> getMediaConvertCache();
    void putMediaConvertCache(String key, String value);
    String getMediaConvertCache(String key);
    void cleanCache();
    void addQueueTask(String url);
    String takeQueueTask() throws InterruptedException;

    /**
     * 同一份压缩包在共享目录上只能有一个实例下载、解压、删除源文件并写入缓存。
     * 默认实现不加锁，单机本地盘可以继续用。Redis 实现按文件名互斥。
     */
    default boolean tryCompressLock(String fileName, long wait, TimeUnit unit) {
        return true;
    }

    default void unlockCompress(String fileName) {}
}
