package cn.keking.service;

import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.ExtendedModelMap;

import javax.annotation.PostConstruct;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Created by kl on 2018/1/19.
 * Content :消费队列中的转换文件
 */
@Service
public class FileConvertQueueTask {

    private final Logger logger = LoggerFactory.getLogger(getClass());
    private final FilePreviewFactory previewFactory;
    private final CacheService cacheService;
    private final FileHandlerService fileHandlerService;
    private ExecutorService threadPool;

    // 使用 @Value 注解来注入配置的线程数量
    @Value("${file.convert.thread.count:5}") // 默认值为 5
    private int threadPoolSize;

    public FileConvertQueueTask(FilePreviewFactory previewFactory, CacheService cacheService, FileHandlerService fileHandlerService) {
        this.previewFactory = previewFactory;
        this.cacheService = cacheService;
        this.fileHandlerService = fileHandlerService;
    }

    @PostConstruct
    public void startTask() {
        // 根据配置的线程数量初始化线程池
        this.threadPool = Executors.newFixedThreadPool(threadPoolSize);
        for (int i = 0; i < threadPoolSize; i++) {
            threadPool.submit(new ConvertTask(previewFactory, cacheService, fileHandlerService));
        }
        logger.info("队列处理文件转换任务启动完成，线程数: {}", threadPoolSize);
    }

    // 增加一个方法用于关闭线程池（可选）
    public void shutdown() {
        if (threadPool != null) {
            threadPool.shutdown();
            try {
                if (!threadPool.awaitTermination(60, TimeUnit.SECONDS)) {
                    threadPool.shutdownNow();
                }
            } catch (InterruptedException e) {
                threadPool.shutdownNow();
            }
        }
    }

    static class ConvertTask implements Runnable {

        private final Logger logger = LoggerFactory.getLogger(ConvertTask.class);
        private final FilePreviewFactory previewFactory;
        private final CacheService cacheService;
        private final FileHandlerService fileHandlerService;

        public ConvertTask(FilePreviewFactory previewFactory,
                           CacheService cacheService,
                           FileHandlerService fileHandlerService) {
            this.previewFactory = previewFactory;
            this.cacheService = cacheService;
            this.fileHandlerService = fileHandlerService;
        }

        @Override
        public void run() {
            while (true) {
                String url = null;
                try {
                    url = cacheService.takeQueueTask();
                    if (url != null) {
                        FileAttribute fileAttribute = fileHandlerService.getFileAttribute(url, null);
                        FileType fileType = fileAttribute.getType();
                        logger.info("正在处理预览转换任务，url：{}，预览类型：{}", url, fileType);
                        if (isNeedConvert(fileType)) {
                            FilePreview filePreview = previewFactory.get(fileAttribute);
                            filePreview.filePreviewHandle(url, new ExtendedModelMap(), fileAttribute);
                            logger.info("处理预览转换任务完成，url：{}，预览类型：{}", url, fileType);
                        } else {
                            logger.info("预览类型无需处理，url：{}，预览类型：{}", url, fileType);
                        }
                    }
                } catch (Exception e) {
                    try {
                        TimeUnit.SECONDS.sleep(10);
                    } catch (Exception ex) {
                        Thread.currentThread().interrupt();
                        ex.printStackTrace();
                    }
                    logger.info("处理预览转换任务异常，url：{}", url, e);
                }
            }
        }

        public boolean isNeedConvert(FileType fileType) {
            return fileType.equals(FileType.COMPRESS) || fileType.equals(FileType.OFFICE) || fileType.equals(FileType.CAD);

        }
    }

}
