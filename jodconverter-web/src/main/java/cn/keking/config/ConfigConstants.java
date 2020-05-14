package cn.keking.config;

import org.artofsolving.jodconverter.office.OfficeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.Arrays;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.Set;

/**
 * @auther: chenjh
 * @time: 2019/4/10 17:22
 * @description
 */
@Component
public class ConfigConstants {

    private static Boolean CACHE_ENABLED;
    private static String[] SIM_TEXT = {};
    private static String[] MEDIA = {};
    private static String OFFICE_PREVIEW_TYPE;
    private static String FTP_USERNAME;
    private static String FTP_PASSWORD;
    private static String FTP_CONTROL_ENCODING;
    private static String BASE_URL;
    private static String FILE_DIR = OfficeUtils.getHomePath() + File.separator + "file" + File.separator;
    private static CopyOnWriteArraySet<String> TRUST_HOST_SET;
    private static String PDF_DOWNLOAD_DISABLE;

    public static final String DEFAULT_CACHE_ENABLED = "true";
    public static final String DEFAULT_TXT_TYPE = "txt,html,htm,asp,jsp,xml,json,properties,md,gitignore,,java,py,c,cpp,sql,sh,bat,m,bas,prg,cmd";
    public static final String DEFAULT_MEDIA_TYPE = "mp3,wav,mp4,flv";
    public static final String DEFAULT_OFFICE_PREVIEW_TYPE = "image";
    public static final String DEFAULT_FTP_USERNAME = null;
    public static final String DEFAULT_FTP_PASSWORD = null;
    public static final String DEFAULT_FTP_CONTROL_ENCODING = "UTF-8";
    public static final String DEFAULT_BASE_URL = "default";
    public static final String DEFAULT_FILE_DIR_VALUE = "default";
    public static final String DEFAULT_TRUST_HOST = "default";
    public static final String DEFAULT_PDF_DOWNLOAD_DISABLE = "true";

    public static Boolean isCacheEnabled() {
        return CACHE_ENABLED;
    }

    public static void setCacheEnabled(Boolean cacheEnabled) {
        CACHE_ENABLED = cacheEnabled;
    }

    public static String[] getSimText() {
        return SIM_TEXT;
    }

    public static void setSimText(String[] simText) {
        SIM_TEXT = simText;
    }

    public static String[] getMedia() {
        return MEDIA;
    }

    public static void setMedia(String[] Media) {
        ConfigConstants.MEDIA = Media;
    }

    public static String getOfficePreviewType() {
        return OFFICE_PREVIEW_TYPE;
    }

    public static void setOfficePreviewType(String officePreviewType) {
        OFFICE_PREVIEW_TYPE = officePreviewType;
    }

    public static String getFtpUsername() {
        return FTP_USERNAME;
    }

    public static void setFtpUsername(String ftpUsername) {
        FTP_USERNAME = ftpUsername;
    }

    public static String getFtpPassword() {
        return FTP_PASSWORD;
    }

    public static void setFtpPassword(String ftpPassword) {
        FTP_PASSWORD = ftpPassword;
    }

    public static String getFtpControlEncoding() {
        return FTP_CONTROL_ENCODING;
    }

    public static void setFtpControlEncoding(String ftpControlEncoding) {
        FTP_CONTROL_ENCODING = ftpControlEncoding;
    }

    public static String getBaseUrl() {
        return BASE_URL;
    }

    public static void setBaseUrl(String baseUrl) {
        BASE_URL = baseUrl;
    }

    public static String getFileDir() {
        return FILE_DIR;
    }

    @Value("${file.dir:default}")
    public void setFileDir(String fileDir) {
        if (!DEFAULT_FILE_DIR_VALUE.equals(fileDir.toLowerCase())) {
            if (!fileDir.endsWith(File.separator)) {
                fileDir = fileDir + File.separator;
            }
            FILE_DIR = fileDir;
        }
    }

    @Value("${trust.host:default}")
    public void setTrustHostStr(String trustHost) {
        setTrustHost(trustHost);
    }

    public static void setTrustHost(String trustHost) {
        CopyOnWriteArraySet<String> trustHostSet;
        if (DEFAULT_TRUST_HOST.equals(trustHost.toLowerCase())) {
            trustHostSet = new CopyOnWriteArraySet<>();
        } else {
            String[] trustHostArray = trustHost.toLowerCase().split(",");
            trustHostSet = new CopyOnWriteArraySet<>(Arrays.asList(trustHostArray));
            setTrustHostSet(trustHostSet);
        }
        setTrustHostSet(trustHostSet);
    }

    public static Set<String> getTrustHostSet() {
        return TRUST_HOST_SET;
    }

    private static void setTrustHostSet(CopyOnWriteArraySet<String> trustHostSet) {
        ConfigConstants.TRUST_HOST_SET = trustHostSet;
    }


    public static String getPdfDownloadDisable() {
        return PDF_DOWNLOAD_DISABLE;
    }

    public static void setPdfDownloadDisableValue(String pdfDownloadDisable) {
        PDF_DOWNLOAD_DISABLE = pdfDownloadDisable;
    }

    @Value("${pdf.download.disable:true}")
    public void setPdfDownloadDisable(String pdfDownloadDisable) {
        PDF_DOWNLOAD_DISABLE = pdfDownloadDisable;
    }
}
