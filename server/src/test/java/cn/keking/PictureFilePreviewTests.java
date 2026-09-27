package cn.keking;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * kkFileView #787 回归测试：直接图片预览（picture.ftl）必须在 Viewer.js 标题里显示文件名。
 *
 * 根因：v4.3.0 之后模板把图片元素从 &lt;img&gt; 改成 &lt;div src&gt;，而 HTMLDivElement 没有 DOM 的
 * src 属性，Viewer.js 用 image.src 取标题得到 undefined，导致标题为空。修复方式是在 Viewer 初始化时
 * 配置 title 函数，从 data-original-url 派生文件名。
 *
 * 关键点（已核对 viewer.min.js 源码）：title 回调拿到的 `image` 是 Viewer 内部新建的 &lt;img&gt;
 * （view(): `var image = document.createElement('img')`），不是原始 &lt;div&gt;。Viewer 在构建缩略图
 * 与查看大图时只透传 `inheritedAttributes` 里的属性，默认值不含 data-original-url，所以必须把
 * data-original-url 加进 inheritedAttributes，否则 title 函数永远读不到它、标题恒为 'image'。
 */
public class PictureFilePreviewTests {

    @Test
    void shouldDeriveViewerTitleFromOriginalUrl() throws IOException {
        String pictureTemplate = readResource("/web/picture.ftl");

        // 模板仍保留 data-original-url 供标题派生使用
        assertTrue(pictureTemplate.contains("data-original-url"),
                () -> "picture.ftl must keep data-original-url for title derivation (see #787)");

        // Viewer 初始化必须配置 title 函数，否则 <div> 的 image.src 为 undefined、标题为空
        assertTrue(pictureTemplate.contains("title: function"),
                () -> "picture.ftl must configure a Viewer title function to show the filename (see #787)");

        // 标题派生逻辑必须读取 data-original-url（而非反代 / CORS 代理 URL）
        assertTrue(pictureTemplate.contains("getImageNameFromOriginalUrl"),
                () -> "picture.ftl must derive the title from data-original-url (see #787)");
        assertTrue(pictureTemplate.contains("getAttribute('data-original-url')"),
                () -> "title derivation must read data-original-url attribute (see #787)");

        // 关键：Viewer.js 只会把 inheritedAttributes 透传到 title 回调拿到的 <img> 上，默认值不含
        // data-original-url。若不显式加入，title 函数读不到原始 URL、标题恒为 'image'（修复形同虚设）。
        assertTrue(pictureTemplate.contains("inheritedAttributes"),
                () -> "picture.ftl must set Viewer inheritedAttributes so data-original-url reaches the title image (see #787)");
        assertTrue(pictureTemplate.contains("'data-original-url'"),
                () -> "Viewer inheritedAttributes must include data-original-url (see #787)");
    }

    private String readResource(String resourcePath) throws IOException {
        try (InputStream inputStream = getClass().getResourceAsStream(resourcePath)) {
            assertNotNull(inputStream);
            return new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
        }
    }
}
