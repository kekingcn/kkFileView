package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import cn.keking.utils.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;

import javax.annotation.PostConstruct;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by kl on 2018/1/19.
 * Content :消费队列中的转换文件
 */
@Service
public class FileConverQueueTask {

    Logger logger= LoggerFactory.getLogger(getClass());
    public static final String queueTaskName="FileConverQueueTask";

    @Autowired
    FilePreviewFactory previewFactory;

    @Autowired
    CacheService cacheService;

    @Autowired
    FileUtils fileUtils;

    @PostConstruct
    public void startTask(){
        ExecutorService executorService = Executors.newFixedThreadPool(3);
        executorService.submit(new ConverTask(previewFactory, cacheService, fileUtils));
        logger.info("队列处理文件转换任务启动完成 ");
    }

    class  ConverTask implements Runnable{

        FilePreviewFactory previewFactory;

        CacheService cacheService;

        FileUtils fileUtils;

        public ConverTask(FilePreviewFactory previewFactory, CacheService cacheService, FileUtils fileUtils) {
            this.previewFactory = previewFactory;
            this.cacheService = cacheService;
            this.fileUtils=fileUtils;
        }

        @Override
        public void run() {
            while (true) {
                try {
                    String url = cacheService.takeQueueTask();
                    if(url != null){
                        FileAttribute fileAttribute = fileUtils.getFileAttribute(url);
                        logger.info("正在处理转换任务，文件名称【{}】",fileAttribute.getName());
                        FileType fileType=fileAttribute.getType();
                        if(fileType.equals(FileType.compress) || fileType.equals(FileType.office)){
                            Model model = new ExtendedModelMap();
                            model.asMap().put("BaseUrl", "");
                            FilePreview filePreview=previewFactory.get(fileAttribute);
                            filePreview.filePreviewHandle(url, model, fileAttribute);
                        }
                    }
                } catch (Exception e) {
                    try {
                        Thread.sleep(1000*10);
                    }catch (Exception ex){
                        //Ignored
                    }
                    e.printStackTrace();
                }
            }
        }
    }

}
