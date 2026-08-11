package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.cache.NotResourceCache;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;
import org.apache.poi.EncryptedDocumentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.ReentrantLock;

/**
 * PDF转JPG服务 - JDK 21 高性能优化版本（使用虚拟线程和结构化并发）
 */
@Component
public class PdfToJpgService {
    private final FileHandlerService fileHandlerService;

    // JDK 21: 使用虚拟线程池
    private ExecutorService virtualThreadExecutor;
    private static final Logger logger = LoggerFactory.getLogger(PdfToJpgService.class);
    private static final String PDF_PASSWORD_MSG = "password";
    private static final String PDF2JPG_IMAGE_FORMAT = ".jpg";
    private static final int BATCH_SIZE = 20;
    private static final int PARALLEL_BATCH_THRESHOLD = 100;
    private final Semaphore concurrentTaskSemaphore;
    private final ConcurrentHashMap<String, ReentrantLock> fileLocks = new ConcurrentHashMap<>();
    // 性能监控
    private final AtomicInteger activeTaskCount = new AtomicInteger(0);
    private final AtomicInteger totalCompletedTasks = new AtomicInteger(0);

    // 存储正在运行的任务
    private final ConcurrentHashMap<String, Future<?>> runningTasks = new ConcurrentHashMap<>();

    // 加密PDF缓存管理（内存缓存，10分钟过期）
    private final ConcurrentHashMap<String, EncryptedPdfCache> encryptedPdfCacheMap = new ConcurrentHashMap<>();

    // JDK 21: 使用虚拟线程调度器
    private final ScheduledExecutorService virtualCacheCleanupScheduler;



    // 加密PDF缓存记录类
    private static class EncryptedPdfCache {
        private final long cacheTime;
        private final int pageCount;
        private final String outputFolder;

        EncryptedPdfCache(int pageCount, String outputFolder) {
            this.cacheTime = System.currentTimeMillis();
            this.pageCount = pageCount;
            this.outputFolder = outputFolder;
        }

        int pageCount() { return pageCount; }
        String outputFolder() { return outputFolder; }

        boolean isExpired(long expireTimeMillis) {
            return System.currentTimeMillis() - cacheTime > expireTimeMillis;
        }
    }

    public PdfToJpgService(FileHandlerService fileHandlerService) {
        // JDK 21: 创建使用虚拟线程的调度器
        this.fileHandlerService = fileHandlerService;
        this.virtualCacheCleanupScheduler = Executors.newSingleThreadScheduledExecutor(
                Thread.ofVirtual().name("pdf-cache-cleaner-", 0).factory()
        );
        // 设置最大并发任务数为50（可根据配置调整）
        int maxConcurrentTasks = ConfigConstants.getPdfMaxThreads();
        this.concurrentTaskSemaphore = new Semaphore(maxConcurrentTasks);
    }

    @PostConstruct
    public void init() {
        refreshImageIoPlugins();

        int maxThreads = ConfigConstants.getPdfMaxThreads();
        // 使用固定大小的虚拟线程池
        this.virtualThreadExecutor = Executors.newFixedThreadPool(maxThreads,
                Thread.ofVirtual().name("pdf-converter-", 0).factory());

        logger.info("PDF转换虚拟线程池初始化完成，最大线程数: {}", maxThreads);

        // 启动缓存清理任务
        scheduleCacheCleanup();
    }

    static void refreshImageIoPlugins() {
        // ImageIO only scans once automatically. If another launcher or Java agent initializes
        // it before Spring Boot installs its application class loader, nested JAR providers such
        // as jbig2-imageio remain invisible until the application class path is scanned again.
        ImageIO.scanForPlugins();
    }

