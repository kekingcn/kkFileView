package cn.keking.service.cache;

/**
 * @author: keking
 * @since: 2023/10/10 10:00
 * @description: 限流器接口
 */
public interface RateLimiter {

    /**
     * 检查是否允许访问
     * @param key 限流键，通常是IP地址
     * @return true 允许访问，false 不允许访问
     */
    boolean allowAccess(String key);
}
