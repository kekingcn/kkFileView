package cn.keking.service;

import cn.keking.utils.KkFileUtils;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * kkFileView #796 回归测试：物理落地名的命名契约。
 *
 * <p>{@code #791} 给物理名加了源 URL 哈希前缀以避免同名文件互相覆盖，但压缩包内的文件必须保留
 * 解压后的真实相对路径 —— 该路径既不会被重新下载也不会被重命名，加前缀会指向一个从未存在的路径。
 */
public class FileHandlerServicePhysicalNameTests {

    private static final String ARCHIVE_ENTRY = "archive.zip_/docs/report.pdf";

    @Test
    void archiveEntryKeepsItsExtractedRelativePath() {
        // 压缩包内文件：originFileName 已是解压后的相对路径，必须原样返回
        String name = FileHandlerService.resolvePhysicalName(
                "http://example.com/files/archive.zip?kkCompressfileKey=docs/report.pdf"
                        + "&kkCompressfilepath=archive.zip_/docs/report.pdf",
                ARCHIVE_ENTRY,
                true);
        assertEquals(ARCHIVE_ENTRY, name, "压缩包内文件不得被加哈希前缀");
    }

    @Test
    void archiveEntryNameIsNotPrefixedEvenWhenUrlDiffers() {
        // 同一压缩包内两个不同条目：都必须是解压后的真实路径，且彼此不同
        String a = FileHandlerService.resolvePhysicalName("http://example.com/a.zip", "a.zip_/docs/a.pdf", true);
        String b = FileHandlerService.resolvePhysicalName("http://example.com/b.zip", "b.zip_/docs/b.pdf", true);
        assertEquals("a.zip_/docs/a.pdf", a);
        assertEquals("b.zip_/docs/b.pdf", b);
        assertNotEquals(a, b);
    }

    @Test
    void downloadedFileIsStillNamespacedByUrlHash() {
        String url = "http://example.com/pathA/test.docx";
        String name = FileHandlerService.resolvePhysicalName(url, "test.docx", false);
        assertTrue(name.endsWith("_test.docx"), "物理名应保留原名后缀，实际: " + name);
        assertEquals(KkFileUtils.urlCacheKey(url) + "_test.docx", name);
        assertFalse(name.contains("/"), "物理名不得包含路径分隔符: " + name);
    }

    @Test
    void sameBasenameUnderDifferentPathsGetsDifferentPhysicalNames() {
        String a = FileHandlerService.resolvePhysicalName("http://example.com/pathA/test.docx", "test.docx", false);
        String b = FileHandlerService.resolvePhysicalName("http://example.com/pathB/test.docx", "test.docx", false);
        assertNotEquals(a, b, "同名不同 URL 必须落到不同物理名，否则缓存互相覆盖（#791）");
    }
}
