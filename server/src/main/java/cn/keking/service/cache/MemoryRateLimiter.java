package cn.keking.service.cache;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @author: keking
 * @since: 2023/10/10 10:10
 * @description: 基于内存的限流器实现
 */
public class MemoryRateLimiter implements RateLimiter {

    private static final Logger LOGGER = LoggerFactory.getLogger(MemoryRateLimiter.class);

    // 存储IP地址的访问次数和时间戳
    private final ConcurrentMap<String, RateLimitInfo> ipAccessMap = new ConcurrentHashMap<>();

    // 限流周期（毫秒）
    private final long period;

    // 每个周期内的最大访问次数
    private final int maxCount;

    public MemoryRateLimiter(long period, int maxCount) {
        this.period = period;
        this.maxCount = maxCount;
    }

    @Override
    public boolean allowAccess(String key) {
        try {
            long currentTime = System.currentTimeMillis();

            // 使用compute方法确保线程安全
            RateLimitInfo rateLimitInfo = ipAccessMap.compute(key, (k, v) -> {
                if (v == null) {
                    // 首次访问，创建记录
                    return new RateLimitInfo(currentTime, 1);
                } else {
                    if (currentTime - v.getLastAccessTime() > period) {
                        // 超过周期，重置访问次数，直接允许访问
                        return new RateLimitInfo(currentTime, 1);
                    } else if (v.getAccessCount() < maxCount) {
                        // 未超过最大访问次数，增加访问次数
                        return new RateLimitInfo(v.getLastAccessTime(), v.getAccessCount() + 1);
                    } else {
                        // 超过最大访问次数，保持原有记录不变
                        return v;
                    }
                }
            });

            // 检查是否允许访问
            if (currentTime - rateLimitInfo.getLastAccessTime() > period) {
                // 超过周期，允许访问
                return true;
            } else {
                // 未超过周期，检查访问次数
                return rateLimitInfo.getAccessCount() <= maxCount;
            }
        } catch (Exception e) {
            LOGGER.error("限流检查发生异常: {}, 不限流直接允许访问", e.getMessage(), e);
            // 异常时不限流
            return true;
        }
    }

    // 限流信息类，使用volatile关键字确保线程可见性
    private static class RateLimitInfo {
        private volatile long lastAccessTime;
        private volatile int accessCount;

        public RateLimitInfo(long lastAccessTime, int accessCount) {
            this.lastAccessTime = lastAccessTime;
            this.accessCount = accessCount;
        }

        public long getLastAccessTime() {
            return lastAccessTime;
        }

        public void setLastAccessTime(long lastAccessTime) {
            this.lastAccessTime = lastAccessTime;
        }

        public int getAccessCount() {
            return accessCount;
        }

        public void setAccessCount(int accessCount) {
            this.accessCount = accessCount;
        }
    }
}
