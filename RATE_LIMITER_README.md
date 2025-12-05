# 限流器实现说明

## 概述

本项目实现了一个基于IP地址的简化版限流器，应用于文件预览系统的/onlinePreview接口，用于防止系统因同时访问的请求过多而导致资源不足。

## 实现步骤

### 1. 配置参数添加

在`ConfigConstants.java`中添加了以下限流参数：
- `rateLimitMaxRequests`：每个IP地址在指定时间窗口内的最大请求数，默认值为100
- `rateLimitTimeWindowSeconds`：时间窗口大小，单位为秒，默认值为60

### 2. 配置刷新支持

在`ConfigRefreshComponent.java`中添加了对限流参数的读取和更新支持，实现了配置的动态刷新。

### 3. 限流器核心逻辑

创建了以下核心类：
- `RateLimiter`：限流器接口，定义了`isAllowed`方法
- `InMemoryRateLimiter`：基于内存的限流器实现，使用`ConcurrentHashMap`存储IP地址的访问次数
- `RateLimiterFactory`：限流器工厂类，使用工厂模式创建不同类型的限流器实例

### 4. 拦截器实现

创建了`RateLimitInterceptor`拦截器，用于拦截/onlinePreview接口的请求，并使用限流器进行限流。

### 5. 拦截器注册

在`WebConfig.java`中注册了限流器拦截器，只拦截/onlinePreview接口的请求。

## 使用方法

### 1. 配置限流参数

在`config/application.properties`文件中添加以下配置参数：

```properties
# 每个IP地址在指定时间窗口内的最大请求数
rate.limit.max.requests=100
# 时间窗口大小，单位为秒
rate.limit.time.window.seconds=60
```

### 2. 重启应用

配置参数生效需要重启应用。

## 后续扩展

### 支持Redis限流器

如果需要支持分布式部署，可以添加Redis限流器实现：

1. 创建`RedisRateLimiter`类，实现`RateLimiter`接口
2. 在`RateLimiterFactory`中添加Redis限流器的创建逻辑
3. 配置Redis连接参数

### 支持其他类型的限流器

可以根据需要添加其他类型的限流器，如基于令牌桶算法的限流器等。

## 异常处理

限流器本身出现异常时，会自动允许请求，不会影响接口的功能。

## 性能考虑

- 使用`ConcurrentHashMap`存储IP地址的访问次数，保证线程安全
- 使用定时任务定期清理过期的IP记录，避免内存溢出
- 限流器的判断逻辑简单高效，不会对系统性能造成明显影响
