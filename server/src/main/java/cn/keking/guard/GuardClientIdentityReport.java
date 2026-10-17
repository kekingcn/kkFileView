package cn.keking.guard;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.cloud.CloudPlatform;
import org.springframework.boot.context.properties.bind.Bindable;
import org.springframework.boot.context.properties.bind.Binder;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Logs, once at startup, which layer decides the client address, so Tomcat and Guard Core cannot disagree
 * about proxy trust unnoticed. Tomcat rewrites the remote address only when server.forward-headers-strategy
 * is native or framework (or a cloud platform that implies it); Guard Core trusts X-Forwarded-For only from
 * guard.trusted-proxies. Use one of the two, not both.
 */
@Component
@ConditionalOnProperty(name = "guard.enabled", havingValue = "true")
public class GuardClientIdentityReport {

    private static final Logger logger = LoggerFactory.getLogger(GuardClientIdentityReport.class);

    public GuardClientIdentityReport(Environment environment) {
        List<String> trustedProxies = Binder.get(environment)
                .bind("guard.trusted-proxies", Bindable.listOf(String.class)).orElse(List.of());
        String strategy = environment.getProperty("server.forward-headers-strategy");
        CloudPlatform platform = CloudPlatform.getActive(environment);
        boolean tomcatRewrites = strategy != null
                ? !"none".equalsIgnoreCase(strategy)
                : platform != null && platform.isUsingForwardHeaders();
        if (tomcatRewrites && !trustedProxies.isEmpty()) {
            logger.warn("Guard Core: Tomcat already rewrites the client address from forwarded headers "
                    + "(server.forward-headers-strategy) and guard.trusted-proxies is also set. Use only one of them, "
                    + "and keep server.tomcat.remoteip.internal-proxies as narrow as guard.trusted-proxies.");
        } else if (tomcatRewrites) {
            logger.info("Guard Core: client address comes from Tomcat (server.forward-headers-strategy), "
                    + "guard.trusted-proxies is empty.");
        } else if (trustedProxies.isEmpty()) {
            logger.info("Guard Core: client address is the TCP peer, X-Forwarded-For is ignored. Behind a reverse proxy "
                    + "set guard.trusted-proxies, otherwise every client shares the proxy address.");
        } else {
            logger.info("Guard Core: client address is the TCP peer, X-Forwarded-For is trusted only from {}.", trustedProxies);
        }
    }
}
