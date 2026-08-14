package cn.keking.web;

import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class HtmlPreviewSandboxTests {

    @Test
    void shouldRenderHtmlOnlyInsideAnOpaqueOriginSandbox() throws IOException {
        String template = readResource("web/code.ftl");

        assertTrue(template.contains("frame.setAttribute(\"sandbox\", scriptjs ? \"allow-scripts\" : \"\")"));
        assertTrue(template.contains("frame.srcdoc = decodePreviewText()"));
        assertFalse(template.contains("allow-same-origin"));
        assertFalse(template.contains("$('#text').html(textData)"));
        assertFalse(template.contains("function htmlttt"));
    }

    @Test
    void shouldDisplaySourceAsTextAndDisableScriptsByDefault() throws IOException {
        String template = readResource("web/code.ftl");
        String properties = readResource("application.properties");

        assertTrue(template.contains("source.textContent = decodePreviewText()"));
        assertTrue(properties.contains("kk.scriptjs = false"));
    }

    private String readResource(String path) throws IOException {
        ClassPathResource resource = new ClassPathResource(path);
        return new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    }
}
