package cn.keking.config;

import cn.keking.web.filter.TrustDirFilter;
import cn.keking.web.filter.TrustHostFilter;
import org.junit.jupiter.api.Test;
import org.springframework.boot.web.servlet.FilterRegistrationBean;

import static org.junit.jupiter.api.Assertions.assertTrue;

class WebConfigTests {

    private final WebConfig webConfig = new WebConfig();

    @Test
    void shouldApplyTrustHostFilterToAddTaskEndpoint() {
        FilterRegistrationBean<TrustHostFilter> registration = webConfig.getTrustHostFilter();

        assertTrue(registration.getUrlPatterns().contains("/addTask"));
    }

    @Test
    void shouldApplyTrustDirFilterToAddTaskEndpoint() {
        FilterRegistrationBean<TrustDirFilter> registration = webConfig.getTrustDirFilter();

        assertTrue(registration.getUrlPatterns().contains("/addTask"));
    }
}
