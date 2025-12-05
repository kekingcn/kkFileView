package cn.keking.web.filter;

import cn.keking.service.cache.RateLimiter;
import cn.keking.service.cache.RateLimiterFactory;
import cn.keking.utils.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * @author: keking
 * @since: 2023/10/10 10:30
 * @description: 基于IP地址的限流过滤器
 */
@Component
public class RateLimitFilter implements Filter {

    private static final Logger LOGGER = LoggerFactory.getLogger(RateLimitFilter.class);

    private RateLimiter rateLimiter;

    @Autowired
    private RateLimiterFactory rateLimiterFactory;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化限流器
        rateLimiter = rateLimiterFactory.createRateLimiter();
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        // 获取用户的IP地址
        String ipAddress = WebUtils.getIpAddress(request);
        LOGGER.debug("用户IP地址: {}", ipAddress);

        // 检查是否允许访问
        boolean allowAccess = rateLimiter.allowAccess(ipAddress);
        if (allowAccess) {
            // 允许访问，继续执行后续过滤器
            filterChain.doFilter(request, response);
        } else {
            // 拒绝访问，返回提示信息
            LOGGER.warn("用户IP地址: {} 请求太频繁，已拒绝访问", ipAddress);
            response.setContentType("text/plain;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_TOO_MANY_REQUESTS);
            PrintWriter writer = response.getWriter();
            writer.write("请求太频繁，请稍后再试");
            writer.flush();
            writer.close();
        }
    }

    @Override
    public void destroy() {
        // 销毁方法，目前不需要实现
    }
}
