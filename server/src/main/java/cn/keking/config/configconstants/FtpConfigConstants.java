package cn.keking.config.configconstants;

import org.springframework.beans.factory.annotation.Value;

public class FtpConfigConstants
{
    private static String ftpUsername;
    private static String ftpPassword;
    private static String ftpControlEncoding;
    private static Boolean fileUploadDisable;

    public static final String DEFAULT_FTP_USERNAME = null;
    public static final String DEFAULT_FTP_PASSWORD = null;
    public static final String DEFAULT_FTP_CONTROL_ENCODING = "UTF-8";

    public static void setFileUploadDisableValue(Boolean fileUploadDisable) {
        FtpConfigConstants.fileUploadDisable = fileUploadDisable;
    }

    public static Boolean getFileUploadDisable() {
        return fileUploadDisable;
    }

    @Value("${file.upload.disable:false}")
    public static void setFileUploadDisable(Boolean fileUploadDisable) {
        setFileUploadDisableValue(fileUploadDisable);
    }

    public static String getFtpUsername() {
        return ftpUsername;
    }

    @Value("${ftp.username:}")
    public void setFtpUsername(String ftpUsername) {
        setFtpUsernameValue(ftpUsername);
    }

    public static void setFtpUsernameValue(String ftpUsername) {
        FtpConfigConstants.ftpUsername = ftpUsername;
    }

    public static String getFtpPassword() {
        return ftpPassword;
    }

    @Value("${ftp.password:}")
    public void setFtpPassword(String ftpPassword) {
        setFtpPasswordValue(ftpPassword);
    }

    public static void setFtpPasswordValue(String ftpPassword) {
        FtpConfigConstants.ftpPassword = ftpPassword;
    }

    public static String getFtpControlEncoding() {
        return ftpControlEncoding;
    }

    @Value("${ftp.control.encoding:UTF-8}")
    public void setFtpControlEncoding(String ftpControlEncoding) {
        setFtpControlEncodingValue(ftpControlEncoding);
    }

    public static void setFtpControlEncodingValue(String ftpControlEncoding) {
        FtpConfigConstants.ftpControlEncoding = ftpControlEncoding;
    }
}
