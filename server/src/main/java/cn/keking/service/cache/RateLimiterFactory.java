package cn.keking.service.cache;

import org.springframework.stereotype.Component;

/**
 * 限流器工厂类
 */
@Component
public class RateLimiterFactory {
    /**
     * 创建限流器实例
     * @return 限流器实例
     */
    public RateLimiter createRateLimiter() {
        // 当前默认使用基于内存的限流器
        // 后续如果需要支持分布式，可以在这里修改为创建RedisRateLimiter等其他实现
        return new MemoryRateLimiter();
    }
}
