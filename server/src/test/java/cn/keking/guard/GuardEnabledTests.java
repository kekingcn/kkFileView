package cn.keking.guard;

import cn.keking.config.ConfigConstants;
import com.sun.net.httpserver.HttpServer;
import jakarta.servlet.Filter;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.core.Ordered;
import org.springframework.test.context.TestPropertySource;
import org.springframework.web.util.ContentCachingResponseWrapper;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.URLEncoder;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Path;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Guard Core switched on with the shipped configuration, plus small budgets so the limits can be reached in a test. */
@TestPropertySource(properties = {
        "guard.enabled=true",
        "guard.trusted-proxies=127.0.0.1",
        "guard.rate-limit=8",
        "guard.endpoint-rate-limits[/picturesPreview].requests=3",
        "guard.auto-ban-threshold=3",
        // a list in a test property source replaces the whole configured list, so the rule is repeated in full
        "guard.global-behavior-rules[0].rule-type=return_pattern",
        "guard.global-behavior-rules[0].pattern=status:404",
        "guard.global-behavior-rules[0].threshold=3",
        "guard.global-behavior-rules[0].window=300",
        "guard.global-behavior-rules[0].action=ban",
        "guard.global-behavior-rules[0].ban-duration=3600"
})
class GuardEnabledTests extends GuardHttpTestSupport {

    private static final int CHUNK_BYTES = 1024 * 1024;
    private static final Map<String, String> RESPONSE_TYPES = new ConcurrentHashMap<>();

    @TempDir
    static Path fileDir;
    private static String previousFileDir;
    private static HttpServer upstream;
    private static final CountDownLatch RELEASE_REST_OF_FILE = new CountDownLatch(1);

    /** Records which response object the application receives, so a caching wrapper would be visible. */
    @TestConfiguration
    static class ResponseTypeProbe {
        @Bean
        FilterRegistrationBean<Filter> responseTypeProbeFilter() {
            FilterRegistrationBean<Filter> registration = new FilterRegistrationBean<>((request, response, chain) -> {
                RESPONSE_TYPES.put(((HttpServletRequest) request).getRequestURI(),
                        response instanceof ContentCachingResponseWrapper ? "buffered" : "streamed");
                chain.doFilter(request, response);
            });
            registration.setOrder(Ordered.LOWEST_PRECEDENCE);
            return registration;
        }
    }

    @BeforeEach
    void previewAnyHostIntoTheTemporaryDirectory() {
        // The application re-reads its configuration file while starting, so this is set after the context is up.
        ConfigConstants.setTrustHostValue("*");
        ConfigConstants.setFileDirValue(fileDir.toString());
    }

