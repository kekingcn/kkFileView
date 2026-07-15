package cn.keking.service;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class FileHandlerServiceTests {

    @Test
    void pdfPreviewDoesNotCreateHtmlForXlsx() {
        assertThat(FileHandlerService.isHtmlPreview("xlsx", "pdf", true)).isFalse();
    }

    @Test
    void htmlPreviewCreatesHtmlForXlsx() {
        assertThat(FileHandlerService.isHtmlPreview("xlsx", "html", true)).isTrue();
    }

    @Test
    void configuredPreviewTypeKeepsLegacySpreadsheetCacheTarget() {
        assertThat(FileHandlerService.isHtmlPreview("xlsx", "pdf", false)).isTrue();
    }

    @Test
    void htmlPreviewDoesNotChangeNonSpreadsheetOutput() {
        assertThat(FileHandlerService.isHtmlPreview("docx", "html", true)).isFalse();
    }
}
