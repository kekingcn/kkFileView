package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.model.ReturnResponse;
import io.mola.galimatias.GalimatiasParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

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
        String urlStr = fileAttribute.getUrl();
        String type = fileAttribute.getSuffix();
        ReturnResponse<String> response = new ReturnResponse<>(0, "下载成功!!!", "");
        UUID uuid = UUID.randomUUID();
        if (null == fileName) {
            fileName = uuid + "." + type;
        } else { // 文件后缀不一致时，以type为准(针对simText【将类txt文件转为txt】)
            fileName = fileName.replace(fileName.substring(fileName.lastIndexOf(".") + 1), type);
        }
        String realPath = fileDir + fileName;
        File dirFile = new File(fileDir);
        if (!dirFile.exists() && !dirFile.mkdirs()) {
            logger.error("创建目录【{}】失败,可能是权限不够，请检查", fileDir);
        }
        try {
            URL url = new URL(urlStr);
            if (url.getProtocol() != null && (url.getProtocol().toLowerCase().startsWith("file") || url.getProtocol().toLowerCase().startsWith("http"))) {
                byte[] bytes = getBytesFromUrl(urlStr);
                OutputStream os = new FileOutputStream(realPath);
                saveBytesToOutStream(bytes, os);
            } else if (url.getProtocol() != null && "ftp".equalsIgnoreCase(url.getProtocol())) {
                String ftpUsername = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_USERNAME);
                String ftpPassword = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_PASSWORD);
                String ftpControlEncoding = WebUtils.getUrlParameterReg(fileAttribute.getUrl(), URL_PARAM_FTP_CONTROL_ENCODING);
                FtpUtils.download(fileAttribute.getUrl(), realPath, ftpUsername, ftpPassword, ftpControlEncoding);
            } else {
                response.setCode(1);
                response.setContent(null);
                response.setMsg("url不能识别url" + urlStr);
            }
            response.setContent(realPath);
            response.setMsg(fileName);
            if (FileType.simText.equals(fileAttribute.getType())) {
                convertTextPlainFileCharsetToUtf8(realPath);
            }
            return response;
        } catch (IOException e) {
            logger.error("文件下载失败，url：{}", urlStr, e);
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

    public static byte[] getBytesFromUrl(String urlStr) throws IOException {
        InputStream is = getInputStreamFromUrl(urlStr);
        if (is == null) {
            is = getInputStreamFromUrl(urlStr);
            if (is == null) {
                logger.error("文件下载异常：url：{}", urlStr);
                throw new IOException("文件下载异常：url：" + urlStr);
            }
        }
        return getBytesFromStream(is);
    }

    public static void saveBytesToOutStream(byte[] b, OutputStream os) throws IOException {
        os.write(b);
        os.close();
    }

    private static InputStream getInputStreamFromUrl(String urlStr) {
        try {

            URL url = io.mola.galimatias.URL.parse(urlStr).toJavaURL();
            URLConnection connection = url.openConnection();
            if (connection instanceof HttpURLConnection) {
                connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
            }
            return connection.getInputStream();
        } catch (IOException | GalimatiasParseException e) {
            logger.warn("连接url异常：url：{}", urlStr);
            return null;
        }
    }

    private static byte[] getBytesFromStream(InputStream is) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int len;
        while ((len = is.read(buffer)) != -1) {
            baos.write(buffer, 0, len);
        }
        byte[] b = baos.toByteArray();
        is.close();
        baos.close();
        return b;
    }

    /**
     * 转换文本文件编码为utf8
     * 探测源文件编码,探测到编码切不为utf8则进行转码
     *
     * @param filePath 文件路径
     */
    private static void convertTextPlainFileCharsetToUtf8(String filePath) throws IOException {
        File sourceFile = new File(filePath);
        if (sourceFile.exists() && sourceFile.isFile() && sourceFile.canRead()) {
            String encoding = FileUtils.getFileEncode(filePath);
            if (!FileUtils.DEFAULT_FILE_ENCODING.equals(encoding)) {
                // 不为utf8,进行转码
                File tmpUtf8File = new File(filePath + ".utf8");
                Writer writer = new OutputStreamWriter(new FileOutputStream(tmpUtf8File), StandardCharsets.UTF_8);
                Reader reader = new BufferedReader(new InputStreamReader(new FileInputStream(sourceFile), encoding));
                char[] buf = new char[1024];
                int read;
                while ((read = reader.read(buf)) > 0) {
                    writer.write(buf, 0, read);
                }
                reader.close();
                writer.close();
                // 删除源文件
                if (!sourceFile.delete()) {
                    logger.error("源文件【{}】删除失败,请检查文件目录权限！", filePath);
                }
                // 重命名
                if (tmpUtf8File.renameTo(sourceFile)) {
                    logger.error("临时文件【{}】重命名失败，请检查文件路径权限！", tmpUtf8File.getPath());
                }
            }
        }
    }
}
