package cn.keking.config;

import cn.keking.utils.ConfigUtils;
import org.junit.jupiter.api.Test;
import org.springframework.core.env.MapPropertySource;
import org.springframework.core.env.MutablePropertySources;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.core.env.PropertySourcesPropertyResolver;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

/**
 * kk.Picturespreview、kk.Getcorsfile、kk.addTask 三个开关应与其它配置项一样，
 * 使用 ${KK_XXX:默认值} 的写法，可以通过环境变量调整，未设置环境变量时保持默认值 true。
 */
class InterfaceSwitchEnvConfigTests {

    private static final String[] CONFIG_FILES = {"/application.properties", "/test.properties"};

    private static final Map<String, String> SWITCH_ENV_NAMES = Map.of(
            "kk.Picturespreview", "KK_PICTURESPREVIEW",
            "kk.Getcorsfile", "KK_GETCORSFILE",
            "kk.addTask", "KK_ADDTASK");

    @Test
    void shouldReadInterfaceSwitchesFromEnvironmentVariables() throws IOException {
        for (String configFile : CONFIG_FILES) {
            Properties properties = readProperties(configFile);
            SWITCH_ENV_NAMES.forEach((key, envName) ->
                    assertEquals("false", resolve(properties, key, Map.of(envName, "false")),
                            () -> key + " in " + configFile + " must be configurable through " + envName));
        }
    }

    @Test
    void shouldKeepInterfaceSwitchesEnabledByDefault() throws IOException {
        for (String configFile : CONFIG_FILES) {
            Properties properties = readProperties(configFile);
            SWITCH_ENV_NAMES.forEach((key, envName) ->
                    assertEquals("true", resolve(properties, key, Map.of()),
                            () -> key + " in " + configFile + " must stay enabled by default"));
        }
    }

    @Test
    void shouldKeepInterfaceSwitchesEnabledByDefaultWhenConfigIsReloaded() throws IOException {
        for (String configFile : CONFIG_FILES) {
            // 与 ConfigRefreshComponent 重新加载配置文件时的处理方式一致
            Properties properties = readProperties(configFile);
            ConfigUtils.restorePropertiesFromEnvFormat(properties);
            SWITCH_ENV_NAMES.forEach((key, envName) -> {
                String expected = System.getenv(envName) == null ? "true" : System.getenv(envName);
                assertEquals(expected, properties.getProperty(key).trim(),
                        () -> key + " in " + configFile + " must stay enabled by default after a reload");
            });
        }
    }

    /**
     * 按 Spring 的占位符规则解析配置项，environment 的优先级高于配置文件，相当于系统环境变量。
     */
    private static String resolve(Properties properties, String key, Map<String, Object> environment) {
        MutablePropertySources propertySources = new MutablePropertySources();
        propertySources.addLast(new MapPropertySource("environment", environment));
        propertySources.addLast(new PropertiesPropertySource("config", properties));
        String value = new PropertySourcesPropertyResolver(propertySources).getProperty(key);
        assertNotNull(value, () -> key + " is missing");
        return value.trim();
    }

    private Properties readProperties(String resourcePath) throws IOException {
        Properties properties = new Properties();
        try (InputStream inputStream = getClass().getResourceAsStream(resourcePath)) {
            assertNotNull(inputStream, () -> resourcePath + " is missing");
            properties.load(new InputStreamReader(inputStream, StandardCharsets.UTF_8));
        }
        return properties;
    }
}
