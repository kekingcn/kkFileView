package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicReference;

import static cn.keking.SignedPreviewTestSupport.*;
import static org.junit.jupiter.api.Assertions.*;

class SignedFetchTests {

    private HttpServer server;
    private final AtomicReference<Map<String, List<String>>> receivedHeaders = new AtomicReference<>();
    /** 按请求路径记下每次收到的请求头，用来分清跳转前后的两次请求。 */
    private final Map<String, Map<String, List<String>>> headersByPath = new ConcurrentHashMap<>();
    private Boolean previousIgnoreSsl;
    private Boolean previousEnableRedirect;

    @BeforeEach
    void setup() throws Exception {
        previousIgnoreSsl = (Boolean) org.springframework.test.util.ReflectionTestUtils.getField(ConfigConstants.class, "ignoreSSL");
        previousEnableRedirect = (Boolean) org.springframework.test.util.ReflectionTestUtils.getField(ConfigConstants.class, "enableRedirect");
        ConfigConstants.setIgnoreSSLValue(false);
        ConfigConstants.setEnableRedirectValue(false);
        resetConfig();
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
        ConfigConstants.setSignedFetchEnabledValue(true);

        server = HttpServer.create(new InetSocketAddress(InetAddress.getLoopbackAddress(), 0), 0);
        server.createContext("/", exchange -> {
            receivedHeaders.set(Map.copyOf(exchange.getRequestHeaders()));
            headersByPath.put(exchange.getRequestURI().getPath(), Map.copyOf(exchange.getRequestHeaders()));
            if (exchange.getRequestURI().getPath().startsWith("/moved/")) {
                exchange.getResponseHeaders().set("Location", "/target.txt");
                exchange.sendResponseHeaders(302, -1);
                exchange.close();
                return;
            }
            byte[] body = "plain text".getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "text/plain");
            exchange.sendResponseHeaders(200, body.length);
            exchange.getResponseBody().write(body);
            exchange.close();
        });
        server.start();
    }

    @AfterEach
    void restore() {
        server.stop(0);
        ConfigConstants.setIgnoreSSLValue(previousIgnoreSsl);
        ConfigConstants.setEnableRedirectValue(previousEnableRedirect);
        resetConfig();
    }

    private String fileUrl(String path) {
        return "http://127.0.0.1:" + server.getAddress().getPort() + path;
    }

    /** 发一次请求，返回文件来源那一方在指定请求头里收到的值（没收到为 null）。 */
    private String fetch(String url, Boolean signFetch, String headerName) throws Exception {
        receivedHeaders.set(null);
        HttpRequestUtils.FileResponseHandler handler = wrapper -> wrapper.getInputStream().readAllBytes();
        if (signFetch == null) {
            HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), new FileAttribute(), handler);
        } else {
            HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), new FileAttribute(), handler, signFetch);
        }
        return received(headerName);
    }

    private String received(String headerName) {
        return header(receivedHeaders.get(), headerName);
    }

    private static String header(Map<String, List<String>> headers, String headerName) {
        assertNotNull(headers, "文件来源一方应当收到请求");
        return headers.entrySet().stream()
                .filter(entry -> entry.getKey().equalsIgnoreCase(headerName))
                .map(entry -> entry.getValue().get(0)).findFirst().orElse(null);
    }

    @Test
    void fetchCarriesATokenTheFileSourceCanVerifyWithTheSameSecret() throws Exception {
        ConfigConstants.setSignedPreviewTtlValue(120);
        String url = fileUrl("/doc/report.txt?id=42");
        String header = fetch(url, true, "kk-fetch-token");
        assertNotNull(header, "开启后取原文件的请求应带上令牌");

        Map<String, Object> claims = verified(header);
        assertEquals("fetch", claims.get("use"));
        assertEquals(url, claims.get("url"), "令牌里写的是这一次请求的地址");
        long exp = ((Number) claims.get("exp")).longValue();
        assertTrue(exp >= now() + 110 && exp <= now() + 125, "有效期按 signed.preview.ttl 算：" + (exp - now()));
    }

    @Test
    void fetchHeaderNameIsConfigurable() throws Exception {
        ConfigConstants.setSignedFetchHeaderValue("X-Preview-Signature");
        String url = fileUrl("/a.txt");
        assertEquals(url, verified(fetch(url, true, "X-Preview-Signature")).get("url"));
        assertNull(received("kk-fetch-token"));
    }

    @Test
    void fetchTokenCanCarryTheUrlInANestedField() throws Exception {
        ConfigConstants.setSignedFetchClaimUrlValue("payload.source.url");
        String url = fileUrl("/a.txt");
        Map<String, Object> claims = verified(fetch(url, true, "kk-fetch-token"));
        assertEquals(Map.of("source", Map.of("url", url)), claims.get("payload"));
        assertNull(claims.get("url"), "配了嵌套位置之后，顶层不再放地址");
        assertEquals("fetch", claims.get("use"));
    }

    @Test
    void fetchHeaderValueCanCarryAPrefix() throws Exception {
        ConfigConstants.setSignedFetchHeaderPrefixValue("Bearer");
        String url = fileUrl("/a.txt");
        assertEquals(url, verifiedBearer(fetch(url, true, "kk-fetch-token")).get("url"));
        // 配置值两头的空格不影响，前缀与令牌之间固定一个空格
        ConfigConstants.setSignedFetchHeaderPrefixValue(" Bearer ");
        assertEquals(url, verifiedBearer(fetch(url, true, "kk-fetch-token")).get("url"));
    }

    @Test
    void signedFetchOwnsTheAuthorizationHeaderWhenConfiguredToUseIt() throws Exception {
        // 地址上的 basic 认证参数、转发的 kk-proxy-authorization 都会往 Authorization 上写
        String url = fileUrl("/a.txt?basic.name=alice&basic.pass=secret");
        FileAttribute attribute = new FileAttribute();
        attribute.setKkProxyAuthorization("{\"authorization\":\"Basic Zm9yd2FyZGVkOng=\",\"X-Forwarded-Extra\":\"kept\"}");
        HttpRequestUtils.FileResponseHandler handler = wrapper -> wrapper.getInputStream().readAllBytes();

        // 对照：请求头是别的名字时，这些逻辑照旧，Authorization 上是转发来的那个
        HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), attribute, handler, true);
        assertEquals("Basic Zm9yd2FyZGVkOng=", received("Authorization"));
        assertEquals(url, verified(received("kk-fetch-token")).get("url"));

        // 请求头配成 Authorization：以取件令牌为准，只有一个值；别的转发头不受影响
        ConfigConstants.setSignedFetchHeaderValue("Authorization");
        ConfigConstants.setSignedFetchHeaderPrefixValue("Bearer");
        HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), attribute, handler, true);
        assertEquals(1, receivedHeaders.get().entrySet().stream()
                .filter(entry -> entry.getKey().equalsIgnoreCase("Authorization")).mapToInt(entry -> entry.getValue().size()).sum());
        assertEquals(url, verifiedBearer(received("Authorization")).get("url"));
        assertEquals("kept", received("X-Forwarded-Extra"));

        // 不签名的请求（代浏览器取文件）不受这两项配置影响
        HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), attribute, handler, false);
        assertEquals("Basic Zm9yd2FyZGVkOng=", received("Authorization"));
    }

    @Test
    void fetchIsUnsignedWhenSwitchedOffOrSecretMissing() throws Exception {
        ConfigConstants.setSignedFetchEnabledValue(false);
        assertNull(fetch(fileUrl("/a.txt"), true, "kk-fetch-token"), "默认关闭时不带");

        // 与签名预览是两个各自独立的开关
        ConfigConstants.setSignedPreviewEnabledValue(true);
        assertNull(fetch(fileUrl("/a.txt"), true, "kk-fetch-token"));

        ConfigConstants.setSignedFetchEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_SECRET);
        assertNull(fetch(fileUrl("/a.txt"), true, "kk-fetch-token"), "没配密钥时不带");
    }

    @Test
    void requestsMadeOnBehalfOfTheBrowserAreNeverSigned() throws Exception {
        // /getCorsFile 用的是不带最后一个参数的旧方法
        assertNull(fetch(fileUrl("/a.txt"), null, "kk-fetch-token"));
        assertNull(fetch(fileUrl("/a.txt"), false, "kk-fetch-token"));
    }

    @Test
    void redirectTargetDoesNotReceiveTheFetchToken() throws Exception {
        ConfigConstants.setEnableRedirectValue(true);
        String url = fileUrl("/moved/report.txt");
        AtomicReference<String> body = new AtomicReference<>();
        HttpRequestUtils.executeHttpRequest(new URL(url), HttpRequestUtils.createConfiguredHttpClient(), new FileAttribute(),
                wrapper -> body.set(new String(wrapper.getInputStream().readAllBytes(), StandardCharsets.UTF_8)), true);

        assertEquals("plain text", body.get(), "跳转照常跟随，拿到的是跳转之后的内容");
        assertEquals(url, verified(header(headersByPath.get("/moved/report.txt"), "kk-fetch-token")).get("url"),
                "原始地址那一方收到令牌");
        assertNotNull(headersByPath.get("/target.txt"), "跳转目标应当被请求到");
        assertNull(header(headersByPath.get("/target.txt"), "kk-fetch-token"), "令牌只给原始地址，不带到跳转目标");
    }

    @Test
    void redirectHandlingIsUnchangedWhenFetchIsNotSigned() throws Exception {
        // 取件签名关着：允许跳转时跟过去，不允许时把 3xx 的响应原样交给调用方，两种都不带令牌
        ConfigConstants.setSignedFetchEnabledValue(false);
        for (boolean enableRedirect : new boolean[]{true, false}) {
            ConfigConstants.setEnableRedirectValue(enableRedirect);
            headersByPath.clear();
            AtomicReference<String> body = new AtomicReference<>();
            HttpRequestUtils.executeHttpRequest(new URL(fileUrl("/moved/report.txt")), HttpRequestUtils.createConfiguredHttpClient(),
                    new FileAttribute(), wrapper -> body.set(new String(wrapper.getInputStream().readAllBytes(), StandardCharsets.UTF_8)), true);
            assertEquals(enableRedirect ? "plain text" : "", body.get());
            assertEquals(enableRedirect, headersByPath.containsKey("/target.txt"));
            assertNull(header(headersByPath.get("/moved/report.txt"), "kk-fetch-token"));
        }
    }

    @Test
    void signedFetchDoesNotFollowRedirectsWhenRedirectsAreDisabled() throws Exception {
        ConfigConstants.setEnableRedirectValue(false);
        AtomicReference<String> body = new AtomicReference<>();
        HttpRequestUtils.executeHttpRequest(new URL(fileUrl("/moved/report.txt")), HttpRequestUtils.createConfiguredHttpClient(),
                new FileAttribute(), wrapper -> body.set(new String(wrapper.getInputStream().readAllBytes(), StandardCharsets.UTF_8)), true);
        assertEquals("", body.get(), "与不签名时一样，把 3xx 的响应原样交给调用方");
        assertFalse(headersByPath.containsKey("/target.txt"));
        assertNotNull(header(headersByPath.get("/moved/report.txt"), "kk-fetch-token"));
    }

    @Test
    void downloadingTheOriginalFileSignsTheFetch() {
        String name = "signed-fetch-" + UUID.randomUUID() + ".txt";
        String url = fileUrl("/doc/" + name);
        FileAttribute attribute = new FileAttribute();
        attribute.setSuffix("txt");
        attribute.setName(name);
        attribute.setUrl(url);
        ReturnResponse<String> response = DownloadUtils.downLoad(attribute, name);
        try {
            assertTrue(response.isSuccess(), response.getMsg());
            assertEquals(url, verified(received("kk-fetch-token")).get("url"));
        } finally {
            if (response.getContent() != null) {
                new File(response.getContent()).delete();
            }
        }
    }
}
