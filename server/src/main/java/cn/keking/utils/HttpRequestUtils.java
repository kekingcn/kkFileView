package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;
import org.apache.hc.client5.http.config.ConnectionConfig;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClientBuilder;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManagerBuilder;
import org.apache.hc.client5.http.ssl.DefaultClientTlsStrategy;
import org.apache.hc.client5.http.ssl.NoopHostnameVerifier;
import org.apache.hc.core5.http.io.SocketConfig;
import org.apache.hc.core5.pool.PoolConcurrencyPolicy;
import org.apache.hc.core5.pool.PoolReusePolicy;
import org.apache.hc.core5.util.TimeValue;
import org.apache.hc.core5.util.Timeout;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * HTTP请求工具类，统一处理HTTP请求逻辑
 * 优化版本：支持连接复用，减少开销
 */
public class HttpRequestUtils {

    private static final Logger logger = LoggerFactory.getLogger(HttpRequestUtils.class);
    private static final ObjectMapper mapper = new ObjectMapper();

    // 连接池管理器（静态变量，全局共享）
    private static volatile PoolingHttpClientConnectionManager connectionManager;

    // 用于缓存不同配置的HttpClient实例
    private static final Map<String, CloseableHttpClient> httpClientCache = new ConcurrentHashMap<>();

    // 用于缓存不同配置的RestTemplate实例
    private static final Map<String, RestTemplate> restTemplateCache = new ConcurrentHashMap<>();

    // 默认连接池配置
    private static final int DEFAULT_MAX_TOTAL = 200;           // 最大连接数
    private static final int DEFAULT_MAX_PER_ROUTE = 50;        // 每个路由最大连接数

    /**
     * 判断是否为客户端中断连接的异常
     */
    public static boolean isClientAbortException(Throwable e) {
        if (e == null) {
            return false;
        }

        // 检查异常链
        Throwable cause = e;
        while (cause != null) {
            // 检查异常消息
            if (cause instanceof IOException) {
                String message = cause.getMessage();
                if (message != null && (
                        message.contains("你的主机中的软件中止了一个已建立的连接") ||
                                message.contains("Broken pipe") ||
                                message.contains("Connection reset by peer") ||
                                message.contains("ClientAbortException"))) {
                    return true;
                }
            }

            // 检查异常类型
            String className = cause.getClass().getName();
            if (className.contains("ClientAbortException") ||
                    className.contains("AbortedException") ||
                    className.contains("AsyncRequestNotUsableException")) {
                return true;
            }

            cause = cause.getCause();
        }

        return false;
    }

    /**
     * 初始化连接池管理器（懒加载）
     */
    private static PoolingHttpClientConnectionManager getConnectionManager() throws Exception {
        if (connectionManager == null) {
            synchronized (HttpRequestUtils.class) {
                if (connectionManager == null) {
                    // 创建连接池管理器
                    PoolingHttpClientConnectionManagerBuilder builder = PoolingHttpClientConnectionManagerBuilder.create();

                    // 如果配置忽略SSL，使用自定义TLS策略
                    if (ConfigConstants.isIgnoreSSL()) {
                        SSLContext sslContext = SslUtils.createIgnoreVerifySSL();
                        DefaultClientTlsStrategy tlsStrategy = new DefaultClientTlsStrategy(
                                sslContext, NoopHostnameVerifier.INSTANCE);
                        builder.setTlsSocketStrategy(tlsStrategy);
                    }

                    // 设置连接池参数
                    builder.setPoolConcurrencyPolicy(PoolConcurrencyPolicy.LAX)
                            .setConnPoolPolicy(PoolReusePolicy.LIFO)
                            .setMaxConnTotal(DEFAULT_MAX_TOTAL)
                            .setMaxConnPerRoute(DEFAULT_MAX_PER_ROUTE);

                    // 设置Socket配置
                    SocketConfig socketConfig = SocketConfig.custom()
                            .setTcpNoDelay(true)
                            .setSoKeepAlive(true)
                            .setSoReuseAddress(true)
                            .setSoTimeout(Timeout.ofSeconds(30))
                            .build();
                    builder.setDefaultSocketConfig(socketConfig);

                    // 设置连接配置
                    ConnectionConfig connectionConfig = ConnectionConfig.custom()
                            .setConnectTimeout(Timeout.ofSeconds(10))
                            .setSocketTimeout(Timeout.ofSeconds(30))
                            .setTimeToLive(TimeValue.ofMinutes(5))
                            .build();
                    builder.setDefaultConnectionConfig(connectionConfig);

                    connectionManager = builder.build();

                    // 启动空闲连接清理线程
                    startIdleConnectionMonitor();

                    logger.info("HTTP连接池管理器初始化完成，最大连接数：{}，每个路由最大连接数：{}",
                            DEFAULT_MAX_TOTAL, DEFAULT_MAX_PER_ROUTE);
                }
            }
        }
        return connectionManager;
    }

