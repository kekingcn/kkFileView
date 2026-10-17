package cn.keking.guard;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.read.ListAppender;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.slf4j.LoggerFactory;
import org.springframework.mock.env.MockEnvironment;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class GuardClientIdentityReportTests {

    private final Logger logger = (Logger) LoggerFactory.getLogger(GuardClientIdentityReport.class);
    private final ListAppender<ILoggingEvent> logs = new ListAppender<>();

    @BeforeEach
    void captureLogs() {
        logs.start();
        logger.addAppender(logs);
    }

    @AfterEach
    void releaseLogs() {
        logger.detachAppender(logs);
    }

    private ILoggingEvent report(MockEnvironment environment) {
        new GuardClientIdentityReport(environment);
        assertEquals(1, logs.list.size());
        return logs.list.get(0);
    }

    @Test
    void warnsWhenTomcatAndGuardBothRewriteTheClientAddress() {
        ILoggingEvent event = report(new MockEnvironment()
                .withProperty("server.forward-headers-strategy", "native")
                .withProperty("guard.trusted-proxies[0]", "10.0.0.0/8"));
        assertEquals(Level.WARN, event.getLevel());
        assertTrue(event.getFormattedMessage().contains("Use only one of them"));
    }

    @Test
    void saysTheTcpPeerIsUsedWhenNothingIsTrusted() {
        ILoggingEvent event = report(new MockEnvironment());
        assertEquals(Level.INFO, event.getLevel());
        assertTrue(event.getFormattedMessage().contains("TCP peer, X-Forwarded-For is ignored"));
    }

    @Test
    void namesTheTrustedProxies() {
        ILoggingEvent event = report(new MockEnvironment().withProperty("guard.trusted-proxies", "10.0.0.7"));
        assertEquals(Level.INFO, event.getLevel());
        assertTrue(event.getFormattedMessage().contains("[10.0.0.7]"));
    }

    @Test
    void saysTomcatDecidesWhenOnlyTomcatRewrites() {
        ILoggingEvent event = report(new MockEnvironment().withProperty("server.forward-headers-strategy", "framework"));
        assertEquals(Level.INFO, event.getLevel());
        assertTrue(event.getFormattedMessage().contains("comes from Tomcat"));
    }

    @Test
    void anExplicitNoneKeepsTomcatOutOfIt() {
        ILoggingEvent event = report(new MockEnvironment().withProperty("server.forward-headers-strategy", "none"));
        assertTrue(event.getFormattedMessage().contains("TCP peer"));
    }

    @Test
    void aCloudPlatformThatImpliesForwardedHeadersCountsAsTomcatRewriting() {
        ILoggingEvent event = report(new MockEnvironment()
                .withProperty("VCAP_APPLICATION", "{}")
                .withProperty("guard.trusted-proxies", "10.0.0.7"));
        assertEquals(Level.WARN, event.getLevel());
    }
}
