package cn.keking;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.WebUtils;
import cn.keking.web.filter.SignedPreviewFilter;
import com.sun.net.httpserver.HttpServer;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.util.ReflectionTestUtils;

import java.io.File;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;

import static cn.keking.SignedPreviewTestSupport.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * 把签名预览整套配成另一种令牌格式（接入方已有自己的字段名、用途值、取件请求头写法），
 * 从预览入口到下载原文件走一遍：接入方那一侧不用为 kkFileView 改签发和校验的写法。
 */
class SignedPreviewCustomFormatTests {

    private HttpServer fileSource;
    private final AtomicReference<Map<String, List<String>>> receivedHeaders = new AtomicReference<>();
    private Boolean previousIgnoreSsl;
    private Boolean previousEnableRedirect;

    @BeforeEach
    void setup() throws Exception {
        previousIgnoreSsl = (Boolean) ReflectionTestUtils.getField(ConfigConstants.class, "ignoreSSL");
        previousEnableRedirect = (Boolean) ReflectionTestUtils.getField(ConfigConstants.class, "enableRedirect");
        ConfigConstants.setIgnoreSSLValue(false);
        ConfigConstants.setEnableRedirectValue(false);
        resetConfig();
        ConfigConstants.setSignedPreviewEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
        // 预览令牌：参数名、字段名、用途值都是接入方自己的，且必须写用途
        ConfigConstants.setSignedPreviewTokenParamValue("accessToken");
        ConfigConstants.setSignedPreviewClaimUrlValue("fileUrl");
        ConfigConstants.setSignedPreviewClaimWatermarkValue("mark");
        ConfigConstants.setSignedPreviewClaimUseValue("kind");
        ConfigConstants.setSignedPreviewUsePreviewValue("view");
        ConfigConstants.setSignedPreviewUseArchiveValue("pack");
        ConfigConstants.setSignedPreviewUseFetchValue("pull");
        ConfigConstants.setSignedPreviewUseRequiredValue(true);
        ConfigConstants.setSignedPreviewAllowParamsValue("officePreviewType=image|pdf,page");
        // 取件令牌：Authorization: Bearer <令牌>，地址在 payload.url，120 秒有效
        ConfigConstants.setSignedFetchEnabledValue(true);
        ConfigConstants.setSignedFetchHeaderValue("Authorization");
        ConfigConstants.setSignedFetchHeaderPrefixValue("Bearer");
        ConfigConstants.setSignedFetchClaimUrlValue("payload.url");
        ConfigConstants.setSignedFetchTtlValue("120");

        fileSource = HttpServer.create(new InetSocketAddress(InetAddress.getLoopbackAddress(), 0), 0);
        fileSource.createContext("/", exchange -> {
            receivedHeaders.set(Map.copyOf(exchange.getRequestHeaders()));
            byte[] body = "content of the original file".getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().set("Content-Type", "text/plain");
            exchange.sendResponseHeaders(200, body.length);
            exchange.getResponseBody().write(body);
            exchange.close();
        });
        fileSource.start();
    }

    @AfterEach
    void restore() {
        fileSource.stop(0);
        ConfigConstants.setIgnoreSSLValue(previousIgnoreSsl);
        ConfigConstants.setEnableRedirectValue(previousEnableRedirect);
        resetConfig();
    }

    private HttpServletRequest throughFilter(MockHttpServletRequest request) throws Exception {
        MockHttpServletResponse response = new MockHttpServletResponse();
        HttpServletRequest[] reached = new HttpServletRequest[1];
        new SignedPreviewFilter().doFilter(request, response, (req, res) -> reached[0] = (HttpServletRequest) req);
        assertEquals(response.getStatus() == 200, reached[0] != null);
        return reached[0];
    }

    private String receivedHeader(String name) {
        return receivedHeaders.get().entrySet().stream().filter(entry -> entry.getKey().equalsIgnoreCase(name))
                .map(entry -> entry.getValue().get(0)).findFirst().orElse(null);
    }

    @Test
    void previewAndFetchWorkEndToEndInAnotherTokenFormat() throws Exception {
        String name = "custom-format-" + UUID.randomUUID() + ".txt";
        String fileUrl = "http://127.0.0.1:" + fileSource.getAddress().getPort() + "/doc/" + name;

        // 1. 预览入口：接入方格式的令牌通过，参数按令牌和带取值限定的放行名单重建
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setParameter("accessToken", token("kind", "view", "fileUrl", fileUrl, "mark", "李四 0034", "exp", now() + 300));
        request.setParameter("url", base64("http://127.0.0.1:1/another.txt"));
        request.setParameter("officePreviewType", "image");
        request.setParameter("page", "2");
        request.setParameter("highlightall", "true");
        HttpServletRequest reached = throughFilter(request);
        assertNotNull(reached);
        assertEquals(fileUrl, unbase64(reached.getParameter("url")));
        assertEquals("李四 0034", reached.getParameter("watermarkTxt"));
        assertEquals("image", reached.getParameter("officePreviewType"));
        assertEquals("2", reached.getParameter("page"));
        assertNull(reached.getParameter("highlightall"));

        // 不写用途的、用缺省格式签的、放在缺省参数名里的，都不通过
        request.setParameter("accessToken", token("fileUrl", fileUrl, "exp", now() + 300));
        assertNull(throughFilter(request));
        request.setParameter("accessToken", token("use", "preview", "url", fileUrl, "exp", now() + 300));
        assertNull(throughFilter(request));
        request.removeParameter("accessToken");
        request.setParameter("token", token("kind", "view", "fileUrl", fileUrl, "exp", now() + 300));
        assertNull(throughFilter(request));
        // 值不在放行名单里的参数被丢掉，请求照常通过
        request.removeParameter("token");
        request.setParameter("accessToken", token("kind", "view", "fileUrl", fileUrl, "exp", now() + 300));
        request.setParameter("officePreviewType", "allImages");
        assertNull(throughFilter(request).getParameter("officePreviewType"));

        // 2. 取原文件：用入口交出来的地址去下载，文件来源收到的是它自己那种写法的请求头
        FileAttribute attribute = new FileAttribute();
        attribute.setSuffix("txt");
        attribute.setName(name);
        attribute.setUrl(WebUtils.decodeUrl(reached.getParameter("url"), reached.getParameter("encryption")));
        ReturnResponse<String> response = DownloadUtils.downLoad(attribute, name);
        try {
            assertTrue(response.isSuccess(), response.getMsg());
            assertEquals("content of the original file", Files.readString(new File(response.getContent()).toPath()));
            assertNull(receivedHeader("kk-fetch-token"));
            Map<String, Object> claims = verifiedBearer(receivedHeader("Authorization"));
            assertEquals("pull", claims.get("kind"));
            assertEquals(Map.of("url", fileUrl), claims.get("payload"));
            assertNull(claims.get("url"));
            assertNull(claims.get("use"));
            assertEquals(120L, ((Number) claims.get("exp")).longValue() - ((Number) claims.get("iat")).longValue());
        } finally {
            if (response.getContent() != null) {
                new File(response.getContent()).delete();
            }
        }
    }
}