    @PreDestroy
    public void shutdown() {
        logger.info("开始关闭PDF转换服务...");

        try {
            // 1. 取消所有运行中的任务
            cancelAllRunningTasks();

            // 2. 先清理内存缓存（这时执行器还可用）
            clearAllMemoryCaches();

            // 3. 并行关闭调度器和执行器
            List<CompletableFuture<Void>> shutdownFutures = new ArrayList<>();
            shutdownFutures.add(CompletableFuture.runAsync(this::shutdownCacheCleanupScheduler));
            shutdownFutures.add(CompletableFuture.runAsync(this::shutdownVirtualThreadExecutor));

            // 等待所有关闭操作完成（最多30秒）
            CompletableFuture.allOf(shutdownFutures.toArray(new CompletableFuture[0]))
                    .get(30, TimeUnit.SECONDS);

        } catch (TimeoutException e) {
            logger.warn("PDF转换服务关闭超时，强制关闭剩余资源");
            forceShutdown();
        } catch (Exception e) {
            logger.error("关闭PDF转换服务时发生异常", e);
            forceShutdown();
        }

        logger.info("PDF转换服务已完全关闭");
    }

    /**
     * 取消所有运行中的任务
     */
    private void cancelAllRunningTasks() {
        int cancelledCount = 0;
        // 使用keySet的快照，避免并发修改
        Set<String> taskNames = new HashSet<>(runningTasks.keySet());
        for (String taskName : taskNames) {
            Future<?> future = runningTasks.get(taskName);
            if (future != null) {
                try {
                    if (future.cancel(true)) {
                        cancelledCount++;
                        logger.debug("已取消任务: {}", taskName);
                    }
                } catch (Exception e) {
                    logger.warn("取消任务失败: {}", taskName, e);
                }
            }
        }
        runningTasks.clear();
        logger.info("已取消 {} 个运行中的PDF转换任务", cancelledCount);
    }

