package cn.keking.rate.limiter;

import cn.keking.config.ConfigConstants;
import cn.keking.rate.limiter.impl.InMemoryRateLimiter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 限流器工厂类，使用工厂模式创建不同类型的限流器实例
 * @author kl
 */
public class RateLimiterFactory {
    
    private static final Logger logger = LoggerFactory.getLogger(RateLimiterFactory.class);
    
    private static final String TYPE_IN_MEMORY = "inMemory";
    private static volatile RateLimiter instance;
    
    /**
     * 获取限流器实例
     * @return 限流器实例
     */
    public static RateLimiter getRateLimiter() {
        return getRateLimiter(TYPE_IN_MEMORY);
    }
    
    /**
     * 根据类型获取限流器实例
     * @param type 限流器类型
     * @return 限流器实例
     */
    public static RateLimiter getRateLimiter(String type) {
        if (instance == null) {
            synchronized (RateLimiterFactory.class) {
                if (instance == null) {
                    instance = createRateLimiter(type);
                }
            }
        }
        return instance;
    }
    
    /**
     * 创建限流器实例
     * @param type 限流器类型
     * @return 限流器实例
     */
    private static RateLimiter createRateLimiter(String type) {
        int maxRequests = ConfigConstants.getRateLimitMaxRequests();
        int timeWindowSeconds = ConfigConstants.getRateLimitTimeWindowSeconds();
        
        logger.info("创建限流器实例，类型: {}, 最大请求数: {}, 时间窗口: {}秒", type, maxRequests, timeWindowSeconds);
        
        switch (type) {
            case TYPE_IN_MEMORY:
                return new InMemoryRateLimiter(maxRequests, timeWindowSeconds);
            // 后续可以添加其他类型的限流器，如Redis限流器
            // case TYPE_REDIS:
            //     return new RedisRateLimiter(maxRequests, timeWindowSeconds);
            default:
                logger.warn("未知的限流器类型: {}, 将使用默认的内存限流器", type);
                return new InMemoryRateLimiter(maxRequests, timeWindowSeconds);
        }
    }
}