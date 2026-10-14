package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.SignedPreviewUtils;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.List;
import java.util.Map;

import static cn.keking.SignedPreviewTestSupport.*;
import static org.junit.jupiter.api.Assertions.*;

/**
 * 签名预览里可以按接入方已有的令牌格式调整的那些配置项。
 */
class SignedPreviewOptionsTests {

    private static final String FILE = "https://files.example/doc/report.docx";

    private final SignedPreviewFilter filter = new SignedPreviewFilter();
    private String body;

    @BeforeEach
    void setup() {
        resetConfig();
        ConfigConstants.setSignedPreviewEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
    }

    @AfterEach
    void restore() {
        RequestContextHolder.resetRequestAttributes();
        resetConfig();
    }

    /** 放行则返回到达后面的请求，被拒返回 null（提示页内容记在 body 里）。 */
    private HttpServletRequest run(MockHttpServletRequest request) throws Exception {
        MockHttpServletResponse response = new MockHttpServletResponse();
        HttpServletRequest[] reached = new HttpServletRequest[1];
        filter.doFilter(request, response, (req, res) -> reached[0] = (HttpServletRequest) req);
        assertEquals(response.getStatus() == 200, reached[0] != null);
        body = response.getContentAsString();
        return reached[0];
    }

    private MockHttpServletRequest preview(String token) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setParameter("token", token);
        return request;
    }

    /** 模拟一次已经通过签名校验的压缩包预览请求，取页面会拿到的那枚压缩包令牌的载荷。 */
    private Map<String, Object> issuedArchiveClaims(Map<String, Object> outerClaims) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setAttribute("baseUrl", "https://preview.example/");
        request.setAttribute(SignedPreviewUtils.CLAIMS_ATTRIBUTE, outerClaims);
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
        String query = SignedPreviewUtils.currentArchiveTokenQuery("archive.zip_");
        return query.isEmpty() ? null : verified(query.substring(query.indexOf('=') + 1));
    }

    @Test
    void useClaimNameAndValuesAreConfigurable() throws Exception {
        ConfigConstants.setSignedPreviewClaimUseValue("purpose");
        ConfigConstants.setSignedPreviewUsePreviewValue("doc-view");
        ConfigConstants.setSignedPreviewUseArchiveValue("doc-pack");
        ConfigConstants.setSignedPreviewUseFetchValue("doc-pull");

        assertNotNull(run(preview(token("purpose", "doc-view", "url", FILE, "exp", now() + 300))));
        // 另两种用途的值、缺省的用途值，都不是预览令牌
        assertNull(run(preview(token("purpose", "doc-pull", "url", FILE, "exp", now() + 300))));
        assertNull(run(preview(token("purpose", "doc-pack", "url", FILE, "exp", now() + 300))));
        assertNull(run(preview(token("purpose", "preview", "url", FILE, "exp", now() + 300))));

        // kkFileView 自己签发的两种令牌用的也是配置的字段名和值
        Map<String, Object> archive = issuedArchiveClaims(claims("purpose", "doc-view", "url", FILE, "exp", now() + 300));
        assertNotNull(archive);
        assertEquals("doc-pack", archive.get("purpose"));
        assertNull(archive.get("use"));
        ConfigConstants.setSignedFetchEnabledValue(true);
        Map<String, Object> fetch = verified(SignedPreviewUtils.issueFetchToken(FILE));
        assertEquals("doc-pull", fetch.get("purpose"));
        assertNull(fetch.get("use"));

        // 签出来的压缩包令牌，入口按配置的用途值认得
        MockHttpServletRequest entry = preview(token("purpose", "doc-pack", "root", "archive.zip_",
                "prefix", "https://preview.example/archive.zip_/", "exp", now() + 300));
        entry.setParameter("url", base64("https://preview.example/archive.zip_/a.txt?kkCompressfileKey=archive.zip_"
                + "&kkCompressfilepath=archive.zip_%2Fa.txt&fullfilename=a.txt"));
        assertNotNull(run(entry));
    }

    @Test
    void previewTokenMustStateItsUseWhenRequired() throws Exception {
        String withoutUse = token("url", FILE, "exp", now() + 300);
        String withUse = token("use", "preview", "url", FILE, "exp", now() + 300);
        // 缺省：不写用途也算预览令牌
        assertNotNull(run(preview(withoutUse)));
        assertNotNull(run(preview(withUse)));

        ConfigConstants.setSignedPreviewUseRequiredValue(true);
        assertNull(run(preview(withoutUse)));
        assertTrue(body.contains("签名令牌无效"), body);
        assertNotNull(run(preview(withUse)));
    }

    @Test
    void useValuesThatAreNotDistinctSwitchEverythingOffInsteadOfMixingTokens() throws Exception {
        ConfigConstants.setSignedFetchEnabledValue(true);
        String[][] badConfigs = {{"same", "same", "fetch"}, {"same", "archive", "same"}, {"preview", "same", "same"},
                {"", "archive", "fetch"}, {"preview", " ", "fetch"}};
        for (String[] values : badConfigs) {
            ConfigConstants.setSignedPreviewUsePreviewValue(values[0]);
            ConfigConstants.setSignedPreviewUseArchiveValue(values[1]);
            ConfigConstants.setSignedPreviewUseFetchValue(values[2]);
            String label = String.join("/", values);

            // 入口：带不带用途、带哪种用途都拒，提示配置有误
            assertNull(run(preview(token("url", FILE, "exp", now() + 300))), label);
            assertTrue(body.contains("配置有误"), body);
            assertNull(run(preview(token("use", "same", "url", FILE, "exp", now() + 300))), label);
            // 自己的两种令牌都不签发
            assertNull(issuedArchiveClaims(claims("url", FILE, "exp", now() + 300)), label);
            assertNull(SignedPreviewUtils.issueFetchToken(FILE), label);
        }
        // 用途字段名为空同样算配置有误
        resetConfig();
        ConfigConstants.setSignedPreviewEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
        ConfigConstants.setSignedPreviewClaimUseValue("");
        assertNull(run(preview(token("url", FILE, "exp", now() + 300))));
        assertTrue(body.contains("配置有误"), body);
    }

    @Test
    void claimMapRenamesTheRemainingWatermarkFieldsAndCurrentUrl() throws Exception {
        ConfigConstants.setSignedPreviewClaimMapValue("watermarkAlpha:wmAlpha, watermarkColor:wmColor,currentUrl:cur");

        HttpServletRequest reached = run(preview(token("url", FILE, "wmAlpha", 30, "wmColor", "red",
                "watermarkAngle", 15, "exp", now() + 300)));
        assertEquals("30", reached.getParameter("watermarkAlpha"));
        assertEquals("red", reached.getParameter("watermarkColor"));
        assertEquals("15", reached.getParameter("watermarkAngle"), "没写进映射表的仍是同名");

        // 改了名之后，原来的名字不再认
        reached = run(preview(token("url", FILE, "watermarkAlpha", 40, "exp", now() + 300)));
        assertNull(reached.getParameter("watermarkAlpha"));

        MockHttpServletRequest pictures = new MockHttpServletRequest("GET", "/picturesPreview");
        pictures.setParameter("token", token("urls", List.of("https://files.example/a.jpg", "https://files.example/b.jpg"),
                "cur", "https://files.example/b.jpg", "exp", now() + 300));
        assertEquals("https://files.example/b.jpg", unbase64(run(pictures).getParameter("currentUrl")));

        // 压缩包令牌沿用水印时用的也是映射后的字段名
        Map<String, Object> archive = issuedArchiveClaims(claims("url", FILE, "wmAlpha", 30, "exp", now() + 300));
        assertEquals(30, archive.get("wmAlpha"));
    }

    @Test
    void dedicatedClaimSettingsWinOverTheClaimMap() throws Exception {
        // 文件地址、水印文字、强制重新转换各有单独的配置项，映射表里写了也不生效
        ConfigConstants.setSignedPreviewClaimMapValue("url:src,watermarkTxt:mark,forceUpdatedCache:refresh");
        HttpServletRequest reached = run(preview(token("url", FILE, "watermarkTxt", "水印", "mark", "别的",
                "src", "https://other.example/x.docx", "refresh", true, "exp", now() + 300)));
        assertEquals(FILE, unbase64(reached.getParameter("url")));
        assertEquals("水印", reached.getParameter("watermarkTxt"));
        assertNull(reached.getParameter("forceUpdatedCache"));

        ConfigConstants.setSignedPreviewClaimWatermarkValue("label");
        reached = run(preview(token("url", FILE, "label", "单独配置的", "mark", "别的", "exp", now() + 300)));
        assertEquals("单独配置的", reached.getParameter("watermarkTxt"));
    }

    @Test
    void allowListCanRestrictTheValuesOfAParameter() throws Exception {
        ConfigConstants.setSignedPreviewAllowParamsValue("officePreviewType=image|pdf|html, page");
        String token = token("url", FILE, "exp", now() + 300);

        for (String allowed : new String[]{"image", "pdf", "html"}) {
            MockHttpServletRequest request = preview(token);
            request.setParameter("officePreviewType", allowed);
            assertEquals(allowed, run(request).getParameter("officePreviewType"));
        }
        // 不在列出的值里：丢掉这个参数，请求本身照常放行
        for (String rejected : new String[]{"allImages", "Image", " image", "image ", "", "image|pdf"}) {
            MockHttpServletRequest request = preview(token);
            request.setParameter("officePreviewType", rejected);
            request.setParameter("page", "any value 任意");
            HttpServletRequest reached = run(request);
            assertNotNull(reached, rejected);
            assertNull(reached.getParameter("officePreviewType"), rejected);
            assertEquals("any value 任意", reached.getParameter("page"));
        }
        // 同一个参数给了多个值也丢掉，哪怕每个值都在名单里
        MockHttpServletRequest request = preview(token);
        request.setParameter("officePreviewType", "image", "pdf");
        HttpServletRequest reached = run(request);
        assertNotNull(reached);
        assertNull(reached.getParameterValues("officePreviewType"));
    }

    @Test
    void archiveAndFetchTokensHaveTheirOwnTtlFallingBackToTheSharedOne() {
        ConfigConstants.setSignedFetchEnabledValue(true);
        ConfigConstants.setSignedPreviewTtlValue(600);
        Map<String, Object> outer = claims("url", FILE, "exp", now() + 300);

        // 没单独配：都用 signed.preview.ttl
        assertEquals(600, ttlOf(issuedArchiveClaims(outer)));
        assertEquals(600, ttlOf(verified(SignedPreviewUtils.issueFetchToken(FILE))));

        ConfigConstants.setSignedPreviewArchiveTtlValue("1800");
        assertEquals(1800, ttlOf(issuedArchiveClaims(outer)));
        assertEquals(600, ttlOf(verified(SignedPreviewUtils.issueFetchToken(FILE))));

        ConfigConstants.setSignedFetchTtlValue("120");
        assertEquals(1800, ttlOf(issuedArchiveClaims(outer)));
        assertEquals(120, ttlOf(verified(SignedPreviewUtils.issueFetchToken(FILE))));
    }

    private static long ttlOf(Map<String, Object> claims) {
        return ((Number) claims.get("exp")).longValue() - ((Number) claims.get("iat")).longValue();
    }
}
