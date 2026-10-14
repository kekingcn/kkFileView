package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import io.mola.galimatias.GalimatiasParseException;
import org.apache.commons.io.FileUtils;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.HttpClientErrorException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import static cn.keking.utils.KkFileUtils.*;

/**
 * @author yudian-it
 */
public class DownloadUtils {

    private final static Logger logger = LoggerFactory.getLogger(DownloadUtils.class);
    private static final String fileDir = ConfigConstants.getFileDir();
    private static final String URL_PARAM_FTP_USERNAME = "ftp.username";
    private static final String URL_PARAM_FTP_PASSWORD = "ftp.password";
    private static final String URL_PARAM_FTP_CONTROL_ENCODING = "ftp.control.encoding";
    private static final String URL_PARAM_FTP_PORT = "ftp.control.port";

    /**
     * @param fileAttribute fileAttribute
     * @param fileName      文件名
     * @return 本地文件绝对路径
     */
    public static ReturnResponse<String> downLoad(FileAttribute fileAttribute, String fileName) {

        String urlStr = null;
        try {
            urlStr = fileAttribute.getUrl();
        } catch (Exception e) {
            logger.error("处理URL异常:", e);
        }
        ReturnResponse<String> response = new ReturnResponse<>(0, "下载成功!!!", "");
        String realPath = getRelFilePath(fileName, fileAttribute);
        final String fileSuffix = fileAttribute.getSuffix();

        if (KkFileUtils.isIllegalFileName(realPath)) {
            response.setCode(1);
            response.setContent(null);
            response.setMsg("下载失败:文件名不合法!" + urlStr);
            return response;
        }
        if (!KkFileUtils.isAllowedUpload(realPath)) {
            response.setCode(1);
            response.setContent(null);
            response.setMsg("下载失败:不支持的类型!" + urlStr);
            return response;
        }
        if (fileAttribute.isCompressFile()) {
            response.setContent(fileDir + fileName);
            response.setMsg(fileName);
            return response;
        }
        if (KkFileUtils.isExist(realPath) && !fileAttribute.forceUpdatedCache()) {
            response.setContent(realPath);
            response.setMsg(fileName);
            return response;
        }

        try {
            URL url = WebUtils.normalizedURL(urlStr);
            if (!fileAttribute.getSkipDownLoad()) {
                if (isHttpUrl(url)) {
                    File realFile = new File(realPath);
                    CloseableHttpClient httpClient = HttpRequestUtils.createConfiguredHttpClient();
                    String finalUrlStr = urlStr;

                    final boolean[] hasMimeError = {false};
                    final String[] mimeErrorMessage = {null};

                    HttpRequestUtils.executeHttpRequest(url, httpClient, fileAttribute, responseWrapper -> {
                        String contentType = responseWrapper.getContentType();
                        if (WebUtils.isMimeCheckRequired(fileSuffix)) {
                            if (!WebUtils.isValidMimeType(contentType, fileSuffix)) {
                                logger.error("文件类型错误，期望二进制文件但接收到文本类型，url: {}, Content-Type: {}",
                                        finalUrlStr, contentType);
                                hasMimeError[0] = true;
                                mimeErrorMessage[0] = "期望二进制文件但接收到文本类型，Content-Type: " + contentType;
                                return;
                            }
                        }
                        FileUtils.copyToFile(responseWrapper.getInputStream(), realFile);
                    }, true);

                    if (hasMimeError[0]) {
                        response.setCode(1);
                        response.setContent(null);
                        response.setMsg(mimeErrorMessage[0]);
                        return response;
                    }

                } else if (isFtpUrl(url)) {
                    String ftpUsername = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_USERNAME);
                    String ftpPassword = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_PASSWORD);
                    String ftpControlEncoding = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_CONTROL_ENCODING);
                    String ftpport = WebUtils.getUrlParameterReg(realPath, URL_PARAM_FTP_PORT);
                    FtpUtils.download(fileAttribute.getUrl(), ftpport, realPath, ftpUsername, ftpPassword, ftpControlEncoding);
                } else if (isFileUrl(url)) {
                    handleFileProtocol(url, realPath);
                } else {
                    response.setCode(1);
                    response.setMsg("url不能识别url" + urlStr);
                    return response;
                }
            }
            response.setContent(realPath);
            response.setMsg(fileName);
            return response;

        } catch (HttpClientErrorException e) {
            logger.error("HTTP请求失败，状态码：{}，url：{}", e.getStatusCode(), urlStr);
            response.setCode(1);
            response.setContent(null);
            if (e.getStatusCode().is4xxClientError()) {
                response.setMsg("文件不存在或无法访问 (HTTP " + e.getStatusCode() + ")");
            } else {
                response.setMsg("下载失败: " + e.getMessage());
            }
            return response;
        } catch (IOException | GalimatiasParseException e) {
            logger.error("文件下载失败，url：{}", urlStr);
            response.setCode(1);
            response.setContent(null);
            if (e instanceof FileNotFoundException) {
                response.setMsg("文件不存在!!!");
            } else {
                response.setMsg(e.getMessage());
            }
            return response;
        } catch (Exception e) {
            logger.error("下载文件时发生未知异常，url：{}", urlStr, e);
            response.setCode(1);
            response.setContent(null);
            response.setMsg("下载失败: " + e.getMessage());
            return response;
        }
    }

    // 处理file协议的文件下载
    private static void handleFileProtocol(URL url, String targetPath) throws IOException {
        File sourceFile = new File(url.getPath());
        if (!sourceFile.exists()) {
            throw new FileNotFoundException("本地文件不存在: " + url.getPath());
        }
        if (!sourceFile.isFile()) {
            throw new IOException("路径不是文件: " + url.getPath());
        }

        File targetFile = new File(targetPath);

        // 判断源文件和目标文件是否是同一个文件（防止自身复制覆盖）
        if (isSameFile(sourceFile, targetFile)) {
            // 如果是同一个文件，直接返回，不执行复制操作
            logger.info("源文件和目标文件相同，跳过复制: {}", sourceFile.getAbsolutePath());
            return;
        }

        // 确保目标目录存在
        File parentDir = targetFile.getParentFile();
        if (parentDir != null && !parentDir.exists()) {
            parentDir.mkdirs();
        }

        // 复制文件
        Files.copy(sourceFile.toPath(), targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    }

    /**
     * 判断两个文件是否是同一个文件
     * 通过比较规范化路径来避免符号链接、相对路径等问题
     */
    private static boolean isSameFile(File file1, File file2) {
        try {
            // 使用规范化路径比较，可以处理符号链接、相对路径等情况
            String canonicalPath1 = file1.getCanonicalPath();
            String canonicalPath2 = file2.getCanonicalPath();

            // 如果是Windows系统，忽略路径大小写
            if (isWindows()) {
                return canonicalPath1.equalsIgnoreCase(canonicalPath2);
            }
            return canonicalPath1.equals(canonicalPath2);
        } catch (IOException e) {
            // 如果获取规范化路径失败，使用绝对路径比较
            logger.warn("无法获取文件的规范化路径，使用绝对路径比较: {}, {}", file1.getAbsolutePath(), file2.getAbsolutePath());

            String absolutePath1 = file1.getAbsolutePath();
            String absolutePath2 = file2.getAbsolutePath();

            if (isWindows()) {
                return absolutePath1.equalsIgnoreCase(absolutePath2);
            }
            return absolutePath1.equals(absolutePath2);
        }
    }

    /**
     * 获取真实文件绝对路径
     *
     * @param fileName 文件名
     * @return 文件路径
     */
    private static String getRelFilePath(String fileName, FileAttribute fileAttribute) {
        String type = fileAttribute.getSuffix();
        if (null == fileName) {
            UUID uuid = UUID.randomUUID();
            fileName = uuid + "." + type;
        } else { // 文件后缀不一致时，以type为准(针对simText【将类txt文件转为txt】)
            fileName = fileName.replace(fileName.substring(fileName.lastIndexOf(".") + 1), type);
        }

        String realPath = fileDir + fileName;
        File dirFile = new File(fileDir);
        if (!dirFile.exists() && !dirFile.mkdirs()) {
            logger.error("创建目录【{}】失败,可能是权限不够，请检查", fileDir);
        }
        return realPath;
    }
}