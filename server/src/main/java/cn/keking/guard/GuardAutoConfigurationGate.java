package cn.keking.guard;

import org.springframework.boot.autoconfigure.AutoConfigurationImportFilter;
import org.springframework.boot.autoconfigure.AutoConfigurationMetadata;
import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;

/**
 * Keeps Guard Core out of the application unless {@code guard.enabled=true}.
 * spring-boot-guard activates itself whenever it is on the classpath, so the opt-in
 * is enforced here, before its auto-configuration is imported: when the property is
 * absent or false no guard bean, filter or property binding exists.
 */
public class GuardAutoConfigurationGate implements AutoConfigurationImportFilter, EnvironmentAware {

    static final String GUARD_AUTO_CONFIGURATION = "com.guardcore.spring.GuardSecurityAutoConfiguration";

    private Environment environment;

    @Override
    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    @Override
    public boolean[] match(String[] autoConfigurationClasses, AutoConfigurationMetadata autoConfigurationMetadata) {
        boolean enabled = environment.getProperty("guard.enabled", Boolean.class, false);
        boolean[] outcome = new boolean[autoConfigurationClasses.length];
        for (int i = 0; i < outcome.length; i++) {
            outcome[i] = enabled || !GUARD_AUTO_CONFIGURATION.equals(autoConfigurationClasses[i]);
        }
        return outcome;
    }
}
