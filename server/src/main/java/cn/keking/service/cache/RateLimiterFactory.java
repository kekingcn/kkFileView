package cn.keking.service.cache;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * @author: keking
 * @since: 2023/10/10 10:20
 * @description: 限流器工厂类，使用工厂模式创建限流器实例
 */
@Component
public class RateLimiterFactory {

    // 限流周期（毫秒）
    @Value("${rate.limit.period:60000}")
    private long period;

    // 每个周期内的最大访问次数
    @Value("${rate.limit.max.count:10}")
    private int maxCount;

    /**
     * 创建限流器实例
     * @return 限流器实例
     */
    public RateLimiter createRateLimiter() {
        // 目前只支持基于内存的限流器
        // 后续支持Redis等第三方缓存时，只需要修改这里的实现
        return new MemoryRateLimiter(period, maxCount);
    }
}
