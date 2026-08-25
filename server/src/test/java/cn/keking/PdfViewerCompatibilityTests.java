package cn.keking;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PdfViewerCompatibilityTests {

    @Test
    void shouldLoadCompatibilityModuleBeforePdfJs() throws IOException {
        String viewerHtml = readResource("/static/pdfjs/web/viewer.html");

        assertTrue(viewerHtml.contains("<script src=\"compatibility.mjs\" type=\"module\"></script>"));
        assertTrue(viewerHtml.indexOf("compatibility.mjs") < viewerHtml.indexOf("../build/pdf.mjs"));
    }

    @Test
    void shouldLoadCompatibilityModuleInPdfWorker() throws IOException {
        String workerScript = readResource("/static/pdfjs/build/pdf.worker.mjs");

        assertTrue(workerScript.contains("import \"../web/compatibility.mjs\";"));
    }

    @Test
    void shouldRenderPdfSidebarModeByDefaultBasedOnConfig() throws IOException {
        String pdfTemplate = readResource("/web/pdf.ftl");

        assertTrue(pdfTemplate.contains("<#if \"true\" == pdfSidebarOpen>"));
        assertTrue(pdfTemplate.contains("viewerUrl += \"&pagemode=thumbs\";"));
        assertTrue(pdfTemplate.contains("viewerUrl += \"&pagemode=none\";"));
    }

    @Test
    void shouldForwardAndApplyAllPdfWatermarkSettings() throws IOException {
        String pdfTemplate = readResource("/web/pdf.ftl");
        String viewerScript = readResource("/static/pdfjs/web/viewer.mjs");
        Map<String, String> watermarkParams = Map.ofEntries(
                Map.entry("watermarktxt", "watermarkTxt"),
                Map.entry("watermarkxspace", "watermarkXSpace"),
                Map.entry("watermarkyspace", "watermarkYSpace"),
                Map.entry("watermarkfont", "watermarkFont"),
                Map.entry("watermarkfontsize", "watermarkFontsize"),
                Map.entry("watermarkcolor", "watermarkColor"),
                Map.entry("watermarkalpha", "watermarkAlpha"),
                Map.entry("watermarkwidth", "watermarkWidth"),
                Map.entry("watermarkheight", "watermarkHeight"),
                Map.entry("watermarkangle", "watermarkAngle")
        );

        watermarkParams.forEach((queryParam, templateAttribute) -> {
            assertTrue(pdfTemplate.contains(queryParam + ": '${" + templateAttribute + "?js_string}'"),
                    () -> "PDF template does not forward " + templateAttribute);
            assertTrue(viewerScript.contains("\"" + queryParam + "\"")
                            || viewerScript.contains("'" + queryParam + "'"),
                    () -> "PDF viewer does not consume " + queryParam);
        });
        assertTrue(viewerScript.contains("div.style.fontFamily = settings.font;"));
        assertTrue(viewerScript.contains("div.style.fontSize = settings.fontsize;"));
        assertTrue(viewerScript.contains("div.style.color = settings.color;"));
        assertTrue(viewerScript.contains("div.style.opacity = settings.alpha;"));
        assertTrue(viewerScript.contains("const xStep = settings.width + settings.x_space;"));
        assertTrue(viewerScript.contains("const yStep = settings.height + settings.y_space;"));
    }

    @Test
    void shouldPreferPdfForOfficePreviewByDefault() throws IOException {
        String properties = readResource("/application.properties");

        assertTrue(properties.contains("office.preview.type = ${KK_OFFICE_PREVIEW_TYPE:pdf}"));
    }

    private String readResource(String resourcePath) throws IOException {
        try (InputStream inputStream = getClass().getResourceAsStream(resourcePath)) {
            assertNotNull(inputStream);
            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
