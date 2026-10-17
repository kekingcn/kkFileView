package cn.keking.guard;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.TestPropertySource;

import java.net.http.HttpResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

/** Access control on the state-changing endpoints: an IP allowlist and an API key, both required when both are set. */
@TestPropertySource(properties = {
        "guard.enabled=true",
        "guard.trusted-proxies=127.0.0.1",
        "guard.rate-limit=1000",
        "guard.kk.admin-allowed-ips=203.0.113.0/24,2001:db8::/32",
        "guard.kk.admin-key=s3cret"
})
class GuardAdminAccessTests extends GuardHttpTestSupport {

    private static final String ALLOWED_IP = "203.0.113.9";
    private static final String KEY_HEADER = "X-KK-Admin-Key";

    private static void assertRefused(HttpResponse<String> response) {
        assertEquals(403, response.statusCode());
        assertEquals("Forbidden", response.body());
    }

    private static void assertReachedTheController(HttpResponse<String> response) {
        assertNotEquals("Forbidden", response.body());
    }

    @Test
    void deleteIsRefusedFromAnAddressOutsideTheAllowlist() throws Exception {
        assertRefused(postForm("/deleteFile", newClientIp(), "fileName=x&password=y", KEY_HEADER, "s3cret"));
    }

    @Test
    void deleteIsRefusedWithoutTheKeyOrWithAWrongKey() throws Exception {
        assertRefused(postForm("/deleteFile", ALLOWED_IP, "fileName=x&password=y"));
        assertRefused(postForm("/deleteFile", ALLOWED_IP, "fileName=x&password=y", KEY_HEADER, "wrong"));
    }

    @Test
    void deleteReachesTheControllerFromTheAllowlistWithTheKey() throws Exception {
        assertReachedTheController(postForm("/deleteFile", ALLOWED_IP, "fileName=x&password=y", KEY_HEADER, "s3cret"));
        assertReachedTheController(postForm("/deleteFile", "2001:db8::17", "fileName=x&password=y", KEY_HEADER, "s3cret"));
    }

    @Test
    void createFolderUploadAndAddTaskAreProtectedToo() throws Exception {
        String outsider = newClientIp();
        assertRefused(postForm("/createFolder", outsider, "folderName=a"));
        assertRefused(postMultipart("/fileUpload", outsider));
        assertRefused(get("/addTask?url=" + base64("http://files.example/a.pdf"), outsider));

        assertReachedTheController(postForm("/createFolder", ALLOWED_IP, "folderName=a", KEY_HEADER, "s3cret"));
        assertReachedTheController(postMultipart("/fileUpload", ALLOWED_IP, KEY_HEADER, "s3cret"));
    }

    @Test
    void previewAndListingStayOpen() throws Exception {
        String outsider = newClientIp();
        assertNotEquals("Forbidden", get("/onlinePreview?url=" + base64("http://files.example/a.pdf"), outsider).body());
        assertEquals(200, postForm("/listFiles", outsider, "path=&page=0&size=5").statusCode());
        assertEquals(200, status("/index", outsider));
    }
}
