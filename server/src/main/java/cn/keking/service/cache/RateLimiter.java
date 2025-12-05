package cn.keking.service.cache;

/**
 * 限流器接口
 */
public interface RateLimiter {
    /**
     * 检查是否允许访问
     * @param key 限流键，通常是IP地址
     * @return 是否允许访问
     */
    boolean allowAccess(String key);
}
