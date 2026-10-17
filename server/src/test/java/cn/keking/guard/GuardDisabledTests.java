package cn.keking.guard;

import com.guardcore.spring.GuardFilter;
import com.guardcore.spring.GuardMiddleware;
import com.guardcore.spring.GuardProperties;
import com.guardcore.spring.GuardSecurityAutoConfiguration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.Environment;

import java.net.http.HttpResponse;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** The shipped defaults: Guard Core is on the classpath but nothing of it is registered and behaviour is unchanged. */
class GuardDisabledTests extends GuardHttpTestSupport {

    @Autowired
    ApplicationContext context;

    @Autowired
    Environment environment;

    @Test
    void shippedConfigurationSwitchesTheLibraryOff() {
        // spring-boot-guard defaults guard.enabled to true, so application.properties is what keeps the guard off.
        assertEquals("false", environment.getProperty("guard.enabled"));
        assertEquals(0, context.getBeanNamesForType(GuardSecurityAutoConfiguration.class).length);
        assertEquals(0, context.getBeanNamesForType(GuardProperties.class).length);
    }

    @Test
    void registersNoGuardComponent() {
        assertEquals(0, context.getBeanNamesForType(GuardMiddleware.class).length);
        assertEquals(0, context.getBeanNamesForType(GuardFilter.class).length);
        assertTrue(context.getBeansOfType(FilterRegistrationBean.class).values().stream()
                .noneMatch(registration -> registration.getFilter() instanceof GuardFilter));
        assertEquals(0, context.getBeanNamesForType(GuardAdminAccessValidator.class).length);
        assertFalse(context.containsBean("guardJsonConverterOrdering"));
    }

    @Test
    void leavesRequestsUntouched() throws Exception {
        String client = newClientIp();
        for (int i = 0; i < 700; i++) {
            assertEquals(200, status("/index", client), "request " + i + " was throttled");
        }
        HttpResponse<String> attack = get("/index?q=%3Cscript%3Ealert(1)%3C/script%3E", client);
        assertEquals(200, attack.statusCode());
        assertNotEquals("Suspicious activity detected", attack.body());
        assertTrue(attack.headers().firstValue("X-Content-Type-Options").isEmpty());
    }
}
