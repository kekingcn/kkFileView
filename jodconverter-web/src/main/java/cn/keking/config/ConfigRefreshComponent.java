package cn.keking.config;

import cn.keking.service.impl.OfficeFilePreviewImpl;
import org.artofsolving.jodconverter.office.OfficeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
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

    public static final String DEFAULT_TXT_TYPE = "txt,html,xml,properties,md,java,py,c,cpp,sql";
    public static final String DEFAULT_MEDIA_TYPE = "mp3,wav,mp4,flv";


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
                Properties sysProperties = System.getProperties();
                String text;
                String media;
                String convertedFileCharset = sysProperties.getProperty("sun.jnu.encoding");
                String[] textArray;
                String[] mediaArray;
                String officePreviewType;
                String configFilePath = OfficeUtils.getCustomizedConfigPath();
                while (true) {
                    FileReader fileReader = new FileReader(configFilePath);
                    BufferedReader bufferedReader = new BufferedReader(fileReader);
                    properties.load(bufferedReader);
                    text = properties.getProperty("simText", DEFAULT_TXT_TYPE);
                    media = properties.getProperty("media", DEFAULT_MEDIA_TYPE);
                    convertedFileCharset = properties.getProperty("converted.file.charset", convertedFileCharset);
                    officePreviewType = properties.getProperty("office.preview.type", OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE);
                    textArray = text.split(",");
                    mediaArray = media.split(",");
                    ConfigConstants.setSimText(textArray);
                    ConfigConstants.setMedia(mediaArray);
                    ConfigConstants.setConvertedFileCharset(convertedFileCharset);
                    ConfigConstants.setOfficePreviewType(officePreviewType);
                    bufferedReader.close();
                    fileReader.close();
                    Thread.sleep(1000L);
                }
            } catch (IOException | InterruptedException e) {
                LOGGER.error("读取配置文件异常：{}", e);
            }
        }
    }
}