    @BeforeAll
    static void startUpstream() throws Exception {
        previousFileDir = ConfigConstants.getFileDir();
        upstream = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
        upstream.createContext("/hello.png", exchange -> {
            byte[] body = "hello from the intranet".getBytes(StandardCharsets.UTF_8);
            exchange.getResponseHeaders().add("Content-Type", "image/png");
            exchange.sendResponseHeaders(200, body.length);
            try (OutputStream out = exchange.getResponseBody()) {
                out.write(body);
            }
        });
        upstream.createContext("/missing", exchange -> {
            exchange.sendResponseHeaders(404, -1);
            exchange.close();
        });
        upstream.createContext("/big.pdf", exchange -> {
            exchange.getResponseHeaders().add("Content-Type", "application/pdf");
            exchange.sendResponseHeaders(200, 0);
            try (OutputStream out = exchange.getResponseBody()) {
                byte[] chunk = new byte[CHUNK_BYTES];
                out.write(chunk);
                out.flush();
                try {
                    RELEASE_REST_OF_FILE.await(60, TimeUnit.SECONDS);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
                for (int i = 0; i < 7; i++) {
                    out.write(chunk);
                }
            }
        });
        upstream.start();
    }

    @AfterAll
    static void stopUpstreamAndRestoreConfiguration() {
        RELEASE_REST_OF_FILE.countDown();
        upstream.stop(0);
        ConfigConstants.setTrustHostValue("default");
        ConfigConstants.setFileDirValue(previousFileDir);
    }

    private static String upstreamUrl(String path) {
        return "http://127.0.0.1:" + upstream.getAddress().getPort() + path;
    }

    @Test
    void globalBudgetGivesTooManyRequests() throws Exception {
        String client = newClientIp();
        for (int i = 0; i < 8; i++) {
            assertEquals(200, status("/index", client), "request " + i);
        }
        assertEquals(429, status("/index", client));
        assertEquals(200, status("/index", newClientIp()), "another client keeps its own budget");
    }

    @Test
    void expensiveEndpointHasItsOwnSmallerBudget() throws Exception {
        String client = newClientIp();
        for (int i = 0; i < 3; i++) {
            assertNotEquals(429, status("/picturesPreview", client), "request " + i);
        }
        assertEquals(429, status("/picturesPreview", client));
        assertEquals(200, status("/index", client), "the other routes are still within the global budget");
    }

    @Test
    void traversalAndXssInTheQueryAreRejected() throws Exception {
        assertEquals(400, status("/index?file=../../../../etc/passwd", newClientIp()));
        assertEquals(400, status("/index?q=%3Cscript%3Ealert(1)%3C/script%3E", newClientIp()));
        assertEquals(400, status("/index?x=1%27%20OR%201%3D1--", newClientIp()));
    }

    @Test
    void traversalInAFormBodyFieldIsRejected() throws Exception {
        assertEquals(400, postForm("/listFiles", newClientIp(), "path=../../../../etc&page=0&size=5").statusCode());
        assertEquals(200, postForm("/listFiles", newClientIp(), "path=&page=0&size=5").statusCode());
    }

    @Test
    void scannerPathIsRejected() throws Exception {
        assertEquals(400, status("/wp-login.php", newClientIp()));
    }

    @Test
    void clientThatKeepsProbingIsBanned() throws Exception {
        String attacker = newClientIp();
        assertEquals(400, status("/index?file=../../../../etc/passwd", attacker));
        for (int i = 0; i < 2; i++) {
            status("/index?file=../../../../etc/passwd", attacker);
        }
        assertEquals(403, status("/index", attacker), "banned after repeated attacks");
        assertEquals(200, status("/index", newClientIp()), "other clients are not affected");
    }

    @Test
    void clientThatKeepsHittingTheSameMissingPathIsBanned() throws Exception {
        String client = newClientIp();
        for (int i = 0; i < 4; i++) {
            assertEquals(404, status("/no-such-file", client));
        }
        assertEquals(403, status("/index", client), "banned after repeated 404 responses on one endpoint");
    }

    @Test
    void clientThatKeepsRequestingMissingRemoteFilesIsBanned() throws Exception {
        String client = newClientIp();
        for (int i = 0; i < 4; i++) {
            assertEquals(404, status("/getCorsFile?urlPath=" + base64(upstreamUrl("/missing/" + i + ".pdf")), client));
        }
        assertEquals(403, status("/index", client), "the handler is one endpoint, whatever the remote file");
    }

    @Test
    void notFoundResponsesAreCountedPerEndpointNotPerPath() throws Exception {
        String scanner = newClientIp();
        for (int i = 0; i < 6; i++) {
            assertEquals(404, status("/no-such-file-" + i, scanner));
        }
        assertEquals(200, status("/index", scanner), "a scan over distinct paths is only slowed down by the budgets, not banned");
    }

    @Test
    void clientThatKeepsFailingToDeleteIsBanned() throws Exception {
        String client = newClientIp();
        String body = "fileName=" + base64("file://localhost/x.txt") + "&password=guess";
        for (int i = 0; i < 6; i++) {
            HttpResponse<String> response = postForm("/deleteFile", client, body);
            assertEquals(200, response.statusCode(), "attempt " + i + " is screened and reaches the controller");
            assertTrue(response.body().contains("\"code\":1"));
        }
        assertEquals(403, postForm("/deleteFile", client, body).statusCode(), "banned after repeated failures");
    }

    @Test
    void intranetPreviewUrlIsNotBlocked() throws Exception {
        String client = newClientIp();
        String source = upstreamUrl("/hello.png");
        HttpResponse<String> preview = send(request("/onlinePreview?url=" + URLEncoder.encode(base64(source), StandardCharsets.UTF_8))
                .header("X-Forwarded-For", client)
                .header("Referer", "http://192.168.1.10/portal/documents")
                .GET().build());
        assertEquals(200, preview.statusCode());
        assertTrue(preview.body().contains(source), "the preview page was rendered for the intranet address");

        HttpResponse<String> proxied = send(request("/getCorsFile?urlPath=" + URLEncoder.encode(base64(source), StandardCharsets.UTF_8))
                .header("X-Forwarded-For", client)
                .header("Referer", "http://192.168.1.10/portal/documents")
                .GET().build());
        assertEquals(200, proxied.statusCode());
        assertEquals("hello from the intranet", proxied.body());
    }

    @Test
    void ordinaryPreviewRequestsAreNotFlagged() throws Exception {
        // Untrusted hosts are refused by the application right after the guard, so nothing is downloaded here.
        ConfigConstants.setTrustHostValue("default");
        String client = newClientIp();
        String[] sources = {
                "https://oss-cn-hangzhou.aliyuncs.com/bucket/%E5%90%88%E5%90%8C%20(%E7%BB%88%E7%89%88).docx?Expires=1760000000&OSSAccessKeyId=LTAI5tAbCdEf&Signature=aB%2Bc%2FdE%3D",
                "https://files.example.com/O%27Brien%20notes.xlsx?token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.c2lnbmF0dXJl",
                "ftp://user:p%40ss@10.0.0.5:21/share/report.pdf",
                "http://192.168.1.10:8080/files/a--b%20select%20union.pdf",
                "http://127.0.0.1:9000/bucket/a&b+c,d.pptx;jsessionid=0123456789abcdef",
                "https://h.example/a.pdf?x=1&y=%E4%B8%AD%E6%96%87#page=3"
        };
        for (String source : sources) {
            String url = URLEncoder.encode(base64(source), StandardCharsets.UTF_8);
            String optional = "&fullfilename=O%27Brien%20%E5%90%88%E5%90%8C.docx&watermarkTxt=O%27Brien%20%26%20Sons%20%3Cinternal%3E&page=2&kkagent=false";
            assertNotEquals(400, status("/onlinePreview?url=" + url + optional, client), source);
        }
    }

    @Test
    void uploadWithTheWrongContentTypeIsRejected() throws Exception {
        assertEquals(415, postForm("/fileUpload", newClientIp(), "a=b").statusCode());
    }

    @Test
    void uploadAboveTheSizeLimitIsRejectedBeforeTheBodyIsRead() throws Exception {
        String request = "POST /fileUpload HTTP/1.1\r\nHost: 127.0.0.1\r\nX-Forwarded-For: " + newClientIp() + "\r\n"
                + "Content-Type: multipart/form-data; boundary=kkguard\r\nContent-Length: 600000000\r\nConnection: close\r\n\r\n";
        try (Socket socket = new Socket("127.0.0.1", port)) {
            socket.getOutputStream().write(request.getBytes(StandardCharsets.UTF_8));
            socket.getOutputStream().flush();
            String statusLine = new String(socket.getInputStream().readNBytes(12), StandardCharsets.UTF_8);
            assertEquals("HTTP/1.1 413", statusLine);
        }
    }

    @Test
    void wellFormedUploadReachesTheController() throws Exception {
        HttpResponse<String> response = postMultipart("/fileUpload", newClientIp());
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("\"code\":1"), "the controller answered, upload is disabled by default");
    }

