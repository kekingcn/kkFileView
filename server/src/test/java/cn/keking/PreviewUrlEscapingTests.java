package cn.keking;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.impl.OfficeFilePreviewImpl;
import cn.keking.service.impl.PdfFilePreviewImpl;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.ui.ExtendedModelMap;

import java.io.StringWriter;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PreviewUrlEscapingTests {

    @ParameterizedTest
    @ValueSource(strings = {"pdf", "csv", "xlsx"})
    void shouldPreserveSourceUrlThroughPreviewModelAndTemplate(String suffix) throws Exception {
        String sourceUrl = "https://files.example/Int'l/report%20one." + suffix + "?token=a&mode=b";
        String previousOfficeTypeWeb = ConfigConstants.getOfficeTypeWeb();
        ConfigConstants.setOfficeTypeWebValue("web");
        try {
            FileAttribute file = new FileAttribute();
            file.setName("report." + suffix);
            file.setSuffix(suffix);
            file.setOfficePreviewType("pdf");
            file.setCacheName("url-escaping-test." + suffix);

            ExtendedModelMap model = new ExtendedModelMap();
            model.addAttribute("file", file);
            model.addAttribute("baseUrl", "https://preview.example/");
            model.addAttribute("kkagent", "false");
            model.addAttribute("page", "0");
            model.addAttribute("switchDisabled", "true");
            model.addAttribute("watermarkTxt", "");
            model.addAttribute("xlsxshowtoolbar", false);
            for (String name : new String[]{"watermarkXSpace", "watermarkYSpace", "watermarkAlpha",
                    "watermarkWidth", "watermarkHeight", "watermarkAngle"}) {
                model.addAttribute(name, "0");
            }
            for (String name : new String[]{"watermarkFont", "watermarkFontsize", "watermarkColor",
                    "highlightall", "pdfPresentationModeDisable", "pdfOpenFileDisable", "pdfPrintDisable",
                    "pdfDownloadDisable", "pdfBookmarkDisable", "pdfDisableEditing", "pdfSidebarOpen", "kkkey"}) {
                model.addAttribute(name, "");
            }

            OfficeFilePreviewImpl office = new OfficeFilePreviewImpl(null, null, null, null);
            String view = suffix.equals("pdf")
                    ? new PdfFilePreviewImpl(null, null, office, null).filePreviewHandle(sourceUrl, model, file)
                    : office.filePreviewHandle(sourceUrl, model, file);
            assertEquals(Map.of("pdf", "pdf", "csv", "csv", "xlsx", "officeweb").get(suffix), view);
            assertEquals(sourceUrl, model.get(suffix.equals("csv") ? "csvUrl" : "pdfUrl"));

            Configuration configuration = new Configuration(Configuration.VERSION_2_3_32);
            configuration.setClassForTemplateLoading(getClass(), "/web");
            configuration.setDefaultEncoding("UTF-8");
            configuration.setClassicCompatible(true);
            Template template = configuration.getTemplate(view + ".ftl");
            StringWriter output = new StringWriter();
            template.process(model, output);
            String html = output.toString();

            assertTrue(html.contains("var url = 'https://files.example/Int\\'l/report%20one."
                    + suffix + "?token=a&mode=b';"), html);
            assertFalse(html.contains("&#39;"), html);
        } finally {
            ConfigConstants.setOfficeTypeWebValue(previousOfficeTypeWeb);
        }
    }
}
