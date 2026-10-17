package cn.keking.guard;

import cn.keking.ServerMain;
import cn.keking.service.OfficePluginManager;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.bean.override.mockito.MockitoBean;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Boots the real application on a random port. The Office manager is replaced by a mock so the tests do not start LibreOffice.
 * Every test uses its own client address (sent as X-Forwarded-For) so budgets and bans never leak between tests.
 */
@SpringBootTest(classes = ServerMain.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
abstract class GuardHttpTestSupport {

    private static final AtomicInteger NEXT_CLIENT = new AtomicInteger(1);

    @MockitoBean
    OfficePluginManager officePluginManager;

    @Value("${local.server.port}")
    int port;

    final HttpClient client = HttpClient.newBuilder().version(HttpClient.Version.HTTP_1_1).build();

    static String newClientIp() {
        return "198.51.100." + NEXT_CLIENT.getAndIncrement();
    }

    static String base64(String value) {
        return Base64.getEncoder().encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }

    HttpRequest.Builder request(String pathAndQuery) {
        return HttpRequest.newBuilder(URI.create("http://127.0.0.1:" + port + pathAndQuery));
    }

    HttpResponse<String> get(String pathAndQuery, String clientIp) throws IOException, InterruptedException {
        return send(request(pathAndQuery).header("X-Forwarded-For", clientIp).GET().build());
    }

    int status(String pathAndQuery, String clientIp) throws IOException, InterruptedException {
        return get(pathAndQuery, clientIp).statusCode();
    }

    HttpResponse<String> send(HttpRequest request) throws IOException, InterruptedException {
        return client.send(request, HttpResponse.BodyHandlers.ofString());
    }

    HttpResponse<String> postForm(String path, String clientIp, String body, String... extraHeaders) throws IOException, InterruptedException {
        HttpRequest.Builder builder = request(path).header("X-Forwarded-For", clientIp)
                .header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString(body));
        for (int i = 0; i < extraHeaders.length; i += 2) {
            builder.header(extraHeaders[i], extraHeaders[i + 1]);
        }
        return send(builder.build());
    }

    HttpResponse<String> postMultipart(String path, String clientIp, String... extraHeaders) throws IOException, InterruptedException {
        String boundary = "kkguard";
        String body = "--" + boundary + "\r\nContent-Disposition: form-data; name=\"file\"; filename=\"a.txt\"\r\n"
                + "Content-Type: text/plain\r\n\r\nhello\r\n--" + boundary + "--\r\n";
        HttpRequest.Builder builder = request(path).header("X-Forwarded-For", clientIp)
                .header("Content-Type", "multipart/form-data; boundary=" + boundary)
                .POST(HttpRequest.BodyPublishers.ofString(body));
        for (int i = 0; i < extraHeaders.length; i += 2) {
            builder.header(extraHeaders[i], extraHeaders[i + 1]);
        }
        return send(builder.build());
    }
}
