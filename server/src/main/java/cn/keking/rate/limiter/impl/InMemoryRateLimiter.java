package cn.keking.rate.limiter.impl;

import cn.keking.rate.limiter.RateLimiter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 基于内存的限流器实现，使用滑动窗口算法
 * @author kl
 */
public class InMemoryRateLimiter implements RateLimiter {
    
    private static final Logger logger = LoggerFactory.getLogger(InMemoryRateLimiter.class);
    
    private final int maxRequests;
    private final int timeWindowSeconds;
    private final ConcurrentHashMap<String, Queue<Long>> requestTimestamps;
    private final ScheduledExecutorService scheduler;
    
    public InMemoryRateLimiter(int maxRequests, int timeWindowSeconds) {
        this.maxRequests = maxRequests;
        this.timeWindowSeconds = timeWindowSeconds;
        this.requestTimestamps = new ConcurrentHashMap<>();
        
        // 定期清理过期的IP记录
        this.scheduler = Executors.newSingleThreadScheduledExecutor();
        this.scheduler.scheduleAtFixedRate(() -> {
            try {
                long now = System.currentTimeMillis();
                long expireTime = now - timeWindowSeconds * 1000L;
                
                // 清理所有过期的请求时间戳
                requestTimestamps.forEach((ip, timestamps) -> {
                    synchronized (timestamps) {
                        while (!timestamps.isEmpty() && timestamps.peek() < expireTime) {
                            timestamps.poll();
                        }
                        // 如果队列已空，移除该IP记录
                        if (timestamps.isEmpty()) {
                            requestTimestamps.remove(ip);
                        }
                    }
                });
                
                logger.debug("已清理过期的IP访问记录，当前记录数: {}", requestTimestamps.size());
            } catch (Exception e) {
                logger.error("清理IP访问记录时发生异常", e);
            }
        }, 1, 1, TimeUnit.MINUTES); // 每分钟清理一次
    }
    
    @Override
    public boolean isAllowed(String key) {
        try {
            long now = System.currentTimeMillis();
            long expireTime = now - timeWindowSeconds * 1000L;
            
            Queue<Long> timestamps = requestTimestamps.computeIfAbsent(key, k -> new LinkedList<>());
            
            synchronized (timestamps) {
                // 清理过期的请求时间戳
                while (!timestamps.isEmpty() && timestamps.peek() < expireTime) {
                    timestamps.poll();
                }
                
                // 检查当前请求数是否超过限制
                if (timestamps.size() >= maxRequests) {
                    return false;
                }
                
                // 添加当前请求时间戳
                timestamps.offer(now);
                return true;
            }
        } catch (Exception e) {
            logger.error("限流器判断请求是否允许时发生异常，将允许请求", e);
            // 限流器本身出现异常时，不能影响接口的功能，即异常时不限流
            return true;
        }
    }
    
    /**
     * 关闭限流器，释放资源
     */
    public void shutdown() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdown();
            try {
                if (!scheduler.awaitTermination(1, TimeUnit.SECONDS)) {
                    scheduler.shutdownNow();
                }
            } catch (InterruptedException e) {
                scheduler.shutdownNow();
                Thread.currentThread().interrupt();
            }
        }
    }
}