package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.WebUtils;
import io.mola.galimatias.GalimatiasParseException;
import org.jodconverter.core.util.OSUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;

import javax.servlet.*;
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
    private final Logger logger = LoggerFactory.getLogger(TrustDirFilter.class);


    @Override
    public void init(FilterConfig filterConfig) {
        ClassPathResource classPathResource = new ClassPathResource("web/notTrustDir.html");
        try {
            classPathResource.getInputStream();
            byte[] bytes = FileCopyUtils.copyToByteArray(classPathResource.getInputStream());
            this.notTrustDirView = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
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

    private boolean allowPreview(String urlPath) {
        if(!StringUtils.hasText(urlPath) || !WebUtils.hefaurl(urlPath)){   //判断URL是否合法
            return false ;
        }
        try {
            URL url = WebUtils.normalizedURL(urlPath);
            if ("file".equals(url.getProtocol().toLowerCase(Locale.ROOT))) {
                String filePath = URLDecoder.decode(url.getPath(), StandardCharsets.UTF_8.name());
                if (OSUtils.IS_OS_WINDOWS) {
                    filePath = filePath.replaceAll("/", "\\\\");
                }
                return filePath.startsWith(ConfigConstants.getFileDir()) || filePath.startsWith(ConfigConstants.getLocalPreviewDir());
            }
            return true;
        } catch (IOException | GalimatiasParseException e) {
            logger.error("解析URL异常，url：{}", urlPath, e);
            return false;
        }
    }
}
