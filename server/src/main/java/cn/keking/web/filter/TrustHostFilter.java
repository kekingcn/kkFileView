package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;

import javax.servlet.*;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * @author chenjh
 * @since 2020/2/18 19:13
 */
public class TrustHostFilter implements Filter {

    private String notTrustHost;

    @Override
    public void init(FilterConfig filterConfig) {
        ClassPathResource classPathResource = new ClassPathResource("web/notTrustHost.html");
        try {
            classPathResource.getInputStream();
            byte[] bytes = FileCopyUtils.copyToByteArray(classPathResource.getInputStream());
            this.notTrustHost = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String url = getSourceUrl(request);
        String host = getHost(url);
        if (host != null &&!ConfigConstants.getTrustHostSet().isEmpty() && !ConfigConstants.getTrustHostSet().contains(host)) {
            String html = this.notTrustHost.replace("${current_host}", host);
            response.getWriter().write(html);
            response.getWriter().close();
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }

    private String getSourceUrl(ServletRequest request) {
        String url = request.getParameter("url");
        String currentUrl = request.getParameter("currentUrl");
        String urlPath = request.getParameter("urlPath");
        if (StringUtils.isNotBlank(url)) {
            return url;
        }
        if (StringUtils.isNotBlank(currentUrl)) {
            return currentUrl;
        }
        if (StringUtils.isNotBlank(urlPath)) {
            return urlPath;
        }
        return null;
    }

    private String getHost(String urlStr) {
        try {
            URL url = new URL(urlStr);
            return url.getHost().toLowerCase();
        } catch (MalformedURLException ignored) {
        }
        return null;
    }
}
