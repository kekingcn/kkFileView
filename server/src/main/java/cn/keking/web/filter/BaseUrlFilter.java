package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * @author chenjh
 * @since 2020/5/13 18:27
 */
public class BaseUrlFilter implements Filter {

    private static String BASE_URL;

    public static String getBaseUrl() {
        String baseUrl;
        try {
            baseUrl = (String) RequestContextHolder.currentRequestAttributes().getAttribute("baseUrl", 0);
        } catch (Exception e) {
            baseUrl = BASE_URL;
        }
        return baseUrl;
    }


    @Override
    public void init(FilterConfig filterConfig) {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {

        String baseUrl;
        String baseUrlTmp = ConfigConstants.getBaseUrl();

        final HttpServletRequest servletRequest = (HttpServletRequest) request;
        // 支持通过 http header 中 X-Base-Url 来动态设置 baseUrl 以支持多个域名/项目的共享使用
        final String urlInHeader = servletRequest.getHeader("X-Base-Url");
        if (StringUtils.isNotEmpty(urlInHeader)) {
            baseUrl = urlInHeader;
        } else if (baseUrlTmp != null && !ConfigConstants.DEFAULT_BASE_URL.equalsIgnoreCase(baseUrlTmp)) {
            // 如果配置文件中配置了 baseUrl 且不为 default 则以配置文件为准
            if (!baseUrlTmp.endsWith("/")) {
                baseUrlTmp = baseUrlTmp.concat("/");
            }
            baseUrl = baseUrlTmp;
        } else {
            // 动态拼接 baseUrl
            baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                    + servletRequest.getContextPath() + "/";
        }
        BASE_URL = baseUrl;
        request.setAttribute("baseUrl", baseUrl);
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
