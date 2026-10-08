package cn.keking.utils;

import org.apache.poi.extractor.ExtractorFactory;
import org.apache.poi.extractor.POITextExtractor;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class OfficeSchemaCompatibilityTests {

    @TempDir
    Path directory;

    @Test
    void shouldLoadOneSchemaDefinitionForEachOfficeFormat() throws Exception {
        for (String schema : new String[]{
                "org/openxmlformats/schemas/wordprocessingml/x2006/main/DocumentDocument.class",
                "org/openxmlformats/schemas/presentationml/x2006/main/SldMasterDocument.class"}) {
            List<URL> definitions = Collections.list(getClass().getClassLoader().getResources(schema));
            assertEquals(1, definitions.size(), () -> "Conflicting Office schema definitions: " + definitions);
        }
    }

    @Test
    void shouldReadDocxWithCurrentPoiSchemas() throws Exception {
        Path file = directory.resolve("sample.docx");
        try (XWPFDocument document = new XWPFDocument(); OutputStream output = Files.newOutputStream(file)) {
            document.createParagraph().createRun().setText("Schema compatibility");
            document.write(output);
        }
        assertReadable(file);
    }

    @Test
    void shouldReadPptxWithCurrentPoiSchemas() throws Exception {
        Path file = directory.resolve("sample.pptx");
        try (XMLSlideShow document = new XMLSlideShow(); OutputStream output = Files.newOutputStream(file)) {
            document.createSlide().createTextBox().setText("Schema compatibility");
            document.write(output);
        }
        assertReadable(file);
    }

    private void assertReadable(Path file) throws Exception {
        try (InputStream input = Files.newInputStream(file);
             POITextExtractor extractor = ExtractorFactory.createExtractor(input)) {
            assertTrue(extractor.getText().contains("Schema compatibility"));
        }
        assertFalse(OfficeUtils.isPwdProtected(file.toString()));
    }
}
