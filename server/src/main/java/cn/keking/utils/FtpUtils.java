package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

/**
 * @auther: chenjh
 * @since: 2019/6/18 14:36
 */
public class FtpUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(FtpUtils.class);

    public static FTPClient connect(String host, int port, String username, String password, String controlEncoding) throws IOException {
        FTPClient ftpClient = new FTPClient();
        ftpClient.connect(host, port);
        if (!StringUtils.isEmpty(username) && !StringUtils.isEmpty(password)) {
            ftpClient.login(username, password);
        }
        int reply = ftpClient.getReplyCode();
        if (!FTPReply.isPositiveCompletion(reply)) {
            ftpClient.disconnect();
        }
        ftpClient.setControlEncoding(controlEncoding);
        ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
        return ftpClient;
    }

    public static void download(String ftpUrl, String localFilePath, String ftpUsername, String ftpPassword, String ftpControlEncoding) throws IOException {
        ftpUrl = URLDecoder.decode(ftpUrl, StandardCharsets.UTF_8.name());
        String username = StringUtils.isEmpty(ftpUsername) ? ConfigConstants.getFtpUsername() : ftpUsername;
        String password = StringUtils.isEmpty(ftpPassword) ? ConfigConstants.getFtpPassword() : ftpPassword;
        String controlEncoding = StringUtils.isEmpty(ftpControlEncoding) ? ConfigConstants.getFtpControlEncoding() : ftpControlEncoding;
        URL url = new URL(ftpUrl);
        String host = url.getHost();
        int port = (url.getPort() == -1) ? url.getDefaultPort() : url.getPort();

        LOGGER.debug("FTP connection url:{}, username:{}, password:{}, controlEncoding:{}, localFilePath:{}", ftpUrl, username, password, controlEncoding, localFilePath);
        FTPClient ftpClient = connect(host, port, username, password, controlEncoding);
        ftpClient.enterLocalPassiveMode();

        // 确定文件是否存在
        String remoteFilePath = url.getPath();
        String remotePathEncoded = new String(remoteFilePath.getBytes(controlEncoding), StandardCharsets.ISO_8859_1);
        String[] existFiles = ftpClient.listNames(remotePathEncoded);
        if (existFiles.length == 0) {
            throw new IllegalStateException("FTP服务器上没有找到文件 '" + remoteFilePath + "'");
        }

        // 下载文件
        KkFileUtils.createFileIfNotExists(localFilePath);
        try (OutputStream outputStream = new FileOutputStream(localFilePath)) {
            boolean downloadResult = ftpClient.retrieveFile(remotePathEncoded, outputStream);
            LOGGER.info("FTP download result {}", downloadResult);
        }

        ftpClient.logout();
        ftpClient.disconnect();
    }
}
