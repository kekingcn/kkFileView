package cn.keking.config;

import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(classes = ActuatorExposureSecurityTests.ManagementApp.class,
        properties = "spring.config.name=test",
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ActuatorOverrideExposureSecurityTests extends ActuatorExposureSecurityTests {
}
