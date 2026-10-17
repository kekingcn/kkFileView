package cn.keking.guard;

import cn.keking.config.ConfigConstants;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.context.TestPropertySource;

import java.io.ByteArrayOutputStream;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Real uploads through the guard with the shipped detection settings: the file lands intact and previewable source files are not rejected. */
@TestPropertySource(properties = {"guard.enabled=true", "guard.trusted-proxies=127.0.0.1", "file.dir=${java.io.tmpdir}/kkfileview-guard-upload-tests"})
class GuardUploadTests extends GuardHttpTestSupport {

    private static final String BOUNDARY = "kkguardupload";

    private static Boolean previousUploadDisable;

    @BeforeAll
    static void rememberConfiguration() {
        previousUploadDisable = ConfigConstants.getFileUploadDisable();
    }

    @AfterAll
    static void restoreConfiguration() throws Exception {
        ConfigConstants.setFileUploadDisableValue(previousUploadDisable);
        deleteRecursively(uploadRoot());
    }

    @BeforeEach
    void enableUploads() {
        ConfigConstants.setFileUploadDisableValue(false);
    }

    private static Path uploadRoot() {
        return Path.of(System.getProperty("java.io.tmpdir"), "kkfileview-guard-upload-tests");
    }

    private static void deleteRecursively(Path root) throws Exception {
        if (Files.exists(root)) {
            try (var paths = Files.walk(root)) {
                paths.sorted(java.util.Comparator.reverseOrder()).forEach(path -> path.toFile().delete());
            }
        }
    }

    private HttpResponse<String> upload(String fileName, byte[] content, String clientIp) throws Exception {
        ByteArrayOutputStream body = new ByteArrayOutputStream();
        body.write(("--" + BOUNDARY + "\r\nContent-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
                + "Content-Type: application/octet-stream\r\n\r\n").getBytes(StandardCharsets.UTF_8));
        body.write(content);
        body.write(("\r\n--" + BOUNDARY + "--\r\n").getBytes(StandardCharsets.UTF_8));
        return send(request("/fileUpload").header("X-Forwarded-For", clientIp)
                .header("Content-Type", "multipart/form-data; boundary=" + BOUNDARY)
                .POST(HttpRequest.BodyPublishers.ofByteArray(body.toByteArray())).build());
    }

    @Test
    void uploadedFileIsStoredIntact() throws Exception {
        byte[] content = new byte[300_000];
        for (int i = 0; i < content.length; i++) {
            content[i] = (byte) ('a' + i % 26);
        }
        HttpResponse<String> response = upload("intact.py", content, newClientIp());
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("\"code\":0"), response.body());
        assertArrayEquals(content, Files.readAllBytes(uploadRoot().resolve("demo").resolve("intact.py")));
    }

    @Test
    void sourceFileWithScriptMarkupIsNotRejected() throws Exception {
        // kkFileView previews html, jsp, sql and shell sources, so a file part that looks like an attack must not be refused as one.
        byte[] content = "<html><script>alert(document.cookie)</script></html>\n-- 1 UNION SELECT username, password FROM users\n"
                .getBytes(StandardCharsets.UTF_8);
        HttpResponse<String> response = upload("page.html", content, newClientIp());
        assertEquals(200, response.statusCode());
        assertTrue(response.body().contains("\"code\":0"), response.body());
        assertArrayEquals(content, Files.readAllBytes(uploadRoot().resolve("demo").resolve("page.html")));
    }
}
