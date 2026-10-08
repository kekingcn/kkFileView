package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.ftp.FTPClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Objects;

/**
 * @auther: chenjh
 * @since: 2019/6/18 14:36
 */
public class FtpUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(FtpUtils.class);

    /**
     * 从FTP服务器下载文件到本地
     */
    public static void download(String ftpUrl, String ftpport, String localFilePath,
                                String ftpUsername, String ftpPassword,
                                String ftpControlEncoding) throws IOException {
        // 获取FTP连接信息
        FtpConnectionInfo connectionInfo = parseFtpConnectionInfo(ftpUrl, ftpport, ftpUsername, ftpPassword, ftpControlEncoding);

        LOGGER.debug("FTP下载 - url:{}, host:{}, port:{}, username:{}, 保存路径:{}",
                ftpUrl, connectionInfo.host, connectionInfo.port, connectionInfo.username, localFilePath);

        FTPClient ftpClient = connect(connectionInfo.host, connectionInfo.port,
                connectionInfo.username, connectionInfo.password,
                connectionInfo.controlEncoding);

        try {
            // 设置被动模式
            ftpClient.enterLocalPassiveMode();

            // 获取文件输入流
            String encodedFilePath = new String(
                    connectionInfo.remoteFilePath.getBytes(connectionInfo.controlEncoding), StandardCharsets.ISO_8859_1
            );

            // 方法1：直接下载文件到本地
            try (OutputStream outputStream = Files.newOutputStream(Paths.get(localFilePath))) {
                boolean downloadResult = ftpClient.retrieveFile(encodedFilePath, outputStream);
                LOGGER.debug("FTP下载结果: {}", downloadResult);
                if (!downloadResult) {
                    throw new IOException("FTP文件下载失败，返回码: " + ftpClient.getReplyCode());
                }
            }
        } finally {
            closeFtpClient(ftpClient);
        }
    }

    /**
     * 预览FTP文件 - 返回输入流（调用者需要关闭流）
     */
    public static InputStream preview(String ftpUrl, String ftpport, String localFilePath,
                                      String ftpUsername, String ftpPassword,
                                      String ftpControlEncoding) throws IOException {
        // 获取FTP连接信息
        FtpConnectionInfo connectionInfo = parseFtpConnectionInfo(ftpUrl, ftpport, ftpUsername, ftpPassword, ftpControlEncoding);

        LOGGER.debug("FTP预览 - url:{}, host:{}, port:{}, username:{}",
                ftpUrl, connectionInfo.host, connectionInfo.port, connectionInfo.username);

        FTPClient ftpClient = connect(connectionInfo.host, connectionInfo.port,
                connectionInfo.username, connectionInfo.password,
                connectionInfo.controlEncoding);

        try {
            // 设置被动模式
            ftpClient.enterLocalPassiveMode();

            // 获取文件输入流
            String encodedFilePath = new String(
                    connectionInfo.remoteFilePath.getBytes(connectionInfo.controlEncoding), StandardCharsets.ISO_8859_1
            );

            // 获取文件输入流
            InputStream inputStream = ftpClient.retrieveFileStream(encodedFilePath);

            if (inputStream == null) {
                closeFtpClient(ftpClient);
                throw new IOException("无法获取FTP文件流，可能文件不存在或无权限");
            }

            // 包装输入流，在流关闭时自动断开FTP连接
            return new FtpAutoCloseInputStream(inputStream, ftpClient);

        } catch (IOException e) {
            // 发生异常时确保关闭连接
            closeFtpClient(ftpClient);
            throw e;
        }
    }

    /**
     * 解析FTP连接信息（抽取公共逻辑）
     */
    private static FtpConnectionInfo parseFtpConnectionInfo(String ftpUrl, String ftpport,
                                                            String ftpUsername, String ftpPassword,
                                                            String ftpControlEncoding) throws IOException {
        FtpConnectionInfo info = new FtpConnectionInfo();

        // 从配置获取默认连接参数
        String basic = ConfigConstants.getFtpUsername();
        if (!StringUtils.isEmpty(basic) && !Objects.equals(basic, "false")) {
            String[] params = WebUtils.namePass(ftpUrl, basic);
            if (params != null && params.length >= 5) {
                info.port = Integer.parseInt(params[1]);
                info.username = params[2];
                info.password = params[3];
                info.controlEncoding = params[4];
            }
        }

        // 使用传入参数覆盖默认值
        if (!StringUtils.isEmpty(ftpport)) {
            info.port = Integer.parseInt(ftpport);
        }
        if (!StringUtils.isEmpty(ftpUsername)) {
            info.username = ftpUsername;
        }
        if (!StringUtils.isEmpty(ftpPassword)) {
            info.password = ftpPassword;
        }
        if (!StringUtils.isEmpty(ftpControlEncoding)) {
            info.controlEncoding = ftpControlEncoding;
        }

        // 设置默认值
        if (info.port == 0) {
            info.port = 21;
        }
        if (StringUtils.isEmpty(info.controlEncoding)) {
            info.controlEncoding = "UTF-8";
        }
        // 解析URL
        try {
            URI uri = new URI(ftpUrl);
            info.host = uri.getHost();
            info.remoteFilePath = uri.getPath();
        } catch (URISyntaxException e) {
            throw new IOException("无效的FTP URL: " + ftpUrl, e);
        }
        // URI#getPath decodes percent escapes. Validate the values actually
        // sent as FTP command arguments, before opening any connection.
        validateCommandArgument(info.remoteFilePath);
        validateCommandArgument(info.username);
        validateCommandArgument(info.password);
        validateCommandArgument(new String(info.remoteFilePath.getBytes(info.controlEncoding),
                StandardCharsets.ISO_8859_1));
        return info;
    }

    private static void validateCommandArgument(String value) throws IOException {
        if (value != null && value.chars().anyMatch(c -> c < 0x20 || c == 0x7f)) {
            throw new IOException("FTP command arguments must not contain control characters");
        }
    }

    /**
     * FTP连接信息对象
     */
    private static class FtpConnectionInfo {
        String host;
        int port = 21;
        String username;
        String password;
        String controlEncoding = "UTF-8";
        String remoteFilePath;
    }

    /**
     * 自动关闭FTP连接的输入流包装类
     */
    private static class FtpAutoCloseInputStream extends FilterInputStream {
        private final FTPClient ftpClient;

        protected FtpAutoCloseInputStream(InputStream in, FTPClient ftpClient) {
            super(in);
            this.ftpClient = ftpClient;
        }

        @Override
        public void close() throws IOException {
            try {
                super.close();
                // 确保FTP命令完成
                if (ftpClient != null) {
                    ftpClient.completePendingCommand();
                }
            } finally {
                closeFtpClient(ftpClient);
            }
        }
    }

    /**
     * 安全关闭FTP连接
     */
    private static void closeFtpClient(FTPClient ftpClient) {
        if (ftpClient != null && ftpClient.isConnected()) {
            try {
                ftpClient.logout();
                ftpClient.disconnect();
            } catch (IOException e) {
                LOGGER.warn("关闭FTP连接时发生异常", e);
            }
        }
    }

    /**
     * 连接FTP服务器
     */
    private static FTPClient connect(String host, int port, String username,
                                     String password, String controlEncoding) throws IOException {
        FTPClient ftpClient = new FTPClient();
        ftpClient.setControlEncoding(controlEncoding);
        ftpClient.connect(host, port);

        if (!ftpClient.login(username, password)) {
            throw new IOException("FTP登录失败，用户名或密码错误");
        }

        ftpClient.setFileType(FTPClient.BINARY_FILE_TYPE);
        return ftpClient;
    }
}
