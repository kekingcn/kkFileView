package cn.keking.web;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import org.junit.jupiter.api.Test;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * officeweb.ftl is the only preview template that neither includes commonHeader.ftl nor
 * turns on classic_compatible, so it is the only one that fails outright when the
 * watermark request attributes are absent.
 *
 * They are absent whenever WatermarkConfigConstants has not been populated: it is not a
 * Spring bean, so its @Value defaults never run, and ConfigRefreshComponent#loadConfig
 * returns early when the external config/application.properties is missing. Every getter
 * then returns null, and AttributeSetFilter's setAttribute(name, null) removes the
 * attribute per the Servlet spec.
 *
 * The first test therefore renders with a model that carries no watermark* entry at all.
 * Do not add them "to make it realistic" - that is the condition under test.
 */
class OfficeWebWatermarkDefaultsTests {

    @Test
    void shouldRenderXlsxPreviewPageWhenWatermarkAttributesAreMissing() throws Exception {
        String html = render(baseModel());

        assertTrue(html.contains("</html>"), "page was truncated before </html>");
        assertTrue(html.contains("let watermarkTxt = '';"), "watermarkTxt did not fall back to an empty string");
        assertTrue(html.contains("watermark_width: 240,"), "watermarkWidth did not fall back to its declared default");
        assertTrue(html.contains("watermark_font: '\u5fae\u8f6f\u96c5\u9ed1',"), "watermarkFont did not fall back to its declared default");
    }

    @Test
    void shouldKeepConfiguredWatermarkSettingsWhenAttributesArePresent() throws Exception {
        Map<String, Object> model = baseModel();
        model.put("watermarkTxt", "kkFileView");
        model.put("watermarkXSpace", "20");
        model.put("watermarkYSpace", "30");
        model.put("watermarkFont", "Arial");
        model.put("watermarkFontsize", "24px");
        model.put("watermarkColor", "red");
        model.put("watermarkAlpha", "0.5");
        model.put("watermarkWidth", "300");
        model.put("watermarkHeight", "120");
        model.put("watermarkAngle", "45");

        String html = render(model);

        assertTrue(html.contains("let watermarkTxt = 'kkFileView';"));
        assertTrue(html.contains("watermark_x_space: 20,"));
        assertTrue(html.contains("watermark_y_space: 30,"));
        assertTrue(html.contains("watermark_font: 'Arial',"));
        assertTrue(html.contains("watermark_fontsize: '24px',"));
        assertTrue(html.contains("watermark_color: 'red',"));
        assertTrue(html.contains("watermark_alpha: 0.5,"));
        assertTrue(html.contains("watermark_width: 300,"));
        assertTrue(html.contains("watermark_height: 120,"));
        assertTrue(html.contains("watermark_angle: 45,"));
    }

    /** Everything officeweb.ftl needs except the watermark attributes. */
    private Map<String, Object> baseModel() {
        Map<String, Object> model = new HashMap<>();
        model.put("file", Map.of("name", "demo.xlsx"));
        model.put("pdfUrl", "demo.xlsx");
        model.put("baseUrl", "http://127.0.0.1:8012/");
        model.put("kkagent", "false");
        model.put("kkkey", "");
        model.put("xlsxshowtoolbar", Boolean.TRUE);
        model.put("xlsxallowEdit", Boolean.FALSE);
        return model;
    }

    private String render(Map<String, Object> model) throws Exception {
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_32);
        configuration.setClassLoaderForTemplateLoading(getClass().getClassLoader(), "web");
        configuration.setDefaultEncoding("UTF-8");
        configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

        Template template = configuration.getTemplate("officeweb.ftl");
        StringWriter out = new StringWriter();
        template.process(model, out);
        return out.toString();
    }
}
