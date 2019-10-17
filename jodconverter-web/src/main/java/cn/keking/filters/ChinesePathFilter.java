package cn.keking.filters;

import cn.keking.config.ConfigConstants;
import org.springframework.util.StringUtils;

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
        if (ConfigConstants.getBaseUrl() != null) {
            baseUrl = ConfigConstants.getBaseUrl();
        } else {
            StringBuilder pathBuilder = new StringBuilder();
            pathBuilder.append(request.getScheme()).append("://").append(request.getServerName()).append(":")
                    .append(request.getServerPort()).append(((HttpServletRequest) request).getContextPath()).append("/");
            baseUrl = pathBuilder.toString();
        }
        request.setAttribute("baseUrl", baseUrl);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
