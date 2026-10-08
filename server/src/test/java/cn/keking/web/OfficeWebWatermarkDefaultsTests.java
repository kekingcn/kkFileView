package cn.keking.web;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.io.StringWriter;
import java.util.HashMap;
import java.util.Locale;
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
 *
 * The template's defaults are string literals on purpose: a numeric default goes through
 * FreeMarker's locale-aware number format, so under de_DE 0.2 renders as "0,2" and under
 * ar_EG the digits become Arabic-Indic - either way the inline script no longer parses.
 * The locale comes from the request's Accept-Language, which is why both tests run per
 * locale and every numeric value is asserted, not just one.
 */
class OfficeWebWatermarkDefaultsTests {

    @ParameterizedTest
    @ValueSource(strings = {"zh-CN", "en-US", "de-DE", "fr-FR", "ar-EG"})
    void shouldRenderXlsxPreviewPageWhenWatermarkAttributesAreMissing(String languageTag) throws Exception {
        String html = render(baseModel(), Locale.forLanguageTag(languageTag));

        assertTrue(html.contains("</html>"), "page was truncated before </html>");
        assertTrue(html.contains("let watermarkTxt = '';"), "watermarkTxt did not fall back to an empty string");
        assertRendered(html, "watermark_x_space: 10,");
        assertRendered(html, "watermark_y_space: 10,");
        assertRendered(html, "watermark_font: '微软雅黑',");
        assertRendered(html, "watermark_fontsize: '18px',");
        assertRendered(html, "watermark_color: 'black',");
        assertRendered(html, "watermark_alpha: 0.2,");
        assertRendered(html, "watermark_width: 240,");
        assertRendered(html, "watermark_height: 80,");
        assertRendered(html, "watermark_angle: 10,");
    }

    @ParameterizedTest
    @ValueSource(strings = {"zh-CN", "de-DE", "ar-EG"})
    void shouldKeepConfiguredWatermarkSettingsWhenAttributesArePresent(String languageTag) throws Exception {
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

        String html = render(model, Locale.forLanguageTag(languageTag));

        assertTrue(html.contains("let watermarkTxt = 'kkFileView';"));
        assertRendered(html, "watermark_x_space: 20,");
        assertRendered(html, "watermark_y_space: 30,");
        assertRendered(html, "watermark_font: 'Arial',");
        assertRendered(html, "watermark_fontsize: '24px',");
        assertRendered(html, "watermark_color: 'red',");
        assertRendered(html, "watermark_alpha: 0.5,");
        assertRendered(html, "watermark_width: 300,");
        assertRendered(html, "watermark_height: 120,");
        assertRendered(html, "watermark_angle: 45,");
    }

    /** On failure, show the line that was actually emitted for that key. */
    private static void assertRendered(String html, String expected) {
        String key = expected.substring(0, expected.indexOf(':') + 1);
        int start = html.indexOf(key);
        String actual = start < 0 ? "<missing>" : html.substring(start, html.indexOf('\n', start)).trim();
        assertTrue(html.contains(expected), "expected \"" + expected + "\" but rendered \"" + actual + "\"");
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

    /** Same lookup as Spring's FreeMarkerView: the template is resolved for the request locale. */
    private String render(Map<String, Object> model, Locale locale) throws Exception {
        Configuration configuration = new Configuration(Configuration.VERSION_2_3_32);
        configuration.setClassLoaderForTemplateLoading(getClass().getClassLoader(), "web");
        configuration.setDefaultEncoding("UTF-8");
        configuration.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

        Template template = configuration.getTemplate("officeweb.ftl", locale);
        StringWriter out = new StringWriter();
        template.process(model, out);
        return out.toString();
    }
}