    /**
     * 启动空闲连接监控线程
     */
    private static void startIdleConnectionMonitor() {
        Thread monitorThread = new Thread(() -> {
            try {
                while (!Thread.currentThread().isInterrupted()) {
                    synchronized (HttpRequestUtils.class) {
                        Thread.sleep(30000); // 每30秒检查一次
                        if (connectionManager != null) {
                            // 关闭过期的连接
                            connectionManager.closeExpired();
                            // 关闭空闲超过30秒的连接
                            connectionManager.closeIdle(TimeValue.ofSeconds(30));

                            // 可选：打印连接池状态
                            if (logger.isDebugEnabled()) {
                                logger.debug("连接池状态：最大连接数={}, 每个路由最大连接数={}",
                                        connectionManager.getMaxTotal(),
                                        connectionManager.getDefaultMaxPerRoute());
                            }
                        }
                    }
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                logger.info("连接池监控线程被中断");
            } catch (Exception e) {
                logger.error("连接池监控异常", e);
            }
        });

        monitorThread.setDaemon(true);
        monitorThread.setName("http-connection-monitor");
        monitorThread.start();
    }

    /**
     * 创建根据配置定制的HttpClient（支持复用）
     */
    public static CloseableHttpClient createConfiguredHttpClient() throws Exception {
        return createConfiguredHttpClient(ConfigConstants.isEnableRedirect());
    }

    private static CloseableHttpClient createConfiguredHttpClient(boolean enableRedirect) throws Exception {
        String cacheKey = buildHttpClientCacheKey(enableRedirect);

        // 尝试从缓存获取
        CloseableHttpClient cachedClient = httpClientCache.get(cacheKey);
        if (cachedClient != null) {
            // HttpClient 5.x 没有 isClosed() 方法，我们需要通过其他方式判断
            // 暂时假设缓存的客户端都是可用的，如果有问题会在使用时报错
            return cachedClient;
        }

        // 创建新的HttpClient
        synchronized (httpClientCache) {
            // 双重检查
            cachedClient = httpClientCache.get(cacheKey);
            if (cachedClient != null) {
                return cachedClient;
            }

            // 构建HttpClientBuilder
            HttpClientBuilder httpClientBuilder = HttpClients.custom()
                    .setConnectionManager(getConnectionManager())
                    .setConnectionManagerShared(true); // 共享连接管理器

            // 使用SslUtils配置HttpClientBuilder
            CloseableHttpClient httpClient = SslUtils.configureHttpClientBuilder(
                    httpClientBuilder,
                    ConfigConstants.isIgnoreSSL(),
                    enableRedirect
            ).build();

            // 缓存HttpClient
            httpClientCache.put(cacheKey, httpClient);
            logger.debug("创建并缓存新的HttpClient实例，缓存键：{}", cacheKey);

            return httpClient;
        }
    }

    /**
     * 构建HttpClient缓存键
     */
    private static String buildHttpClientCacheKey(boolean enableRedirect) {
        return String.format("ignoreSSL_%s_enableRedirect_%s",
                ConfigConstants.isIgnoreSSL(),
                enableRedirect);
    }

    /**
     * 获取缓存的RestTemplate（减少对象创建）
     */
    private static RestTemplate getCachedRestTemplate(CloseableHttpClient httpClient) {
        String cacheKey = "restTemplate_" + System.identityHashCode(httpClient);

        return restTemplateCache.computeIfAbsent(cacheKey, key -> {
            HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
            factory.setHttpClient(httpClient);

            // 设置连接超时和读取超时
            factory.setConnectTimeout(30000);
            factory.setReadTimeout(30000);

            RestTemplate restTemplate = new RestTemplate();
            restTemplate.setRequestFactory(factory);

            logger.debug("创建并缓存新的RestTemplate实例，缓存键：{}", cacheKey);
            return restTemplate;
        });
    }

    /**
     * 执行HTTP请求（使用连接池）
     */
    public static void executeHttpRequest(java.net.URL url, CloseableHttpClient httpClient,
                                          FileAttribute fileAttribute, FileResponseHandler handler) throws Exception {
        executeHttpRequest(url, httpClient, fileAttribute, handler, false);
    }

    /**
     * 执行HTTP请求（使用连接池）
     *
     * @param signFetch 是否按 signed.fetch.enabled 的配置附带取件令牌；只有 kkFileView 自己下载原文件时传 true
     */
    public static void executeHttpRequest(java.net.URL url, CloseableHttpClient httpClient,
                                          FileAttribute fileAttribute, FileResponseHandler handler,
                                          boolean signFetch) throws Exception {
        // 取件令牌只给原始地址：带令牌的这一次请求不自动跟随跳转，遇到跳转时在下面另发一次不带令牌的请求
        boolean signedFetch = signFetch && SignedPreviewUtils.isFetchSigningActive();
        if (signedFetch) {
            httpClient = createConfiguredHttpClient(false);
        }
        java.net.URI requestUri = url.toURI();
        java.net.URI[] redirectTarget = new java.net.URI[1];

        // 获取缓存的RestTemplate
        RestTemplate restTemplate = getCachedRestTemplate(httpClient);

        String finalUrlStr = url.toString();
        RequestCallback requestCallback = createRequestCallback(finalUrlStr, fileAttribute, signFetch);

        try {
            restTemplate.execute(requestUri, HttpMethod.GET, requestCallback, response -> {
                if (signedFetch && ConfigConstants.isEnableRedirect() && response.getStatusCode().is3xxRedirection()
                        && response.getHeaders().getLocation() != null) {
                    redirectTarget[0] = requestUri.resolve(response.getHeaders().getLocation());
                    return null;
                }
                FileResponseWrapper wrapper = new FileResponseWrapper();
                wrapper.setInputStream(response.getBody());
                wrapper.setContentType(WebUtils.headersType(response));

                try {
                    handler.handleResponse(wrapper);
                } catch (Exception e) {
                    // 如果是客户端中断连接，不再记录为错误
                    if (isClientAbortException(e)) {
                        if (logger.isDebugEnabled()) {
                            logger.debug("客户端中断连接，可能用户取消了下载，URL: {}", url);
                        }
                    } else {
                        logger.error("处理文件响应时出错", e);
                    }
                    try {
                        throw e;
                    } catch (Exception ex) {
                        throw new RuntimeException(ex);
                    }
                }
                return null;
            });
            if (redirectTarget[0] != null) {
                executeHttpRequest(redirectTarget[0].toURL(), createConfiguredHttpClient(), fileAttribute, handler, false);
            }
        } catch (Exception e) {
            // 如果是客户端中断连接，不再记录为错误
            if (isClientAbortException(e)) {
                if (logger.isDebugEnabled()) {
                    logger.debug("客户端中断连接，URL: {}", url);
                }
                throw e; // 重新抛出，让调用者处理
            }

            // 如果是SSL证书错误，给出建议
            if (e.getMessage() != null &&
                    (e.getMessage().contains("SSL") ||
                            e.getMessage().contains("证书") ||
                            e.getMessage().contains("certificate")) &&
                    !ConfigConstants.isIgnoreSSL()) {
                logger.warn("SSL证书验证失败，建议启用SSL忽略功能或检查证书");
            }
            throw e;
        }
        // 注意：不再关闭HttpClient，由连接池管理
    }

    /**
     * 创建请求回调
     */
    private static RequestCallback createRequestCallback(String finalUrlStr, FileAttribute fileAttribute, boolean signFetch) {
        return request -> {
            request.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
            WebUtils.applyBasicAuthHeaders(request.getHeaders(), finalUrlStr);

            // 添加Keep-Alive头
            request.getHeaders().set("Connection", "keep-alive");
            request.getHeaders().set("Keep-Alive", "timeout=60");

            String proxyAuthorization = fileAttribute.getKkProxyAuthorization();
            if (StringUtils.hasText(proxyAuthorization)) {
                Map<String, String> proxyAuthorizationMap = mapper.readValue(
                        proxyAuthorization,
                        TypeFactory.defaultInstance().constructMapType(Map.class, String.class, String.class)
                );
                proxyAuthorizationMap.forEach((key, value) -> request.getHeaders().set(key, value));
            }

            // 取原文件时附带签名令牌（默认关闭），放在最后：请求头配成 Authorization 时，
            // 上面的 basic 认证和转发来的请求头不会把它顶掉，以令牌为准
            String fetchToken = signFetch ? SignedPreviewUtils.issueFetchToken(request.getURI().toString()) : null;
            if (fetchToken != null) {
                request.getHeaders().set(ConfigConstants.getSignedFetchHeader(), SignedPreviewUtils.fetchHeaderValue(fetchToken));
            }
        };
    }

    /**
     * 清理资源（在应用关闭时调用）
     */
    public static void shutdown() {
        logger.info("开始清理HTTP连接池资源...");

        // 关闭所有缓存的HttpClient
        httpClientCache.values().forEach(client -> {
            try {
                client.close();
            } catch (Exception e) {
                logger.warn("关闭HttpClient失败", e);
            }
        });
        httpClientCache.clear();

        // 关闭连接池管理器
        if (connectionManager != null) {
            try {
                connectionManager.close();
                logger.info("HTTP连接池管理器已关闭");
            } catch (Exception e) {
                logger.warn("关闭连接池管理器失败", e);
            }
            connectionManager = null;
        }

        // 清空RestTemplate缓存
        restTemplateCache.clear();

        logger.info("HTTP连接池资源清理完成");
    }

    /**
     * 文件响应处理器接口
     */
    public interface FileResponseHandler {
        void handleResponse(FileResponseWrapper responseWrapper) throws Exception;
    }

    /**
     * 文件响应包装器
     */
    public static class FileResponseWrapper {
        private InputStream inputStream;
        private String contentType;
        private boolean hasError;

        public InputStream getInputStream() {
            return inputStream;
        }

        public void setInputStream(InputStream inputStream) {
            this.inputStream = inputStream;
        }

        public String getContentType() {
            return contentType;
        }

        public void setContentType(String contentType) {
            this.contentType = contentType;
        }

        public boolean isHasError() {
            return hasError;
        }

        public void setHasError(boolean hasError) {
            this.hasError = hasError;
        }
    }
}