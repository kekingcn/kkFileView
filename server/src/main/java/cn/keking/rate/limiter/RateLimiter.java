package cn.keking.rate.limiter;

/**
 * 限流器接口
 * @author kl
 */
public interface RateLimiter {
    
    /**
     * 判断是否允许请求
     * @param key 请求标识，这里使用IP地址
     * @return 是否允许请求
     */
    boolean isAllowed(String key);
}