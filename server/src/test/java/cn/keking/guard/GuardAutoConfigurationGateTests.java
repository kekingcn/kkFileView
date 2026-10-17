package cn.keking.guard;

import org.junit.jupiter.api.Test;
import org.springframework.mock.env.MockEnvironment;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;

class GuardAutoConfigurationGateTests {

    private static final String[] CLASSES = {
            GuardAutoConfigurationGate.GUARD_AUTO_CONFIGURATION,
            "org.springframework.boot.autoconfigure.web.servlet.WebMvcAutoConfiguration"
    };

    private static boolean[] match(MockEnvironment environment) {
        GuardAutoConfigurationGate gate = new GuardAutoConfigurationGate();
        gate.setEnvironment(environment);
        return gate.match(CLASSES, null);
    }

    @Test
    void keepsGuardOutWhenThePropertyIsMissing() {
        assertArrayEquals(new boolean[]{false, true}, match(new MockEnvironment()));
    }

    @Test
    void keepsGuardOutWhenThePropertyIsFalse() {
        assertArrayEquals(new boolean[]{false, true}, match(new MockEnvironment().withProperty("guard.enabled", "false")));
    }

    @Test
    void importsGuardOnlyWhenThePropertyIsTrue() {
        assertArrayEquals(new boolean[]{true, true}, match(new MockEnvironment().withProperty("guard.enabled", "true")));
    }
}
