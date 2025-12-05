package cn.keking.interceptor;

import cn.keking.rate.limiter.RateLimiter;
import cn.keking.rate.limiter.RateLimiterFactory;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * 基于IP地址的限流器拦截器
 * @author kl
 */
public class RateLimitInterceptor implements HandlerInterceptor {
    
    private static final Logger logger = LoggerFactory.getLogger(RateLimitInterceptor.class);
    
    private static final String RATE_LIMIT_RESPONSE = "请求太频繁，请稍后再试";
    private static final String CONTENT_TYPE = "text/plain;charset=UTF-8";
    
    private final RateLimiter rateLimiter;
    
    public RateLimitInterceptor() {
        this.rateLimiter = RateLimiterFactory.getRateLimiter();
    }
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        try {
            String ipAddress = getClientIpAddress(request);
            logger.debug("收到请求，IP地址: {}", ipAddress);
            
            if (rateLimiter.isAllowed(ipAddress)) {
                logger.debug("IP地址: {} 请求允许", ipAddress);
                return true;
            } else {
                logger.warn("IP地址: {} 请求被限流", ipAddress);
                handleRateLimit(response);
                return false;
            }
        } catch (Exception e) {
            logger.error("限流器拦截器处理请求时发生异常，将允许请求", e);
            // 限流器本身出现异常时，不能影响接口的功能，即异常时不限流
            return true;
        }
    }
    
    /**
     * 获取客户端IP地址
     * @param request HttpServletRequest
     * @return 客户端IP地址
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 如果是多个IP地址，取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
    
    /**
     * 处理限流请求，返回提示信息
     * @param response HttpServletResponse
     * @throws IOException IOException
     */
    private void handleRateLimit(HttpServletResponse response) throws IOException {
        response.setStatus(HttpServletResponse.SC_TOO_MANY_REQUESTS);
        response.setContentType(CONTENT_TYPE);
        PrintWriter writer = response.getWriter();
        writer.write(RATE_LIMIT_RESPONSE);
        writer.flush();
        writer.close();
    }
}