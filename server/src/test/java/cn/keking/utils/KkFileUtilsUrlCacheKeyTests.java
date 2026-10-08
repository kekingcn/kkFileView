package cn.keking.utils;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * kkFileView #791 回归测试：不同路径下同名文件必须映射到不同的缓存 key，
 * 防止转换产物被互相覆盖（内容污染）。
 */
public class KkFileUtilsUrlCacheKeyTests {

    @Test
    void sameUrlProducesStableKey() {
        String url = "http://example.com/pathA/test.docx";
        assertEquals(KkFileUtils.urlCacheKey(url), KkFileUtils.urlCacheKey(url));
    }

    @Test
    void differentPathSameBasenameProducesDifferentKey() {
        String a = "http://example.com/pathA/test.docx";
        String b = "http://example.com/pathB/test.docx";
        assertNotEquals(KkFileUtils.urlCacheKey(a), KkFileUtils.urlCacheKey(b));
    }

    @Test
    void keyIsSafeForFileName() {
        String key = KkFileUtils.urlCacheKey("http://example.com/pathA/test.docx");
        assertEquals(12, key.length());
        assertFalse(key.contains("/"));
        assertFalse(key.contains("\\"));
        assertFalse(key.contains(".."));
        assertTrue(key.matches("[0-9a-f]{12}"));
    }

    /**
     * P0 防护：模拟 FileHandlerService.getFileAttribute 的命名契约
     * physicalName = urlCacheKey(url) + "_" + originFileName。
     * 不同路径下同名文件必须得到不同的物理名，否则下载/转换/引用三处路径失配（预览 404）。
     */
    @Test
    void physicalNameDiffersAcrossUrlsWithSameBasename() {
        String originName = "test.docx";
        String a = "http://example.com/pathA/" + originName;
        String b = "http://example.com/pathB/" + originName;
        String physicalA = KkFileUtils.urlCacheKey(a) + "_" + originName;
        String physicalB = KkFileUtils.urlCacheKey(b) + "_" + originName;
        assertNotEquals(physicalA, physicalB, "同名不同 URL 必须映射到不同物理名，否则缓存互相覆盖");
    }
}
