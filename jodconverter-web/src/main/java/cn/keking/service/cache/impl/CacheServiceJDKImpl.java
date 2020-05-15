package cn.keking.service.cache.impl;

import cn.keking.service.cache.CacheService;
import com.googlecode.concurrentlinkedhashmap.ConcurrentLinkedHashMap;
import com.googlecode.concurrentlinkedhashmap.Weighers;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * @auther: chenjh
 * @time: 2019/4/2 17:21
 * @description
 */
@Service
@ConditionalOnExpression("'${cache.type:default}'.equals('jdk')")
public class CacheServiceJDKImpl implements CacheService {

    private Map<String, String> pdfCache;

    private Map<String, List<String>> imgCache;

    private Map<String, Integer> pdfImagesCache;

    private static final int QUEUE_SIZE = 500000;

    private final BlockingQueue<String> blockingQueue = new ArrayBlockingQueue<>(QUEUE_SIZE);

    @Override
    public void initPDFCachePool(Integer capacity) {
        pdfCache = new ConcurrentLinkedHashMap.Builder<String, String>()
                .maximumWeightedCapacity(capacity).weigher(Weighers.singleton())
                .build();
    }

    @Override
    public void initIMGCachePool(Integer capacity) {
        imgCache = new ConcurrentLinkedHashMap.Builder<String, List<String>>()
                .maximumWeightedCapacity(capacity).weigher(Weighers.singleton())
                .build();
    }

    @Override
    public void initPdfImagesCachePool(Integer capacity) {
        pdfImagesCache = new ConcurrentLinkedHashMap.Builder<String, Integer>()
                .maximumWeightedCapacity(capacity).weigher(Weighers.singleton())
                .build();
    }

    @Override
    public void putPDFCache(String key, String value) {
        if (pdfCache == null) {
            initPDFCachePool(CacheService.DEFAULT_PDF_CAPACITY);
        }
        pdfCache.put(key, value);
    }

    @Override
    public void putImgCache(String key, List<String> value) {
        if (imgCache == null) {
            initIMGCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        }
        imgCache.put(key, value);
    }

    @Override
    public Map<String, String> getPDFCache() {
        if (pdfCache == null) {
            initPDFCachePool(CacheService.DEFAULT_PDF_CAPACITY);
        }
        return pdfCache;
    }

    @Override
    public String getPDFCache(String key) {
        if (pdfCache == null) {
            initPDFCachePool(CacheService.DEFAULT_PDF_CAPACITY);
        }
        return pdfCache.get(key);
    }

    @Override
    public Map<String, List<String>> getImgCache() {
        if (imgCache == null) {
            initPDFCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        }
        return imgCache;
    }

    @Override
    public List<String> getImgCache(String key) {
        if (imgCache == null) {
            initPDFCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        }
        return imgCache.get(key);
    }

    @Override
    public Integer getPdfImageCache(String key) {
        if (pdfImagesCache == null) {
            initPdfImagesCachePool(CacheService.DEFAULT_PDFIMG_CAPACITY);
        }
        return pdfImagesCache.get(key);
    }

    @Override
    public void putPdfImageCache(String pdfFilePath, int num) {
        if (pdfImagesCache == null) {
            initPdfImagesCachePool(CacheService.DEFAULT_PDFIMG_CAPACITY);
        }
        pdfImagesCache.put(pdfFilePath, num);
    }

    @Override
    public void cleanCache() {
        initPDFCachePool(CacheService.DEFAULT_PDF_CAPACITY);
        initIMGCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        initPdfImagesCachePool(CacheService.DEFAULT_PDFIMG_CAPACITY);
    }

    @Override
    public void addQueueTask(String url) {
        blockingQueue.add(url);
    }

    @Override
    public String takeQueueTask() throws InterruptedException {
        return blockingQueue.take();
    }
}