    /**
     * 关闭缓存清理调度器
     */
    private void shutdownCacheCleanupScheduler() {
        virtualCacheCleanupScheduler.shutdown();
        try {
            if (!virtualCacheCleanupScheduler.awaitTermination(10, TimeUnit.SECONDS)) {
                virtualCacheCleanupScheduler.shutdownNow();
                if (!virtualCacheCleanupScheduler.awaitTermination(5, TimeUnit.SECONDS)) {
                    logger.warn("缓存清理调度器未完全关闭");
                }
            }
        } catch (InterruptedException e) {
            virtualCacheCleanupScheduler.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }

    /**
     * 关闭虚拟线程池
     */
    private void shutdownVirtualThreadExecutor() {
        if (virtualThreadExecutor != null && !virtualThreadExecutor.isShutdown()) {
            virtualThreadExecutor.shutdown();
            try {
                if (!virtualThreadExecutor.awaitTermination(30, TimeUnit.SECONDS)) {
                    virtualThreadExecutor.shutdownNow();
                    if (!virtualThreadExecutor.awaitTermination(10, TimeUnit.SECONDS)) {
                        logger.warn("虚拟线程池未完全关闭");
                    }
                }
            } catch (InterruptedException e) {
                virtualThreadExecutor.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
    }

    /**
     * 强制关闭（当优雅关闭失败时使用）
     */
    private void forceShutdown() {
        // 先清理缓存（同步方式）
        try {
            if (!encryptedPdfCacheMap.isEmpty()) {
                logger.info("强制关闭时同步清理 {} 个缓存", encryptedPdfCacheMap.size());
                for (EncryptedPdfCache cache : encryptedPdfCacheMap.values()) {
                    try {
                        deleteCacheFolder(cache.outputFolder());
                    } catch (Exception e) {
                        logger.warn("清理缓存目录失败: {}", cache.outputFolder(), e);
                    }
                }
                encryptedPdfCacheMap.clear();
            }
        } catch (Exception e) {
            logger.error("强制关闭时清理缓存失败", e);
        }

        // 关闭执行器
        if (virtualCacheCleanupScheduler != null && !virtualCacheCleanupScheduler.isShutdown()) {
            virtualCacheCleanupScheduler.shutdownNow();
        }

        if (virtualThreadExecutor != null && !virtualThreadExecutor.isShutdown()) {
            virtualThreadExecutor.shutdownNow();
        }

        runningTasks.clear();
    }

    /**
     * 清理所有内存缓存
     */
    private void clearAllMemoryCaches() {
        try {
            int cacheCount = encryptedPdfCacheMap.size();
            if (cacheCount > 0) {
                // 检查执行器是否可用
                if (virtualThreadExecutor == null || virtualThreadExecutor.isShutdown() || virtualThreadExecutor.isTerminated()) {
                    logger.warn("执行器已关闭，同步清理缓存目录");
                    for (EncryptedPdfCache cache : encryptedPdfCacheMap.values()) {
                        deleteCacheFolder(cache.outputFolder());
                    }
                    encryptedPdfCacheMap.clear();
                    logger.info("同步清理了 {} 个内存缓存", cacheCount);
                } else {
                    // 并行清理所有缓存目录
                    List<CompletableFuture<Void>> cleanupFutures = new ArrayList<>();
                    for (EncryptedPdfCache cache : encryptedPdfCacheMap.values()) {
                        cleanupFutures.add(CompletableFuture.runAsync(() ->
                                deleteCacheFolder(cache.outputFolder()), virtualThreadExecutor));
                    }

                    CompletableFuture.allOf(cleanupFutures.toArray(new CompletableFuture[0]))
                            .get(60, TimeUnit.SECONDS);

                    encryptedPdfCacheMap.clear();
                    logger.info("清理了 {} 个内存缓存", cacheCount);
                }
            }
        } catch (Exception e) {
            logger.error("清理内存缓存时发生异常", e);
            // 即使出错，也要确保清理缓存条目
            encryptedPdfCacheMap.clear();
        }
    }

    /**
     * 调度缓存清理
     */
    private void scheduleCacheCleanup() {
        // 每5分钟执行一次缓存清理
        virtualCacheCleanupScheduler.scheduleAtFixedRate(() -> {
            try {
                cleanupExpiredEncryptedCache();
                monitorCacheStatistics();
            } catch (Exception e) {
                logger.error("缓存清理任务执行失败", e);
            }
        }, 1, 5, TimeUnit.MINUTES); // 首次延迟1分钟，然后每5分钟执行一次

        logger.info("缓存清理任务已启动（每5分钟执行一次）");
    }


    /**
     * 监控缓存统计信息
     */
    private void monitorCacheStatistics() {
        try {
            int totalCaches = encryptedPdfCacheMap.size();
            if (totalCaches > 0) {
                // 统计过期缓存
                long expireTime = 10 * 60 * 1000L; // 10分钟
                int expiredCount = 0;

                for (EncryptedPdfCache cache : encryptedPdfCacheMap.values()) {
                    if (cache.isExpired(expireTime)) {
                        expiredCount++;
                    }
                }

                if (expiredCount > 0) {
                    logger.debug("缓存监控: 总数={}, 已过期={}, 过期比例={}%",
                            totalCaches, expiredCount, (expiredCount * 100 / totalCaches));
                }
            }
        } catch (Exception e) {
            logger.error("监控缓存统计时发生异常", e);
        }
    }

    /**
     * 优化的缓存清理方法（使用虚拟线程并行处理）
     */
    private void cleanupExpiredEncryptedCache() {
        long startTime = System.currentTimeMillis();

        try {
            long expireTimeMillis = 10 * 60 * 1000L; // 10分钟过期

            // 收集过期的键
            List<String> expiredKeys = new ArrayList<>();

            for (Map.Entry<String, EncryptedPdfCache> entry : encryptedPdfCacheMap.entrySet()) {
                if (entry.getValue().isExpired(expireTimeMillis)) {
                    expiredKeys.add(entry.getKey());
                }
            }

            int cleanedCount = expiredKeys.size();

            if (cleanedCount > 0) {
                logger.info("开始清理 {} 个过期的加密PDF缓存...", cleanedCount);

                // 并行删除文件和清理缓存
                List<CompletableFuture<Void>> deletionFutures = new ArrayList<>();

                for (String cacheKey : expiredKeys) {
                    EncryptedPdfCache cache = encryptedPdfCacheMap.get(cacheKey);
                    if (cache == null) {
                        continue;
                    }

                    CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                        // 原子移除，如果已经被其他线程移除，则返回null
                        EncryptedPdfCache removed = encryptedPdfCacheMap.remove(cacheKey);
                        if (removed != null) {
                            // 删除文件目录
                            deleteCacheFolderConcurrent(removed.outputFolder());
                        }
                    }, virtualThreadExecutor);

                    deletionFutures.add(future);
                }

                // 等待所有删除任务完成
                try {
                    CompletableFuture.allOf(deletionFutures.toArray(new CompletableFuture[0]))
                            .get(5, TimeUnit.MINUTES);
                } catch (TimeoutException e) {
                    logger.warn("缓存清理任务执行超时");
                } catch (Exception e) {
                    logger.error("缓存清理任务失败", e);
                }

                long elapsedTime = System.currentTimeMillis() - startTime;
                logger.info("清理了 {} 个过期的加密PDF缓存，耗时 {}ms", cleanedCount, elapsedTime);
            }

        } catch (Exception e) {
            logger.error("清理加密PDF缓存时发生异常", e);
        }
    }

    /**
     * 并发安全的目录删除
     */
    private void deleteCacheFolderConcurrent(String folderPath) {
        try {
            Path path = Paths.get(folderPath);
            if (Files.exists(path)) {
                // JDK 21: 使用 Files.walk 流式删除
                try (var paths = Files.walk(path)) {
                    paths.sorted(Comparator.reverseOrder())
                            .forEach(p -> {
                                try {
                                    Files.deleteIfExists(p);
                                } catch (IOException e) {
                                    logger.debug("删除文件失败: {}", p, e);
                                }
                            });
                }
                logger.debug("已删除缓存目录: {}", folderPath);
            }
        } catch (Exception e) {
            logger.error("删除缓存目录失败: {}", folderPath, e);
            throw new RuntimeException("删除目录失败: " + folderPath, e);
        }
    }

    /**
     * 目录删除方法
     */
    private void deleteCacheFolder(String folderPath) {
        deleteCacheFolderConcurrent(folderPath);
    }

    /**
     * 添加加密PDF缓存记录
     */
    private void addEncryptedPdfCache(String pdfFilePath, int pageCount, String outputFolder) {
        EncryptedPdfCache cache = new EncryptedPdfCache(pageCount, outputFolder);
        encryptedPdfCacheMap.put(pdfFilePath, cache);

        if (logger.isDebugEnabled()) {
            logger.debug("加密PDF缓存已添加: {}, 页数: {}", pdfFilePath, pageCount);
        }
    }

    /**
     * 获取加密PDF的缓存（如果存在且未过期）
     * @param pdfFilePath PDF文件路径（缓存键）
     * @return 图片URL列表，如果缓存不存在或过期则返回null
     */
    public List<String> getEncryptedPdfCache(String pdfFilePath) {
        Integer cachedPageCount = loadEncryptedPdfCache(pdfFilePath);
        if (cachedPageCount != null) {
            return generateImageUrlsFromCache(pdfFilePath, cachedPageCount);
        }
        return null;
    }


    /**
     * 检查加密PDF缓存是否存在且有效（简版）
     * @param outFilePath PDF输出文件路径
     * @return 如果缓存存在返回true，否则返回false
     */
    public boolean hasEncryptedPdfCacheSimple(String outFilePath) {
        try {
            List<String> cache = getEncryptedPdfCache(outFilePath);
            return cache != null && !cache.isEmpty();
        } catch (Exception e) {
            logger.warn("检查加密PDF缓存失败: {}", outFilePath, e);
            return false;
        }
    }

    /**
     * 加载加密PDF缓存
     */
    private Integer loadEncryptedPdfCache(String pdfFilePath) {
        EncryptedPdfCache cache = encryptedPdfCacheMap.get(pdfFilePath);
        if (cache != null) {
            // 检查是否过期（10分钟）
            if (cache.isExpired(10 * 60 * 1000L)) {
                // 立即移除过期缓存
                encryptedPdfCacheMap.remove(pdfFilePath);
                logger.debug("移除过期缓存: {}", pdfFilePath);
                return null;
            }

            logger.debug("从缓存加载加密PDF: {}, 页数: {}", pdfFilePath, cache.pageCount());
            return cache.pageCount();
        }
        return null;
    }

    /**
     * 从缓存目录生成图片URL列表
     */
    private List<String> generateImageUrlsFromCache(String pdfFilePath, int pageCount) {
        List<String> imageUrls = new ArrayList<>(pageCount);
        for (int i = 0; i < pageCount; i++) {
            String imageUrl = fileHandlerService.getPdf2jpgUrl(pdfFilePath, i);
            imageUrls.add(imageUrl);
        }
        logger.debug("从加密PDF缓存生成 {} 个图片URL: {}", pageCount, pdfFilePath);
        return imageUrls;
    }

    /**
     * PDF转JPG - 高性能主方法
     */
    public List<String> pdf2jpg(String fileNameFilePath, String pdfFilePath,
                                FileAttribute fileAttribute) throws Exception {
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        boolean usePasswordCache = fileAttribute.getUsePasswordCache();
        String filePassword = fileAttribute.getFilePassword();
        boolean semaphoreAcquired = false;
       // 添加信号量控制
        try {
        if (!concurrentTaskSemaphore.tryAcquire()) {
            throw new RejectedExecutionException("系统繁忙，请稍后再试");
        }
        semaphoreAcquired = true;
        // 检查缓存 - 区分加密和非加密文件
        if (!forceUpdatedCache) {
            if (ObjectUtils.isEmpty(filePassword) || usePasswordCache) {
                // 非加密文件：使用原有的缓存机制
                List<String> cacheResult = fileHandlerService.loadPdf2jpgCache(pdfFilePath);
                if (!CollectionUtils.isEmpty(cacheResult)) {
                    return cacheResult;
                }
            } else {
                // 加密文件：使用内存缓存（10分钟有效期）
                Integer cachedPageCount = loadEncryptedPdfCache(pdfFilePath);
                if (cachedPageCount != null) {
                    // 从缓存目录加载图片URL
                    return generateImageUrlsFromCache(pdfFilePath, cachedPageCount);
                }
            }
        }
        ReentrantLock fileLock = fileLocks.computeIfAbsent(pdfFilePath, k -> new ReentrantLock());
        fileLock.lock();

        try {
        // 验证文件存在
        File pdfFile = new File(fileNameFilePath);
        if (!pdfFile.exists()) {
            logger.error("PDF文件不存在: {}", fileNameFilePath);
            return null;
        }

        // 创建输出目录
        int index = pdfFilePath.lastIndexOf(".");
        String folder = pdfFilePath.substring(0, index);
        File path = new File(folder);
        if (!path.exists() && !path.mkdirs()) {
            logger.error("创建转换文件目录失败: {}", folder);
            throw new IOException("无法创建输出目录");
        }

        // 加载PDF文档获取页数
        int pageCount;
        try (PDDocument tempDoc = Loader.loadPDF(pdfFile, filePassword)) {
            pageCount = tempDoc.getNumberOfPages();
        } catch (IOException e) {
            handlePdfLoadException(e, pdfFilePath);
            throw new Exception("PDF文件加载失败", e);
        }

        // 根据页数选择最佳转换策略
        List<String> imageUrls;
        long startTime = System.currentTimeMillis();

        // 根据页数选择不同的转换策略
        if (pageCount <= PARALLEL_BATCH_THRESHOLD) {
            imageUrls = convertOptimizedParallelVirtual(pdfFile, filePassword, pdfFilePath, folder, pageCount);
        } else {
            imageUrls = convertHighPerformanceVirtual(pdfFile, filePassword, pdfFilePath, folder, pageCount);
        }

        long elapsedTime = System.currentTimeMillis() - startTime;

        // 缓存结果 - 区分加密和非加密文件
        if (ObjectUtils.isEmpty(filePassword) ||usePasswordCache) {
            // 非加密文件：使用原有的缓存机制
            fileHandlerService.addPdf2jpgCache(pdfFilePath, pageCount);
        } else{
            // 加密文件：使用内存缓存（10分钟有效期）
            addEncryptedPdfCache(pdfFilePath, pageCount, folder);
        }

        // 性能统计
        logger.info("PDF转换完成: 总页数={}, 耗时={}ms, DPI={}, 文件: {}, 活动任务: {}",
                pageCount, elapsedTime, ConfigConstants.getOptimizedDpi(pageCount),
                pdfFilePath, activeTaskCount.get());

        return imageUrls;
        } finally {
            fileLock.unlock();
            // 可选：清理长时间不用的锁
            cleanupStaleFileLock(pdfFilePath, fileLock);
        }
        } finally {
            if (semaphoreAcquired) {
                concurrentTaskSemaphore.release();
            }
        }
    }

    private void cleanupStaleFileLock(String pdfFilePath, ReentrantLock lock) {
        // 如果锁没有被持有且没有等待线程，则清理
        if (!lock.isLocked() && lock.getQueueLength() == 0) {
            fileLocks.remove(pdfFilePath, lock);
        }
    }

    /**
     * 高性能并行转换 - 使用虚拟线程
     */
    private List<String> convertHighPerformanceVirtual(File pdfFile, String filePassword,
                                                       String pdfFilePath, String folder, int pageCount) {
        List<String> imageUrls = Collections.synchronizedList(new ArrayList<>(pageCount));
        AtomicInteger successCount = new AtomicInteger(0);
        int batchCount = (pageCount + BATCH_SIZE - 1) / BATCH_SIZE;
        int dpi = ConfigConstants.getOptimizedDpi(pageCount);

        logger.info("使用虚拟线程高性能并行转换，总页数: {}, 批次数: {}, DPI: {}, 超时: {}秒",
                pageCount, batchCount, dpi, calculateTimeoutByPageCount(pageCount));

        // 使用虚拟线程执行批次任务
        List<CompletableFuture<List<String>>> batchFutures = new ArrayList<>();

        for (int batchIndex = 0; batchIndex < batchCount; batchIndex++) {
            final int batchStart = batchIndex * BATCH_SIZE;
            final int batchEnd = Math.min(batchStart + BATCH_SIZE, pageCount);
            final int currentBatch = batchIndex;

            CompletableFuture<List<String>> batchFuture = CompletableFuture.supplyAsync(() -> {
                activeTaskCount.incrementAndGet();
                List<String> batchUrls = new ArrayList<>();

                try {
                    // 每个批次独立加载PDF文档
                    try (PDDocument batchDoc = Loader.loadPDF(pdfFile, filePassword)) {
                        batchDoc.setResourceCache(new NotResourceCache());
                        PDFRenderer renderer = new PDFRenderer(batchDoc);
                        renderer.setSubsamplingAllowed(true);

                        for (int pageIndex = batchStart; pageIndex < batchEnd; pageIndex++) {
                            try {
                                String imageFilePath = folder + File.separator + pageIndex + PDF2JPG_IMAGE_FORMAT;
                                BufferedImage image = renderer.renderImageWithDPI(
                                        pageIndex,
                                        dpi,
                                        ImageType.RGB
                                );

                                ImageIOUtil.writeImage(image, imageFilePath, dpi);
                                image.flush();

                                String imageUrl = fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex);
                                batchUrls.add(imageUrl);
                                successCount.incrementAndGet();

                            } catch (Exception e) {
                                logger.error("转换页 {} 失败: {}", pageIndex, e.getMessage());
                                // 添加占位符URL
                                String placeholderUrl = fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex);
                                batchUrls.add(placeholderUrl);
                            }
                        }

                        if (logger.isDebugEnabled()) {
                            logger.debug("批次{}完成: 转换{}页", currentBatch, batchUrls.size());
                        }
                    }
                } catch (Exception e) {
                    logger.error("批次{}处理失败: {}", currentBatch, e.getMessage());
                    // 为整个批次添加占位符URL
                    for (int pageIndex = batchStart; pageIndex < batchEnd; pageIndex++) {
                        batchUrls.add(fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex));
                    }
                } finally {
                    activeTaskCount.decrementAndGet();
                    totalCompletedTasks.incrementAndGet();
                }

                return batchUrls;
            }, virtualThreadExecutor);

