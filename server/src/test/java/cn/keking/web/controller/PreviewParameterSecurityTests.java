package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.FilePreviewFactory;
import freemarker.template.Configuration;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.ui.ExtendedModelMap;

import java.io.StringWriter;
import java.util.Base64;

import static org.junit.jupiter.api.Assertions.*;

class PreviewParameterSecurityTests {
    private String previousKey;
    @BeforeEach void setup() {
        previousKey = ConfigConstants.getKey();
        ConfigConstants.setKeyValue("false");
    }
    @AfterEach void restore() { ConfigConstants.setKeyValue(previousKey); }

    private ExtendedModelMap preview(String page, String agent) {
        FileHandlerService handler = new FileHandlerService(null) {
            @Override public FileAttribute getFileAttribute(String url, HttpServletRequest request) {
                FileAttribute file = new FileAttribute();
                file.setName("document.pdf");
                file.setSuffix("pdf");
                return file;
            }
        };
        FilePreviewFactory factory = new FilePreviewFactory(null) {
            @Override public FilePreview get(FileAttribute file) {
                return (url, model, attribute) -> {
                    model.addAttribute("pdfUrl", url);
                    return "pdf";
                };
            }
        };
        ExtendedModelMap model = new ExtendedModelMap();
        OnlinePreviewController controller = new OnlinePreviewController(factory, handler, null, null);
        String url = Base64.getEncoder().encodeToString("https://files.example/document.pdf".getBytes());
        assertEquals("pdf", controller.onlinePreview(url, null, null, "false", page, agent,
                model, new MockHttpServletRequest()));
        return model;
    }

    @ParameterizedTest
    @ValueSource(strings = {"';alert(1);//", "\";alert(1);//", "1</script><script>alert(1)</script>",
            "1;alert(1)", "-1", "2147483648", "999999999999999999999"})
    void rendersOnlySafeScalarValuesThroughControllerAndPdfTemplate(String payload) throws Exception {
        ExtendedModelMap model = preview(payload, payload);
        assertEquals("0", model.get("page"));
        assertEquals("false", model.get("kkagent"));
        model.put("baseUrl", "https://preview.example/");
        for (String name : new String[]{"watermarkXSpace", "watermarkYSpace", "watermarkAlpha",
                "watermarkWidth", "watermarkHeight", "watermarkAngle"}) {
            model.put(name, "0");
        }
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_32);
        cfg.setClassForTemplateLoading(getClass(), "/web");
        cfg.setClassicCompatible(true);
        StringWriter output = new StringWriter();
        cfg.getTemplate("pdf.ftl").process(model, output);
        String html = output.toString();
        assertTrue(html.contains("var kkagent = 'false';"));
        assertTrue(html.contains("#page=0"));
        assertFalse(html.contains("alert(1)"));
    }

    @Test void preservesSupportedValues() {
        assertEquals("12", preview("0012", "false").get("page"));
        assertEquals("2147483647", preview("2147483647", "true").get("page"));
        assertEquals("true", preview("1", "true").get("kkagent"));
    }
}