    @Test
    void largeCorsFileDownloadStreamsWhileTheHandlerIsStillRunning() throws Exception {
        String path = "/getCorsFile?urlPath=" + base64(upstreamUrl("/big.pdf"));
        HttpResponse<InputStream> response = client.send(
                request(path).header("X-Forwarded-For", newClientIp()).GET().build(), HttpResponse.BodyHandlers.ofInputStream());
        assertEquals(200, response.statusCode());
        assertEquals("streamed", RESPONSE_TYPES.get("/getCorsFile"));
        try (InputStream body = response.body()) {
            // Tomcat keeps the last partial 8 KB block of what it was given until more arrives, so ask for a bit less than the whole chunk.
            byte[] first = body.readNBytes(CHUNK_BYTES - 64 * 1024);
            assertEquals(CHUNK_BYTES - 64 * 1024, first.length);
            assertEquals(1, RELEASE_REST_OF_FILE.getCount(), "the first chunk arrived before the upstream finished");
            RELEASE_REST_OF_FILE.countDown();
            assertEquals(8L * CHUNK_BYTES - first.length, body.readAllBytes().length);
        }
    }

    @Test
    void guardResponsesAndSecurityHeadersStayOff() throws Exception {
        HttpResponse<String> response = get("/index", newClientIp());
        assertTrue(response.headers().firstValue("X-Content-Type-Options").isEmpty());
        assertTrue(response.headers().firstValue("X-Frame-Options").isEmpty());
        assertTrue(response.headers().firstValue("Strict-Transport-Security").isEmpty());
        assertTrue(response.headers().firstValue("Access-Control-Allow-Origin").isEmpty());
    }
}
