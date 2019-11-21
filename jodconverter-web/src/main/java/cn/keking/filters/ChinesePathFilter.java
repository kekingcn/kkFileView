package cn.keking.filters;

import cn.keking.config.ConfigConstants;
import cn.keking.config.ConfigRefreshComponent;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 *
 * @author yudian-it
 * @date 2017/11/30
 */
public class ChinesePathFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String baseUrl;
        String localBaseUrl;
        StringBuilder pathBuilder = new StringBuilder();
        pathBuilder.append(request.getScheme()).append("://").append(request.getServerName()).append(":")
                .append(request.getServerPort()).append(((HttpServletRequest) request).getContextPath()).append("/");
        localBaseUrl = pathBuilder.toString();
        String baseUrlTmp = ConfigConstants.getBaseUrl();
        if (baseUrlTmp != null && !ConfigRefreshComponent.DEFAULT_BASE_URL.equals(baseUrlTmp.toLowerCase())) {
            if (!baseUrlTmp.endsWith("/")) {
                baseUrlTmp = baseUrlTmp.concat("/");
            }
            baseUrl = baseUrlTmp;
        } else {
            baseUrl = localBaseUrl;
        }
        request.setAttribute("baseUrl", baseUrl);
        request.setAttribute("localBaseUrl", localBaseUrl);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
