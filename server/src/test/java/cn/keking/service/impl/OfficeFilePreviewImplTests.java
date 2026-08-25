package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class OfficeFilePreviewImplTests {

    @BeforeEach
    void setUp() {
        ConfigConstants.setOfficeTypeWebValue("web");
    }

    @Test
    void usesWebPreviewWhenPreviewTypeWasNotExplicitlySpecified() {
        FileAttribute attribute = new FileAttribute(FileType.OFFICE, "xlsx", "report.xlsx", "http://localhost/report.xlsx");

        assertThat(OfficeFilePreviewImpl.shouldUseWebPreview(attribute)).isTrue();
    }

    @Test
    void explicitPdfDoesNotUseWebPreview() {
        FileAttribute attribute = new FileAttribute(FileType.OFFICE, "xlsx", "report.xlsx", "http://localhost/report.xlsx", "pdf");

        assertThat(OfficeFilePreviewImpl.shouldUseWebPreview(attribute)).isFalse();
    }

    @Test
    void explicitXlsxUsesWebPreview() {
        FileAttribute attribute = new FileAttribute(FileType.OFFICE, "xlsx", "report.xlsx", "http://localhost/report.xlsx", "xlsx");

        assertThat(OfficeFilePreviewImpl.shouldUseWebPreview(attribute)).isTrue();
    }

    @Test
    void explicitHtmlDoesNotUseWebPreview() {
        FileAttribute attribute = new FileAttribute(FileType.OFFICE, "xlsx", "report.xlsx", "http://localhost/report.xlsx", "html");

        assertThat(OfficeFilePreviewImpl.shouldUseWebPreview(attribute)).isFalse();
    }
}
