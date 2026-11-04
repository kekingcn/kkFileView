package cn.keking.web.controller;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

/**
 * kkFileView #796 回归测试：下载保存名必须取自源 URL 的 path。
 *
 * <p>旧实现直接把 {@code urlPath} 按最后一个 '/' 截断，导致：
 * <ul>
 *   <li>{@code /report.pdf?token=demo} → 文件名带上了 query；</li>
 *   <li>{@code /report.pdf?token=partA/partB} → 变成 {@code partB}（query 里的 '/' 被当成分隔符）；</li>
 *   <li>{@code /download?id=42&fullfilename=report.pdf} → 整个 query 变成文件名。</li>
 * </ul>
 * 这些值都不以 {@code .pdf} 结尾，前端 PDF.js 的 {@code extractFilenameFromHeader} 会直接拒绝。
 */
public class OnlinePreviewControllerDownloadNameTests {

    @Test
    void queryStringIsNotPartOfTheDownloadName() {
        assertEquals(
                "report.pdf",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/files/report.pdf?token=demo"));
    }

    @Test
    void slashInsideQueryValueDoesNotTruncateTheName() {
        assertEquals(
                "report.pdf",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/files/report.pdf?token=partA/partB"));
    }

    @Test
    void fullfilenameOverrideWins() {
        assertEquals(
                "report.pdf",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/download?id=42&fullfilename=report.pdf"));
    }

    @Test
    void fullfilenameOverrideIsDecoded() {
        assertEquals(
                "报表 2024.pdf",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/download?id=42"
                                + "&fullfilename=%E6%8A%A5%E8%A1%A8%202024.pdf"));
    }

    @Test
    void plainUrlKeepsItsFileName() {
        assertEquals(
                "test.docx",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/pathA/test.docx"));
    }

    @Test
    void fragmentIsStripped() {
        assertEquals(
                "report.pdf",
                OnlinePreviewController.resolveDownloadFileName(
                        "http://example.com/report.pdf#page=3"));
    }

    @Test
    void nullUrlYieldsNoName() {
        assertNull(OnlinePreviewController.resolveDownloadFileName(null));
    }
}
