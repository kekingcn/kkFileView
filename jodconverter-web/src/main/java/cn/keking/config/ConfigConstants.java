package cn.keking.config;

import org.artofsolving.jodconverter.office.OfficeUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.File;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * @auther: chenjh
 * @time: 2019/4/10 17:22
 * @description
 */
@Component
public class ConfigConstants {

    private static Boolean cacheEnabled;
    private static String[] simText = {};
    private static String[] media = {};
    private static String officePreviewType;
    private static String ftpUsername;
    private static String ftpPassword;
    private static String ftpControlEncoding;
    private static String fileDir = OfficeUtils.getHomePath() + File.separator + "file" + File.separator;
    private static String baseUrl;
    private static String trustHost;
    private static Set<String> trustHostSet;

    public static final String DEFAULT_CACHE_ENABLED = "true";
    public static final String DEFAULT_TXT_TYPE = "txt,html,htm,asp,jsp,xml,json,properties,md,gitignore,,java,py,c,cpp,sql,sh,bat,m,bas,prg,cmd";
    public static final String DEFAULT_MEDIA_TYPE = "mp3,wav,mp4,flv";
    public static final String DEFAULT_FILE_DIR_VALUE = "default";
    public static final String DEFAULT_FTP_USERNAME = null;
    public static final String DEFAULT_FTP_PASSWORD = null;
    public static final String DEFAULT_FTP_CONTROL_ENCODING = "UTF-8";
    public static final String DEFAULT_OFFICE_PREVIEW_TYPE = "image";
    public static final String DEFAULT_BASE_URL = "default";
    public static final String DEFAULT_TRUST_HOST = "default";

    public static Boolean isCacheEnabled() {
        return cacheEnabled;
    }

    public static void setCacheEnabled(Boolean cacheEnabled) {
        ConfigConstants.cacheEnabled = cacheEnabled;
    }

    public static String[] getSimText() {
        return simText;
    }

    public static void setSimText(String[] simText) {
        ConfigConstants.simText = simText;
    }

    public static String[] getMedia() {
        return media;
    }

    public static void setMedia(String[] media) {
        ConfigConstants.media = media;
    }

    public static String getOfficePreviewType() {
        return officePreviewType;
    }

    public static void setOfficePreviewType(String officePreviewType) {
        ConfigConstants.officePreviewType = officePreviewType;
    }

    public static String getFtpUsername() {
        return ftpUsername;
    }

    public static void setFtpUsername(String ftpUsername) {
        ConfigConstants.ftpUsername = ftpUsername;
    }

    public static String getFtpPassword() {
        return ftpPassword;
    }

    public static String getFtpControlEncoding() {
        return ftpControlEncoding;
    }

    public static void setFtpControlEncoding(String ftpControlEncoding) {
        ConfigConstants.ftpControlEncoding = ftpControlEncoding;
    }

    public static void setFtpPassword(String ftpPassword) {
        ConfigConstants.ftpPassword = ftpPassword;
    }

    public static String getFileDir() {
        return fileDir;
    }

    public static String getBaseUrl() {
        return baseUrl;
    }

    public static void setBaseUrl(String baseUrl) {
        ConfigConstants.baseUrl = baseUrl;
    }

    @Value("${file.dir:default}")
    public void setFileDir(String fileDir) {
        if (!DEFAULT_FILE_DIR_VALUE.equals(fileDir.toLowerCase())) {
            if (!fileDir.endsWith(File.separator)) {
                fileDir = fileDir + File.separator;
            }
            ConfigConstants.fileDir = fileDir;
        }
    }

    static String getTrustHost() {
        return trustHost;
    }

    @Value("${trust.host:default}")
    static void setTrustHost(String trustHost) {
        ConfigConstants.trustHost = trustHost;
        Set<String> trustHostSet;
        if (DEFAULT_TRUST_HOST.equals(trustHost.toLowerCase())) {
            trustHostSet = new HashSet<>();
        } else {
            String[] trustHostArray = trustHost.toLowerCase().split(",");
            trustHostSet = new HashSet<>(Arrays.asList(trustHostArray));
            ConfigConstants.setTrustHostSet(trustHostSet);
        }
        ConfigConstants.setTrustHostSet(trustHostSet);
    }

    public static Set<String> getTrustHostSet() {
        return trustHostSet;
    }

    private static void setTrustHostSet(Set<String> trustHostSet) {
        ConfigConstants.trustHostSet = trustHostSet;
    }
}
