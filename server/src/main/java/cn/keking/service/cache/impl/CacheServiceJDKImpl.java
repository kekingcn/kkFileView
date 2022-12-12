package cn.keking.service.cache.impl;

import cn.keking.service.cache.CacheService;
import com.googlecode.concurrentlinkedhashmap.ConcurrentLinkedHashMap;
import com.googlecode.concurrentlinkedhashmap.Weighers;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
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
    private Map<String, String> mediaConvertCache;
    private static final int QUEUE_SIZE = 500000;
    private final BlockingQueue<String> blockingQueue = new ArrayBlockingQueue<>(QUEUE_SIZE);

    @PostConstruct
    public void initCache(){
        initPDFCachePool(CacheService.DEFAULT_PDF_CAPACITY);
        initIMGCachePool(CacheService.DEFAULT_IMG_CAPACITY);
        initPdfImagesCachePool(CacheService.DEFAULT_PDFIMG_CAPACITY);
        initMediaConvertCachePool(CacheService.DEFAULT_MEDIACONVERT_CAPACITY);
    }

    @Override
    public void putPDFCache(String key, String value) {
        pdfCache.put(key, value);
    }

    @Override
    public void putImgCache(String key, List<String> value) {
        imgCache.put(key, value);
    }

    @Override
    public Map<String, String> getPDFCache() {
        return pdfCache;
    }

    @Override
    public String getPDFCache(String key) {
        return pdfCache.get(key);
    }

    @Override
    public Map<String, List<String>> getImgCache() {
        return imgCache;
    }

    @Override
    public List<String> getImgCache(String key) {
        if(StringUtils.isEmpty(key)){
            return new ArrayList<>();
        }
        return imgCache.get(key);
    }

    @Override
    public Integer getPdfImageCache(String key) {
        return pdfImagesCache.get(key);
    }

    @Override
    public void putPdfImageCache(String pdfFilePath, int num) {
        pdfImagesCache.put(pdfFilePath, num);
    }

    @Override
    public Map<String, String> getMediaConvertCache() {
        return mediaConvertCache;
    }

    @Override
    public void putMediaConvertCache(String key, String value) {
        mediaConvertCache.put(key, value);
    }

    @Override
    public String getMediaConvertCache(String key) {
        return mediaConvertCache.get(key);
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
    public void initMediaConvertCachePool(Integer capacity) {
        mediaConvertCache = new ConcurrentLinkedHashMap.Builder<String, String>()
                .maximumWeightedCapacity(capacity).weigher(Weighers.singleton())
                .build();
    }

}
