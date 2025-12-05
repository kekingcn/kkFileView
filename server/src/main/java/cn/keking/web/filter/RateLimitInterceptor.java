package cn.keking.web.filter;

import cn.keking.service.cache.RateLimiter;
import cn.keking.service.cache.RateLimiterFactory;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

/**
 * 限流拦截器
 */
@Component
public class RateLimitInterceptor implements Filter {
    private static final Logger LOGGER = LoggerFactory.getLogger(RateLimitInterceptor.class);

    @Autowired
    private RateLimiterFactory rateLimiterFactory;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        try {
            // 获取客户端IP地址
            String clientIP = getClientIP(httpRequest);
            LOGGER.debug("Request from IP: {}", clientIP);

            // 创建限流器实例
            RateLimiter rateLimiter = rateLimiterFactory.createRateLimiter();

            // 检查是否允许访问
            if (!rateLimiter.allowAccess(clientIP)) {
                httpResponse.setStatus(429); // 429 Too Many Requests
                httpResponse.setContentType("text/plain;charset=UTF-8");
                httpResponse.getWriter().write("请求太频繁，请稍后再试");
                return;
            }

            // 继续执行后续的过滤器或请求处理
            chain.doFilter(request, response);
        } catch (Exception e) {
            LOGGER.error("Error in rate limit interceptor", e);
            // 异常时不限流，继续执行后续的过滤器或请求处理
            chain.doFilter(request, response);
        }
    }

    /**
     * 获取客户端IP地址
     * @param request HTTP请求
     * @return 客户端IP地址
     */
    private String getClientIP(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 如果有多个IP地址，取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化操作
    }

    @Override
    public void destroy() {
        // 销毁操作
    }
}
