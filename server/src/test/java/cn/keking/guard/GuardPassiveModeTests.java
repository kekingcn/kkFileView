package cn.keking.guard;

import org.junit.jupiter.api.Test;
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** The observation mode used to roll the guard out: violations are only logged, nothing is blocked. */
@TestPropertySource(properties = {
        "guard.enabled=true",
        "guard.passive-mode=true",
        "guard.trusted-proxies=127.0.0.1",
        "guard.rate-limit=3"
})
class GuardPassiveModeTests extends GuardHttpTestSupport {

    @Test
    void attacksAndOverBudgetRequestsAreLoggedNotBlocked() throws Exception {
        String client = newClientIp();
        assertEquals(200, status("/index?file=../../../../etc/passwd", client));
        for (int i = 0; i < 6; i++) {
            assertEquals(200, status("/index", client), "request " + i);
        }
    }
}
