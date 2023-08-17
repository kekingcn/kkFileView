package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import io.mola.galimatias.GalimatiasParseException;
import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.util.UUID;

import static cn.keking.utils.KkFileUtils.isFtpUrl;
import static cn.keking.utils.KkFileUtils.isHttpUrl;

/**
 * @author yudian-it
 */
public class DownloadUtils {

    private final static Logger logger = LoggerFactory.getLogger(DownloadUtils.class);
    private static final String fileDir = ConfigConstants.getFileDir();
    private static final String URL_PARAM_FTP_USERNAME = "ftp.username";
    private static final String URL_PARAM_FTP_PASSWORD = "ftp.password";
    private static final String URL_PARAM_FTP_CONTROL_ENCODING = "ftp.control.encoding";

    /**
     * @param fileAttribute fileAttribute
     * @param fileName      文件名
     * @return 本地文件绝对路径
     */
    public static ReturnResponse<String> downLoad(FileAttribute fileAttribute, String fileName) {
        // 忽略ssl证书
        String urlStr = null;
        HttpURLConnection urlcon;
        try {
            SslUtils.ignoreSsl();
            urlStr = fileAttribute.getUrl().replaceAll("\\+", "%20");
        } catch (Exception e) {
            logger.error("忽略SSL证书异常:", e);
        }
        ReturnResponse<String> response = new ReturnResponse<>(0, "下载成功!!!", "");
        String realPath = getRelFilePath(fileName, fileAttribute);
        if (null == realPath || !KkFileUtils.isAllowedUpload(realPath)) {
            response.setCode(1);
            response.setContent(null);
            response.setMsg("下载失败:不支持的类型!" + urlStr);
            return response;
        }
        assert urlStr != null;
        if (urlStr.contains("?fileKey=")) {
            response.setContent(fileDir + fileName);
            response.setMsg(fileName);
            return response;
        }
        if(!StringUtils.hasText(realPath)){
            response.setCode(1);
            response.setContent(null);
            response.setMsg("下载失败:文件名不合法!" + urlStr);
            return response;
        }
        if(realPath.equals("cunzhai")){
            response.setContent(fileDir + fileName);
            response.setMsg(fileName);
            return response;
        }
        try {
            URL url = WebUtils.normalizedURL(urlStr);
            if (!urlStr.toLowerCase().startsWith("ftp:")&& !urlStr.toLowerCase().startsWith("file")){
                urlcon=(HttpURLConnection)url.openConnection();
                urlcon.setConnectTimeout(30000);
                urlcon.setReadTimeout(30000);
                urlcon.setInstanceFollowRedirects(false);
                int responseCode = urlcon.getResponseCode();
                if(responseCode != 200){
                    if (responseCode == HttpURLConnection.HTTP_MOVED_PERM || responseCode == HttpURLConnection.HTTP_MOVED_TEMP) { //301 302
                        url =new URL(urlcon.getHeaderField("Location"));
                    }
                    if (responseCode == 403|| responseCode == 500) { //301 302
                        response.setCode(1);
                        response.setContent(null);
                        response.setMsg("下载失败:地址错误!" + urlStr);
                        return response;
                    }
                    if (responseCode  == 404 ) {  //404
                        try {
                            urlStr = URLDecoder.decode(urlStr, "UTF-8");
                            urlStr = URLDecoder.decode(urlStr, "UTF-8");
                            url = WebUtils.normalizedURL(urlStr);
                            urlcon=(HttpURLConnection)url.openConnection();
                            urlcon.setConnectTimeout(30000);
                            urlcon.setReadTimeout(30000);
                            urlcon.setInstanceFollowRedirects(false);
                            responseCode = urlcon.getResponseCode();
                            if (responseCode == HttpURLConnection.HTTP_MOVED_PERM || responseCode == HttpURLConnection.HTTP_MOVED_TEMP) { //301 302
                                url =new URL(urlcon.getHeaderField("Location"));
                            }
                            if(responseCode == 404 ||responseCode == 403|| responseCode == 500 ){
                                response.setCode(1);
                                response.setContent(null);
                                response.setMsg("下载失败:地址错误!" + urlStr);
                                return response;
                            }
                        } catch (UnsupportedEncodingException e) {
                            e.printStackTrace();
                        }finally {
                            assert urlcon != null;
                            urlcon.disconnect();
                        }
                    }
                }
            }
            if (!fileAttribute.getSkipDownLoad()) {
                if (isHttpUrl(url)) {
                    File realFile = new File(realPath);
                    FileUtils.copyURLToFile(url, realFile);
                } else if (isFtpUrl(url)) {
                    String ftpUsername = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_USERNAME);
                    String ftpPassword = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_PASSWORD);
                    String ftpControlEncoding = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_CONTROL_ENCODING);
                    FtpUtils.download(fileAttribute.getUrl(), realPath, ftpUsername, ftpPassword, ftpControlEncoding);
                } else {
                    response.setCode(1);
                    response.setMsg("url不能识别url" + urlStr);
                }
            }
            response.setContent(realPath);
            response.setMsg(fileName);
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
        // 判断是否非法地址
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return null;
        }
        String realPath = fileDir + fileName;
        File dirFile = new File(fileDir);
        if (!dirFile.exists() && !dirFile.mkdirs()) {
            logger.error("创建目录【{}】失败,可能是权限不够，请检查", fileDir);
        }
        Boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        //判断是否启用强制更新功能如果启用 文件必须重新下载
        if (null == forceUpdatedCache || !forceUpdatedCache) {
            // 文件已在本地存在，跳过文件下载
            File realFile = new File(realPath);
            if (realFile.exists()) {
                fileAttribute.setSkipDownLoad(true);
                return "cunzhai"; //这里给的值是不能修改的 对应的是下载方法里面有个强制输出地址的
            }
        }
        return realPath;
    }

}
