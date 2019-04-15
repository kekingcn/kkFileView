package cn.keking.config;

import cn.keking.utils.HomePathUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

/**
 * @auther: chenjh
 * @time: 2019/4/10 16:16
 * @description 每隔1s读取并更新一次配置文件
 */
@Component
public class ConfigRefreshComponent {

    private static final Logger LOGGER = LoggerFactory.getLogger(ConfigRefreshComponent.class);

    @PostConstruct
    void refresh() {
        Thread configRefreshThread = new Thread(new ConfigRefreshThread());
        configRefreshThread.start();
    }

    class ConfigRefreshThread implements Runnable {
        @Override
        public void run() {
            try {
                Properties properties = new Properties();
                String text;
                String media;
                String convertedFileCharset;
                String[] textArray ;
                String[] mediaArray;
                String homePath = HomePathUtils.getHomePath();
                String separator = java.io.File.separator;
                String configFilePath = homePath + separator + "conf" + separator + "application.properties";
                while (true) {
                    BufferedReader bufferedReader = new BufferedReader(new FileReader(configFilePath));
                    properties.load(bufferedReader);
                    text = properties.get("simText") == null ? "" : properties.get("simText").toString();
                    media = properties.get("media") == null ? "" : properties.get("media").toString();
                    convertedFileCharset = properties.get("converted.file.charset") == null ? "" : properties.get("converted.file.charset").toString();
                    textArray = text.split(",");
                    mediaArray = media.split(",");
                    ConfigConstants.setSimText(textArray);
                    ConfigConstants.setMedia(mediaArray);
                    ConfigConstants.setConvertedFileCharset(convertedFileCharset);
                    Thread.sleep(1000L);
                }
            } catch (IOException | InterruptedException e) {
                LOGGER.error("读取配置文件异常：{}", e);
            }
        }
    }
}
