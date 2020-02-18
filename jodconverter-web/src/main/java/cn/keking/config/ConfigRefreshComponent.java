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
                Boolean cacheEnabled;
                String[] textArray;
                String[] mediaArray;
                String officePreviewType;
                String ftpUsername;
                String ftpPassword;
                String ftpControlEncoding;
                String configFilePath = OfficeUtils.getCustomizedConfigPath();
                String baseUrl;
                String trustHost;
                while (true) {
                    FileReader fileReader = new FileReader(configFilePath);
                    BufferedReader bufferedReader = new BufferedReader(fileReader);
                    properties.load(bufferedReader);
                    OfficeUtils.restorePropertiesFromEnvFormat(properties);
                    cacheEnabled = new Boolean(properties.getProperty("cache.enabled", ConfigConstants.DEFAULT_CACHE_ENABLED));
                    text = properties.getProperty("simText", ConfigConstants.DEFAULT_TXT_TYPE);
                    media = properties.getProperty("media", ConfigConstants.DEFAULT_MEDIA_TYPE);
                    officePreviewType = properties.getProperty("office.preview.type", ConfigConstants.DEFAULT_OFFICE_PREVIEW_TYPE);
                    ftpUsername = properties.getProperty("ftp.username", ConfigConstants.DEFAULT_FTP_USERNAME);
                    ftpPassword = properties.getProperty("ftp.password", ConfigConstants.DEFAULT_FTP_PASSWORD);
                    ftpControlEncoding = properties.getProperty("ftp.control.encoding", ConfigConstants.DEFAULT_FTP_CONTROL_ENCODING);
                    textArray = text.split(",");
                    mediaArray = media.split(",");
                    baseUrl = properties.getProperty("base.url", ConfigConstants.DEFAULT_BASE_URL);
                    trustHost = properties.getProperty("trust.host", ConfigConstants.DEFAULT_TRUST_HOST);
                    ConfigConstants.setCacheEnabled(cacheEnabled);
                    ConfigConstants.setSimText(textArray);
                    ConfigConstants.setMedia(mediaArray);
                    ConfigConstants.setOfficePreviewType(officePreviewType);
                    ConfigConstants.setFtpUsername(ftpUsername);
                    ConfigConstants.setFtpPassword(ftpPassword);
                    ConfigConstants.setFtpControlEncoding(ftpControlEncoding);
                    ConfigConstants.setBaseUrl(baseUrl);
                    ConfigConstants.setTrustHost(trustHost);
                    bufferedReader.close();
                    fileReader.close();
                    Thread.sleep(1000L);
                }
            } catch (IOException | InterruptedException e) {
                LOGGER.error("读取配置文件异常", e);
            }
        }
    }
}
