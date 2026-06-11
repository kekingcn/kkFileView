package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.WebUtils;
import io.mola.galimatias.GalimatiasParseException;
import org.jodconverter.core.util.OSUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;

import jakarta.servlet.*;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

/**
 * @author : kl (http://kailing.pub)
 * @since : 2022-05-25 17:45
 */
public class TrustDirFilter implements Filter {

    private String notTrustDirView;
    private static final Logger logger = LoggerFactory.getLogger(TrustDirFilter.class);


    @Override
    public void init(FilterConfig filterConfig) {
        ClassPathResource classPathResource = new ClassPathResource("web/notTrustDir.html");
        try {
            classPathResource.getInputStream();
            byte[] bytes = FileCopyUtils.copyToByteArray(classPathResource.getInputStream());
            this.notTrustDirView = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            logger.error("加载notTrustDir.html失败", e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String url = WebUtils.getSourceUrl(request);
        if (!allowPreview(url)) {
            response.getWriter().write(this.notTrustDirView);
            response.getWriter().close();
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {

    }

    public static boolean isTrustedFileUrl(String urlPath) {
        // 判断URL是否合法
        if (KkFileUtils.isIllegalFileName(urlPath) || !StringUtils.hasText(urlPath) || !WebUtils.isValidUrl(urlPath)) {
            return false;
        }
        try {
            URL url = WebUtils.normalizedURL(urlPath);

            if ("file".equals(url.getProtocol().toLowerCase(Locale.ROOT))) {
                String filePath = URLDecoder.decode(url.getPath(), StandardCharsets.UTF_8.name());
                // 将文件路径转换为File对象
                File targetFile = new File(filePath);
                // 将配置目录也转换为File对象
                File fileDir = new File(ConfigConstants.getFileDir());
                File localPreviewDir = new File(ConfigConstants.getLocalPreviewDir());
                try {
                    // 获取规范路径
                    String canonicalFilePath = targetFile.getCanonicalPath();
                    String canonicalFileDir = fileDir.getCanonicalPath();
                    String canonicalLocalPreviewDir = localPreviewDir.getCanonicalPath();
                    return isSubDirectory(canonicalFileDir, canonicalFilePath) || isSubDirectory(canonicalLocalPreviewDir, canonicalFilePath);
                } catch (IOException e) {
                    LoggerFactory.getLogger(TrustDirFilter.class).warn("获取规范路径失败，使用原始路径比较", e);
                    String absFilePath = targetFile.getAbsolutePath();
                    String absFileDir = fileDir.getAbsolutePath();
                    String absLocalPreviewDir = localPreviewDir.getAbsolutePath();
                    absFilePath = absFilePath.replace('\\', '/');
                    absFileDir = absFileDir.replace('\\', '/');
                    absLocalPreviewDir = absLocalPreviewDir.replace('\\', '/');
                    if (!absFileDir.endsWith("/")) absFileDir += "/";
                    if (!absLocalPreviewDir.endsWith("/")) absLocalPreviewDir += "/";
                    return absFilePath.startsWith(absFileDir) || absFilePath.startsWith(absLocalPreviewDir);
                }
            }
            return true;
        } catch (IOException | GalimatiasParseException e) {
            LoggerFactory.getLogger(TrustDirFilter.class).error("解析URL异常，url：{}", urlPath, e);
            return false;
        }
    }

    private boolean allowPreview(String urlPath) {
        // 判断URL是否合法
        if (KkFileUtils.isIllegalFileName(urlPath) || !StringUtils.hasText(urlPath) || !WebUtils.isValidUrl(urlPath)) {
            return false;
        }
        try {
            URL url = WebUtils.normalizedURL(urlPath);

            if ("file".equals(url.getProtocol().toLowerCase(Locale.ROOT))) {
                String filePath = URLDecoder.decode(url.getPath(), StandardCharsets.UTF_8.name());
                // 将文件路径转换为File对象
                File targetFile = new File(filePath);
                // 将配置目录也转换为File对象
                File fileDir = new File(ConfigConstants.getFileDir());
                File localPreviewDir = new File(ConfigConstants.getLocalPreviewDir());
                try {
                    // 获取规范路径（系统会自动处理大小写、符号链接、相对路径等）
                    String canonicalFilePath = targetFile.getCanonicalPath();
                    String canonicalFileDir = fileDir.getCanonicalPath();
                    String canonicalLocalPreviewDir = localPreviewDir.getCanonicalPath();
                    // 检查文件是否在配置目录下
                    return isSubDirectory(canonicalFileDir, canonicalFilePath) ||  isSubDirectory(canonicalLocalPreviewDir, canonicalFilePath);
                } catch (IOException e) {
                    logger.warn("获取规范路径失败，使用原始路径比较", e);
                    // 如果获取规范路径失败，回退到原始路径比较
                    String absFilePath = targetFile.getAbsolutePath();
                    String absFileDir = fileDir.getAbsolutePath();
                    String absLocalPreviewDir = localPreviewDir.getAbsolutePath();
                    // 统一路径分隔符
                    absFilePath = absFilePath.replace('\\', '/');
                    absFileDir = absFileDir.replace('\\', '/');
                    absLocalPreviewDir = absLocalPreviewDir.replace('\\', '/');
                    // 确保目录以斜杠结尾
                    if (!absFileDir.endsWith("/")) absFileDir += "/";
                    if (!absLocalPreviewDir.endsWith("/")) absLocalPreviewDir += "/";
                    return absFilePath.startsWith(absFileDir) ||  absFilePath.startsWith(absLocalPreviewDir);
                }
            }
            return true;
        } catch (IOException | GalimatiasParseException e) {
            logger.error("解析URL异常，url：{}", urlPath, e);
            return false;
        }
    }

    /**
     * 检查子路径是否在父路径下（跨平台）
     */
    private static boolean isSubDirectory(String parentDir, String childPath) {
        try {
            File parent = new File(parentDir);
            File child = new File(childPath);
            // 获取规范路径
            String canonicalParent = parent.getCanonicalPath();
            String canonicalChild = child.getCanonicalPath();
            // 确保父目录以路径分隔符结尾
            if (!canonicalParent.endsWith(File.separator)) {
                canonicalParent += File.separator;
            }
            // 比较路径
            return canonicalChild.startsWith(canonicalParent);
        } catch (IOException e) {
            logger.warn("检查子路径失败", e);
            return false;
        }
    }
}
