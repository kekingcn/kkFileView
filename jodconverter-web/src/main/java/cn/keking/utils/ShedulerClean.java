package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.springframework.stereotype.Component;

@Component
public class ShedulerClean {
    String fileDir = ConfigConstants.getFileDir();

//    @Scheduled(cron = "0 0 23 * * ?")   //每晚23点执行一次
    public void clean(){
        System.out.println("执行一次清空文件夹");
        DeleteFileUtil.deleteDirectory(fileDir);
    }
}
