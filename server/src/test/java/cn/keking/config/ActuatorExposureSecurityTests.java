package cn.keking.config;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest(classes = ActuatorExposureSecurityTests.ManagementApp.class,
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ActuatorExposureSecurityTests {
    @Configuration(proxyBeanMethods = false)
    @EnableAutoConfiguration
    static class ManagementApp { }

    @Autowired TestRestTemplate http;

    @Test void shippedDefaultsExposeOnlyAnAggregateHealthStatus() {
        var health = http.getForEntity("/actuator/health", String.class);
        assertEquals(HttpStatus.OK, health.getStatusCode());
        assertEquals("{\"status\":\"UP\"}", health.getBody());
        assertEquals(HttpStatus.NOT_FOUND, http.getForEntity("/actuator/info", String.class).getStatusCode());
        assertEquals(HttpStatus.NOT_FOUND, http.getForEntity("/actuator/metrics", String.class).getStatusCode());
        assertEquals(HttpStatus.NOT_FOUND, http.getForEntity("/actuator/metrics/jvm.memory.used", String.class).getStatusCode());
    }
}
