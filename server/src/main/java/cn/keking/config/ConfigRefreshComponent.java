package cn.keking.config;

import cn.keking.utils.ConfigUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

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

    static class ConfigRefreshThread implements Runnable {
        @Override
        public void run() {
            try {
                Properties properties = new Properties();
                String text;
                String media;
                boolean cacheEnabled;
                String[] textArray;
                String[] mediaArray;
                String officePreviewType;
                String officePreviewSwitchDisabled;
                String ftpUsername;
                String ftpPassword;
                String ftpControlEncoding;
                String configFilePath = ConfigUtils.getCustomizedConfigPath();
                String baseUrl;
                String trustHost;
                String pdfPresentationModeDisable;
                String pdfOpenFileDisable;
                String pdfPrintDisable;
                String pdfDownloadDisable;
                String pdfBookmarkDisable;
                boolean fileUploadDisable;
                String tifPreviewType;
                String prohibit;
                String[] prohibitArray;
                String BeiAn;
                String size;
                String password;
                while (true) {
                    FileReader fileReader = new FileReader(configFilePath);
                    BufferedReader bufferedReader = new BufferedReader(fileReader);
                    properties.load(bufferedReader);
                    ConfigUtils.restorePropertiesFromEnvFormat(properties);
                    cacheEnabled = Boolean.parseBoolean(properties.getProperty("cache.enabled", ConfigConstants.DEFAULT_CACHE_ENABLED));
                    text = properties.getProperty("simText", ConfigConstants.DEFAULT_TXT_TYPE);
                    media = properties.getProperty("media", ConfigConstants.DEFAULT_MEDIA_TYPE);
                    officePreviewType = properties.getProperty("office.preview.type", ConfigConstants.DEFAULT_OFFICE_PREVIEW_TYPE);
                    officePreviewSwitchDisabled = properties.getProperty("office.preview.switch.disabled", ConfigConstants.DEFAULT_OFFICE_PREVIEW_SWITCH_DISABLED);
                    ftpUsername = properties.getProperty("ftp.username", ConfigConstants.DEFAULT_FTP_USERNAME);
                    ftpPassword = properties.getProperty("ftp.password", ConfigConstants.DEFAULT_FTP_PASSWORD);
                    ftpControlEncoding = properties.getProperty("ftp.control.encoding", ConfigConstants.DEFAULT_FTP_CONTROL_ENCODING);
                    textArray = text.split(",");
                    mediaArray = media.split(",");
                    baseUrl = properties.getProperty("base.url", ConfigConstants.DEFAULT_BASE_URL);
                    trustHost = properties.getProperty("trust.host", ConfigConstants.DEFAULT_TRUST_HOST);
                    pdfPresentationModeDisable = properties.getProperty("pdf.presentationMode.disable", ConfigConstants.DEFAULT_PDF_PRESENTATION_MODE_DISABLE);
                    pdfOpenFileDisable = properties.getProperty("pdf.openFile.disable", ConfigConstants.DEFAULT_PDF_OPEN_FILE_DISABLE);
                    pdfPrintDisable = properties.getProperty("pdf.print.disable", ConfigConstants.DEFAULT_PDF_PRINT_DISABLE);
                    pdfDownloadDisable = properties.getProperty("pdf.download.disable", ConfigConstants.DEFAULT_PDF_DOWNLOAD_DISABLE);
                    pdfBookmarkDisable = properties.getProperty("pdf.bookmark.disable", ConfigConstants.DEFAULT_PDF_BOOKMARK_DISABLE);
                    fileUploadDisable = Boolean.parseBoolean(properties.getProperty("file.upload.disable", ConfigConstants.DEFAULT_FILE_UPLOAD_DISABLE));
                    tifPreviewType = properties.getProperty("tif.preview.type", ConfigConstants.DEFAULT_TIF_PREVIEW_TYPE);
                    size = properties.getProperty("spring.servlet.multipart.max-file-size", ConfigConstants.DEFAULT_size_DISABLE);
                    BeiAn = properties.getProperty("BeiAn", ConfigConstants.DEFAULT_BeiAn_DISABLE);
                    prohibit = properties.getProperty("prohibit", ConfigConstants.DEFAULT_prohibit_DISABLE);
                    password = properties.getProperty("sc.password", ConfigConstants.DEFAULT_password_DISABLE);
                    prohibitArray = prohibit.split(",");

                    ConfigConstants.setCacheEnabledValueValue(cacheEnabled);
                    ConfigConstants.setSimTextValue(textArray);
                    ConfigConstants.setMediaValue(mediaArray);
                    ConfigConstants.setOfficePreviewTypeValue(officePreviewType);
                    ConfigConstants.setFtpUsernameValue(ftpUsername);
                    ConfigConstants.setFtpPasswordValue(ftpPassword);
                    ConfigConstants.setFtpControlEncodingValue(ftpControlEncoding);
                    ConfigConstants.setBaseUrlValue(baseUrl);
                    ConfigConstants.setTrustHostValue(trustHost);
                    ConfigConstants.setOfficePreviewSwitchDisabledValue(officePreviewSwitchDisabled);
                    ConfigConstants.setPdfPresentationModeDisableValue(pdfPresentationModeDisable);
                    ConfigConstants.setPdfOpenFileDisableValue(pdfOpenFileDisable);
                    ConfigConstants.setPdfPrintDisableValue(pdfPrintDisable);
                    ConfigConstants.setPdfDownloadDisableValue(pdfDownloadDisable);
                    ConfigConstants.setPdfBookmarkDisableValue(pdfBookmarkDisable);
                    ConfigConstants.setFileUploadDisableValue(fileUploadDisable);
                    ConfigConstants.setTifPreviewTypeValue(tifPreviewType);
                    ConfigConstants.setBeiAnValue(BeiAn);
                    ConfigConstants.setsizeValue(size);
                    ConfigConstants.setprohibitValue(prohibitArray);
                    ConfigConstants.setpasswordValue(password);
                    setWatermarkConfig(properties);
                    bufferedReader.close();
                    fileReader.close();
                    TimeUnit.SECONDS.sleep(1);
                }
            } catch (IOException | InterruptedException e) {
                LOGGER.error("读取配置文件异常", e);
            }
        }

        private void setWatermarkConfig(Properties properties) {
            String watermarkTxt = properties.getProperty("watermark.txt", WatermarkConfigConstants.DEFAULT_WATERMARK_TXT);
            String watermarkXSpace = properties.getProperty("watermark.x.space", WatermarkConfigConstants.DEFAULT_WATERMARK_X_SPACE);
            String watermarkYSpace = properties.getProperty("watermark.y.space", WatermarkConfigConstants.DEFAULT_WATERMARK_Y_SPACE);
            String watermarkFont = properties.getProperty("watermark.font", WatermarkConfigConstants.DEFAULT_WATERMARK_FONT);
            String watermarkFontsize = properties.getProperty("watermark.fontsize", WatermarkConfigConstants.DEFAULT_WATERMARK_FONTSIZE);
            String watermarkColor = properties.getProperty("watermark.color", WatermarkConfigConstants.DEFAULT_WATERMARK_COLOR);
            String watermarkAlpha = properties.getProperty("watermark.alpha", WatermarkConfigConstants.DEFAULT_WATERMARK_ALPHA);
            String watermarkWidth = properties.getProperty("watermark.width", WatermarkConfigConstants.DEFAULT_WATERMARK_WIDTH);
            String watermarkHeight = properties.getProperty("watermark.height", WatermarkConfigConstants.DEFAULT_WATERMARK_HEIGHT);
            String watermarkAngle = properties.getProperty("watermark.angle", WatermarkConfigConstants.DEFAULT_WATERMARK_ANGLE);
            WatermarkConfigConstants.setWatermarkTxtValue(watermarkTxt);
            WatermarkConfigConstants.setWatermarkXSpaceValue(watermarkXSpace);
            WatermarkConfigConstants.setWatermarkYSpaceValue(watermarkYSpace);
            WatermarkConfigConstants.setWatermarkFontValue(watermarkFont);
            WatermarkConfigConstants.setWatermarkFontsizeValue(watermarkFontsize);
            WatermarkConfigConstants.setWatermarkColorValue(watermarkColor);
            WatermarkConfigConstants.setWatermarkAlphaValue(watermarkAlpha);
            WatermarkConfigConstants.setWatermarkWidthValue(watermarkWidth);
            WatermarkConfigConstants.setWatermarkHeightValue(watermarkHeight);
            WatermarkConfigConstants.setWatermarkAngleValue(watermarkAngle);

        }
    }
}
