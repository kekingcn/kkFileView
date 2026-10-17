package cn.keking.guard;

import cn.keking.ServerMainTestAccess;
import com.guardcore.spring.GuardMiddleware;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.context.ConfigurableApplicationContext;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Operators start kkFileView with -Dspring.config.location pointing at their own copy of application.properties,
 * which replaces the shipped one. A copy from before the guard existed has no guard.enabled, and spring-boot-guard
 * turns itself on when the property is missing, so the opt-in default has to come from the application itself.
 */
class GuardOffWithoutConfigFileTests {

    @TempDir
    Path directory;

    @Test
    void guardStaysOffWhenTheOperatorsConfigFileDoesNotMentionIt() throws Exception {
        Path config = Files.writeString(directory.resolve("application.properties"), "server.port=0\n");
        try (ConfigurableApplicationContext context = ServerMainTestAccess.applicationBuilder()
                .run("--spring.config.location=" + config, "--spring.main.lazy-initialization=true")) {
            assertEquals("false", context.getEnvironment().getProperty("guard.enabled"));
            assertEquals(0, context.getBeanNamesForType(GuardMiddleware.class).length);
        }
    }

    @Test
    void guardCanStillBeSwitchedOnFromTheConfigFile() throws Exception {
        Path config = Files.writeString(directory.resolve("application.properties"), "server.port=0\nguard.enabled=true\nguard.enable-redis=false\n");
        try (ConfigurableApplicationContext context = ServerMainTestAccess.applicationBuilder()
                .run("--spring.config.location=" + config, "--spring.main.lazy-initialization=true")) {
            assertEquals(1, context.getBeanNamesForType(GuardMiddleware.class).length);
        }
    }
}
