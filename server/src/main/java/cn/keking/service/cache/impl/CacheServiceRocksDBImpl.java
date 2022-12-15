package cn.keking.service.cache.impl;

import cn.keking.service.cache.CacheService;
import cn.keking.utils.ConfigUtils;
import org.rocksdb.RocksDB;
import org.rocksdb.RocksDBException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * @auther: chenjh
 * @time: 2019/4/22 11:02
 * @description
 */
@ConditionalOnExpression("'${cache.type:default}'.equals('default')")
@Service
public class CacheServiceRocksDBImpl implements CacheService {

    static {
        RocksDB.loadLibrary();
    }

    private static final String DB_PATH = ConfigUtils.getHomePath() + File.separator + "cache";
    private static final int QUEUE_SIZE = 500000;
    private static final Logger LOGGER = LoggerFactory.getLogger(CacheServiceRocksDBImpl.class);
    private final BlockingQueue<String> blockingQueue = new ArrayBlockingQueue<>(QUEUE_SIZE);

    private RocksDB db;

    {
        try {
            db = RocksDB.open(DB_PATH);
            if (db.get(FILE_PREVIEW_PDF_KEY.getBytes()) == null) {
                Map<String, String> initPDFCache = new HashMap<>();
                db.put(FILE_PREVIEW_PDF_KEY.getBytes(), toByteArray(initPDFCache));
            }
            if (db.get(FILE_PREVIEW_IMGS_KEY.getBytes()) == null) {
                Map<String, List<String>> initIMGCache = new HashMap<>();
                db.put(FILE_PREVIEW_IMGS_KEY.getBytes(), toByteArray(initIMGCache));
            }
            if (db.get(FILE_PREVIEW_PDF_IMGS_KEY.getBytes()) == null) {
                Map<String, Integer> initPDFIMGCache = new HashMap<>();
                db.put(FILE_PREVIEW_PDF_IMGS_KEY.getBytes(), toByteArray(initPDFIMGCache));
            }
        } catch (RocksDBException | IOException e) {
            LOGGER.error("Uable to init RocksDB" + e);
        }
    }


    @Override
    public void initPDFCachePool(Integer capacity) {

    }

    @Override
    public void initIMGCachePool(Integer capacity) {

    }

    @Override
    public void initPdfImagesCachePool(Integer capacity) {

    }

    @Override
    public void initMediaConvertCachePool(Integer capacity) {

    }

    @Override
    public void putPDFCache(String key, String value) {
        try {
            Map<String, String> pdfCacheItem = getPDFCache();
            pdfCacheItem.put(key, value);
            db.put(FILE_PREVIEW_PDF_KEY.getBytes(), toByteArray(pdfCacheItem));
        } catch (RocksDBException | IOException e) {
            LOGGER.error("Put into RocksDB Exception" + e);
        }
    }

