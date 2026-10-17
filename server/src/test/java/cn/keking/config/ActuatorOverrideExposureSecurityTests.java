package cn.keking.config;

import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = ActuatorExposureSecurityTests.ManagementApp.class,
        // guard.enabled: without application.properties spring-boot-guard turns itself on, and this test is about actuator only
        properties = {"spring.config.name=test", "guard.enabled=false"},
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ActuatorOverrideExposureSecurityTests extends ActuatorExposureSecurityTests {
}
