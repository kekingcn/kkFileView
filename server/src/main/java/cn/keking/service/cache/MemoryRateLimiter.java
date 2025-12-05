package cn.keking.service.cache;

import cn.keking.config.ConfigConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 基于内存的限流器实现
 */
public class MemoryRateLimiter implements RateLimiter {
    private static final Logger LOGGER = LoggerFactory.getLogger(MemoryRateLimiter.class);

    private static class RateLimitInfo {
        private final AtomicInteger count;
        private final AtomicLong lastResetTime;

        RateLimitInfo() {
            this.count = new AtomicInteger(0);
            this.lastResetTime = new AtomicLong(System.currentTimeMillis());
        }
    }

    private final ConcurrentMap<String, RateLimitInfo> rateLimitMap = new ConcurrentHashMap<>();

    @Override
    public boolean allowAccess(String key) {
        try {
            int interval = ConfigConstants.getRateLimitInterval() * 1000; // 转换为毫秒
            int maxRequests = ConfigConstants.getRateLimitMaxRequests();

            RateLimitInfo info = rateLimitMap.computeIfAbsent(key, k -> new RateLimitInfo());

            long now = System.currentTimeMillis();
            // 如果超过了时间间隔，重置计数
            if (now - info.lastResetTime.get() > interval) {
                // 使用CAS操作确保只有一个线程能重置计数
                if (info.lastResetTime.compareAndSet(info.lastResetTime.get(), now)) {
                    info.count.set(0);
                }
            }

            // 如果计数超过了最大请求数，拒绝访问
            if (info.count.get() >= maxRequests) {
                LOGGER.warn("Rate limit exceeded for key: {}", key);
                return false;
            }

            // 计数加1
            info.count.incrementAndGet();
            return true;
        } catch (Exception e) {
            LOGGER.error("Error in rate limiting", e);
            // 异常时不限流
            return true;
        }
    }
}
