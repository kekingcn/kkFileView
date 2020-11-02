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
import java.util.regex.Matcher;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.regex.Pattern;
import java.util.Set;

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
        // if (host != null &&!ConfigConstants.getTrustHostSet().isEmpty() && !ConfigConstants.getTrustHostSet().contains(host)) {
        if (host != null &&!ConfigConstants.getTrustHostSet().isEmpty() && !isTrustHost(host)) {
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

    /**
     * 二开，是否信任域名，支持正则匹配
     */
    private Boolean isTrustHost(String host) {
        Set<String> trustHostSet = ConfigConstants.getTrustHostSet();
        Boolean[] isTrust = new Boolean[]{false};
        trustHostSet.forEach((trustHost) -> {
            //泛域名匹配,eg:\\w+.baidu.com
            if (Pattern.matches(trustHost, host)) {
                isTrust[0] = true;
            }
        });
        return isTrust[0];
    }
}