    @Override
    public void putImgCache(String key, List<String> value) {
        try {
            Map<String, List<String>> imgCacheItem = getImgCache();
            imgCacheItem.put(key, value);
            db.put(FILE_PREVIEW_IMGS_KEY.getBytes(), toByteArray(imgCacheItem));
        } catch (RocksDBException | IOException e) {
            LOGGER.error("Put into RocksDB Exception" + e);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, String> getPDFCache() {
        Map<String, String> result = new HashMap<>();
        try{
            result = (Map<String, String>) toObject(db.get(FILE_PREVIEW_PDF_KEY.getBytes()));
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public String getPDFCache(String key) {
        String result = "";
        try{
            Map<String, String> map = (Map<String, String>) toObject(db.get(FILE_PREVIEW_PDF_KEY.getBytes()));
            result = map.get(key);
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, List<String>> getImgCache() {
        Map<String, List<String>> result = new HashMap<>();
        try{
            result = (Map<String, List<String>>) toObject(db.get(FILE_PREVIEW_IMGS_KEY.getBytes()));
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<String> getImgCache(String key) {
        List<String> result = new ArrayList<>();
        Map<String, List<String>> map;
        try{
            map = (Map<String, List<String>>) toObject(db.get(FILE_PREVIEW_IMGS_KEY.getBytes()));
            result = map.get(key);
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Integer getPdfImageCache(String key) {
        Integer result = 0;
        Map<String, Integer> map;
        try{
            map = (Map<String, Integer>) toObject(db.get(FILE_PREVIEW_PDF_IMGS_KEY.getBytes()));
            result = map.get(key);
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    public void putPdfImageCache(String pdfFilePath, int num) {
        try {
            Map<String, Integer> pdfImageCacheItem = getPdfImageCaches();
            pdfImageCacheItem.put(pdfFilePath, num);
            db.put(FILE_PREVIEW_PDF_IMGS_KEY.getBytes(), toByteArray(pdfImageCacheItem));
        } catch (RocksDBException | IOException e) {
            LOGGER.error("Put into RocksDB Exception" + e);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, String> getMediaConvertCache() {
        Map<String, String> result = new HashMap<>();
        try{
            result = (Map<String, String>) toObject(db.get(FILE_PREVIEW_MEDIA_CONVERT_KEY.getBytes()));
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    public void putMediaConvertCache(String key, String value) {
        try {
            Map<String, String> mediaConvertCacheItem = getMediaConvertCache();
            mediaConvertCacheItem.put(key, value);
            db.put(FILE_PREVIEW_MEDIA_CONVERT_KEY.getBytes(), toByteArray(mediaConvertCacheItem));
        } catch (RocksDBException | IOException e) {
            LOGGER.error("Put into RocksDB Exception" + e);
        }
    }

    @Override
    @SuppressWarnings("unchecked")
    public String getMediaConvertCache(String key) {
        String result = "";
        try{
            Map<String, String> map = (Map<String, String>) toObject(db.get(FILE_PREVIEW_MEDIA_CONVERT_KEY.getBytes()));
            result = map.get(key);
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return result;
    }

    @Override
    public void cleanCache() {
        try {
            cleanPdfCache();
            cleanImgCache();
            cleanPdfImgCache();
        } catch (IOException | RocksDBException e) {
            LOGGER.error("Clean Cache Exception" + e);
        }
    }

    @Override
    public void addQueueTask(String url) {
        blockingQueue.add(url);
    }

    @Override
    public String takeQueueTask() throws InterruptedException {
        return blockingQueue.take();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Integer> getPdfImageCaches() {
        Map<String, Integer> map = new HashMap<>();
        try{
            map = (Map<String, Integer>) toObject(db.get(FILE_PREVIEW_PDF_IMGS_KEY.getBytes()));
        } catch (RocksDBException | IOException | ClassNotFoundException e) {
            LOGGER.error("Get from RocksDB Exception" + e);
        }
        return map;
    }


    private byte[] toByteArray (Object obj) throws IOException {
        byte[] bytes;
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(bos);
        oos.writeObject(obj);
        oos.flush();
        bytes = bos.toByteArray ();
        oos.close();
        bos.close();
        return bytes;
    }

    private Object toObject (byte[] bytes) throws IOException, ClassNotFoundException {
        Object obj;
        ByteArrayInputStream bis = new ByteArrayInputStream (bytes);
        ObjectInputStream ois = new ObjectInputStream (bis);
        obj = ois.readObject();
        ois.close();
        bis.close();
        return obj;
    }

    private void cleanPdfCache() throws IOException, RocksDBException {
        Map<String, String> initPDFCache = new HashMap<>();
        db.put(FILE_PREVIEW_PDF_KEY.getBytes(), toByteArray(initPDFCache));
    }

    private void cleanImgCache() throws IOException, RocksDBException {
        Map<String, List<String>> initIMGCache = new HashMap<>();
        db.put(FILE_PREVIEW_IMGS_KEY.getBytes(), toByteArray(initIMGCache));
    }

    private void cleanPdfImgCache() throws IOException, RocksDBException {
        Map<String, Integer> initPDFIMGCache = new HashMap<>();
        db.put(FILE_PREVIEW_PDF_IMGS_KEY.getBytes(), toByteArray(initPDFIMGCache));
    }
}