            batchFutures.add(batchFuture);
        }

        // 等待所有任务完成
        int timeout = calculateTimeoutByPageCount(pageCount);
        try {
            CompletableFuture<Void> allBatches = CompletableFuture.allOf(
                    batchFutures.toArray(new CompletableFuture[0])
            );
            allBatches.get(timeout, TimeUnit.SECONDS);

            // 收集结果
            for (CompletableFuture<List<String>> future : batchFutures) {
                try {
                    List<String> batchUrls = future.getNow(null);
                    if (batchUrls != null) {
                        imageUrls.addAll(batchUrls);
                    }
                } catch (Exception e) {
                    logger.warn("获取批次结果失败", e);
                }
            }
        } catch (TimeoutException e) {
            logger.warn("PDF转换超时，已转换页数: {}，超时时间: {}秒", successCount.get(),
                    calculateTimeoutByPageCount(pageCount));
        } catch (Exception e) {
            logger.error("批量转换失败", e);
        }

        logger.info("虚拟线程转换完成: 成功转换 {} 页", successCount.get());
        return sortImageUrls(imageUrls);
    }

    /**
     * 优化并行转换 - 使用虚拟线程（针对100页以内的文件）
     */
    private List<String> convertOptimizedParallelVirtual(File pdfFile, String filePassword,
                                                         String pdfFilePath, String folder, int pageCount) {
        int dpi = ConfigConstants.getOptimizedDpi(pageCount);

        logger.info("使用虚拟线程批处理并行转换，总页数: {}, DPI: {}, 超时: {}秒",
                pageCount, dpi, calculateTimeoutByPageCount(pageCount));

        // 按CPU核心数划分批次
        int optimalBatchSize = Math.max(1, Math.min(pageCount / 4, 10)); // 每批最多10页

        logger.debug("推荐批次大小: {}", optimalBatchSize);

        List<String> allImageUrls = Collections.synchronizedList(new ArrayList<>(pageCount));
        AtomicInteger successCount = new AtomicInteger(0);

        // 创建并提交所有批次任务
        List<CompletableFuture<Void>> batchFutures = new ArrayList<>();

        for (int batchStart = 0; batchStart < pageCount; batchStart += optimalBatchSize) {
            final int startPage = batchStart;
            final int endPage = Math.min(batchStart + optimalBatchSize, pageCount);

            CompletableFuture<Void> batchFuture = CompletableFuture.runAsync(() -> {
                activeTaskCount.incrementAndGet();

                try {
                    // 每个批次独立加载PDF
                    try (PDDocument batchDoc = Loader.loadPDF(pdfFile, filePassword)) {
                        batchDoc.setResourceCache(new NotResourceCache());
                        PDFRenderer renderer = new PDFRenderer(batchDoc);
                        renderer.setSubsamplingAllowed(true);

                        for (int pageIndex = startPage; pageIndex < endPage; pageIndex++) {
                            try {
                                String imageFilePath = folder + File.separator + pageIndex + PDF2JPG_IMAGE_FORMAT;
                                BufferedImage image = renderer.renderImageWithDPI(
                                        pageIndex,
                                        dpi,
                                        ImageType.RGB
                                );

                                ImageIOUtil.writeImage(image, imageFilePath, dpi);
                                image.flush();

                                String imageUrl = fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex);
                                synchronized (allImageUrls) {
                                    allImageUrls.add(imageUrl);
                                }

                                successCount.incrementAndGet();

                            } catch (Exception e) {
                                logger.error("转换页 {} 失败: {}", pageIndex, e.getMessage());
                                // 添加占位符
                                String placeholderUrl = fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex);
                                synchronized (allImageUrls) {
                                    allImageUrls.add(placeholderUrl);
                                }
                            }
                        }

                        if (logger.isDebugEnabled()) {
                            logger.debug("批次 {}-{} 完成，转换 {} 页",
                                    startPage, endPage - 1, (endPage - startPage));
                        }
                    }
                } catch (Exception e) {
                    logger.error("批次 {}-{} 加载失败: {}", startPage, endPage - 1, e.getMessage());
                    // 为整个批次添加占位符
                    for (int pageIndex = startPage; pageIndex < endPage; pageIndex++) {
                        synchronized (allImageUrls) {
                            allImageUrls.add(fileHandlerService.getPdf2jpgUrl(pdfFilePath, pageIndex));
                        }
                    }
                } finally {
                    activeTaskCount.decrementAndGet();
                    totalCompletedTasks.incrementAndGet();
                }
            }, virtualThreadExecutor);

            batchFutures.add(batchFuture);
        }

        // 等待所有批次完成
        int timeout = calculateTimeoutByPageCount(pageCount);
        try {
            CompletableFuture<Void> allBatches = CompletableFuture.allOf(
                    batchFutures.toArray(new CompletableFuture[0])
            );
            allBatches.get(timeout, TimeUnit.SECONDS);
        } catch (TimeoutException e) {
            logger.warn("优化转换超时，已转换页数: {}，超时时间: {}秒", successCount.get(),
                    calculateTimeoutByPageCount(pageCount));
        } catch (Exception e) {
            logger.error("优化并行转换异常", e);
        }

        logger.debug("优化并行转换完成: 成功转换 {} 页", successCount.get());
        return sortImageUrls(allImageUrls);
    }

    /**
     * 处理PDF加载异常
     */
    private void handlePdfLoadException(Exception e, String pdfFilePath) throws Exception {
        Throwable[] throwableArray = ExceptionUtils.getThrowables(e);
        for (Throwable throwable : throwableArray) {
            if (throwable instanceof IOException || throwable instanceof EncryptedDocumentException) {
                if (e.getMessage().toLowerCase().contains(PDF_PASSWORD_MSG)) {
                    logger.info("PDF文件需要密码: {}", pdfFilePath);
                    throw new Exception(PDF_PASSWORD_MSG, e);
                }
            }
        }
        logger.error("加载PDF文件异常, pdfFilePath：{}", pdfFilePath, e);
        throw new Exception("PDF文件加载失败", e);
    }

    /**
     * 计算超时时间
     */
    private int calculateTimeoutByPageCount(int pageCount) {
        if (pageCount <= 50) {
            return ConfigConstants.getPdfTimeoutSmall();      // 小文件：90秒
        } else if (pageCount <= 200) {
            return ConfigConstants.getPdfTimeoutMedium();     // 中等文件：180秒
        } else if (pageCount <= 500) {
            return ConfigConstants.getPdfTimeoutLarge();      // 大文件：300秒
        } else {
            return ConfigConstants.getPdfTimeoutXLarge();     // 超大文件：600秒
        }
    }


    /**
     * 按页码排序
     */
    private List<String> sortImageUrls(List<String> imageUrls) {
        List<String> sortedImageUrls = new ArrayList<>(imageUrls);
        sortedImageUrls.sort((url1, url2) -> {
            try {
                String pageStr1 = url1.substring(url1.lastIndexOf('/') + 1, url1.lastIndexOf('.'));
                String pageStr2 = url2.substring(url2.lastIndexOf('/') + 1, url2.lastIndexOf('.'));
                return Integer.compare(Integer.parseInt(pageStr1), Integer.parseInt(pageStr2));
            } catch (Exception e) {
                return 0;
            }
        });
        return sortedImageUrls;
    }


}
