package cn.keking.guard;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

/** No trusted proxy is configured: the client is the TCP peer and X-Forwarded-For is never believed. */
@TestPropertySource(properties = {
        "guard.enabled=true",
        "guard.trusted-proxies=",
        "guard.rate-limit=1000",
        "guard.endpoint-rate-limits[/picturesPreview].requests=3",
        "guard.kk.admin-allowed-ips=203.0.113.0/24"
})
class GuardUntrustedProxyTests extends GuardHttpTestSupport {

    @Test
    void spoofedForwardedForDoesNotResetTheBudget() throws Exception {
        for (int i = 0; i < 3; i++) {
            assertNotEquals(429, status("/picturesPreview", newClientIp()), "request " + i);
        }
        assertEquals(429, status("/picturesPreview", newClientIp()), "a fresh spoofed address does not buy a fresh budget");
    }

    @Test
    void spoofedForwardedForDoesNotGrantAdminAccess() throws Exception {
        assertEquals(403, postForm("/createFolder", "203.0.113.9", "folderName=a").statusCode());
    }

    @Test
    void aLoopbackClientIsRejectedButNeverBanned() throws Exception {
        for (int i = 0; i < 12; i++) {
            assertEquals(400, status("/index?file=../../../../etc/passwd", "ignored"));
        }
        assertEquals(200, status("/index", "ignored"), "the engine does not ban loopback addresses");
    }
}
