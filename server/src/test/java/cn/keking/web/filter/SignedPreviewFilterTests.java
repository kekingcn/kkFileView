package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.SignedPreviewUtils;
import cn.keking.utils.WebUtils;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import static cn.keking.SignedPreviewTestSupport.*;
import static org.junit.jupiter.api.Assertions.*;

class SignedPreviewFilterTests {

    private static final String FILE = "https://files.example/doc/report.docx";
    private static final String OTHER = "https://other.example/private/salary.xlsx";

    private final SignedPreviewFilter filter = new SignedPreviewFilter();

    /** 一次过滤的结果：状态码、提示页内容、放行到后面的那个请求（被拒时为 null）。 */
    private static final class Outcome {
        int status;
        String body;
        HttpServletRequest reached;
    }

    @BeforeEach
    void setup() {
        resetConfig();
        ConfigConstants.setSignedPreviewEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
    }

    @AfterEach
    void restore() {
        resetConfig();
        ConfigConstants.setTrustHostValue("default");
        ConfigConstants.setNotTrustHostValue("default");
    }

    private Outcome run(MockHttpServletRequest request) throws Exception {
        MockHttpServletResponse response = new MockHttpServletResponse();
        Outcome outcome = new Outcome();
        filter.doFilter(request, response, (req, res) -> outcome.reached = (HttpServletRequest) req);
        outcome.status = response.getStatus();
        outcome.body = response.getContentAsString();
        assertEquals(outcome.status == 200, outcome.reached != null, "只有放行的请求才是 200");
        return outcome;
    }

    private MockHttpServletRequest preview(String token) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        if (token != null) {
            request.setParameter("token", token);
        }
        return request;
    }

    private static String urlOf(HttpServletRequest request) {
        return unbase64(request.getParameter("url"));
    }

    @Test
    void disabledPassesTheUntouchedRequestWithOrWithoutToken() throws Exception {
        ConfigConstants.setSignedPreviewEnabledValue(false);
        String validToken = token("url", FILE, "watermarkTxt", "来自令牌", "exp", now() + 300);
        for (String token : new String[]{null, "not-a-token", validToken}) {
            MockHttpServletRequest request = preview(token);
            request.setParameter("url", base64(OTHER));
            request.setParameter("watermarkTxt", "来自请求");
            request.setParameter("forceUpdatedCache", "true");
            request.setParameter("kkagent", "true");
            Outcome outcome = run(request);
            assertEquals(200, outcome.status);
            assertSame(request, outcome.reached, "关闭时请求应原样往后传，不换成别的对象");
            assertEquals(OTHER, urlOf(outcome.reached));
            assertEquals("来自请求", outcome.reached.getParameter("watermarkTxt"));
            assertEquals("true", outcome.reached.getParameter("forceUpdatedCache"));
            assertEquals("true", outcome.reached.getParameter("kkagent"));
            assertEquals(token, outcome.reached.getParameter("token"));
            assertNull(outcome.reached.getAttribute(SignedPreviewUtils.CLAIMS_ATTRIBUTE));
        }
    }

    @Test
    void enabledRejectsRequestWithoutToken() throws Exception {
        MockHttpServletRequest request = preview(null);
        request.setParameter("url", base64(FILE));
        Outcome outcome = run(request);
        assertEquals(403, outcome.status);
        assertTrue(outcome.body.contains("缺少签名令牌"), outcome.body);

        assertEquals(403, run(preview("")).status);
    }

    @Test
    void enabledAcceptsValidTokenAndExposesItsClaims() throws Exception {
        Outcome outcome = run(preview(token("url", FILE, "exp", now() + 300)));
        assertEquals(200, outcome.status);
        assertEquals(FILE, urlOf(outcome.reached));
        Object claims = outcome.reached.getAttribute(SignedPreviewUtils.CLAIMS_ATTRIBUTE);
        assertInstanceOf(Map.class, claims);
        assertEquals(FILE, ((Map<?, ?>) claims).get("url"));
    }

    @Test
    void enabledRejectsExpiredToken() throws Exception {
        Outcome outcome = run(preview(token("url", FILE, "exp", now() - 3600)));
        assertEquals(403, outcome.status);
        assertTrue(outcome.body.contains("已过期"), outcome.body);
    }

    @Test
    void leewayToleratesSmallClockDifferenceOnly() throws Exception {
        String justExpired = token("url", FILE, "exp", now() - 10);
        ConfigConstants.setSignedPreviewLeewayValue(30);
        assertEquals(200, run(preview(justExpired)).status);
        ConfigConstants.setSignedPreviewLeewayValue(0);
        assertEquals(403, run(preview(justExpired)).status);
    }

    @Test
    void enabledRejectsTokenWithoutExpiry() throws Exception {
        assertEquals(403, run(preview(token("url", FILE))).status);
        assertEquals(403, run(preview(token("url", FILE, "exp", "never"))).status);
    }

    @Test
    void enabledRejectsWrongSignature() throws Exception {
        Map<String, Object> claims = claims("url", FILE, "exp", now() + 300);
        Outcome outcome = run(preview(sign("HS256", "HmacSHA256", "another-secret-0123456789abcdef", claims)));
        assertEquals(403, outcome.status);
        assertTrue(outcome.body.contains("签名令牌无效"), outcome.body);

        // 签名是对的，但载荷换成了别的文件
        String[] good = token("url", FILE, "exp", now() + 300).split("\\.");
        String[] forged = token("url", OTHER, "exp", now() + 300).split("\\.");
        assertEquals(403, run(preview(good[0] + "." + forged[1] + "." + good[2])).status);

        assertEquals(403, run(preview("not-a-token")).status);
        assertEquals(403, run(preview("a.b.c")).status);
    }

    @Test
    void enabledRejectsTokenWhoseAlgorithmDiffersFromConfigured() throws Exception {
        Map<String, Object> claims = claims("url", FILE, "exp", now() + 300);
        // 不签名
        assertEquals(403, run(preview(sign("none", null, SECRET, claims))).status);
        // 头里写 none，但带着一段按 HS256 算出来的签名
        assertEquals(403, run(preview(sign("none", "HmacSHA256", SECRET, claims))).status);
        assertEquals(403, run(preview(sign("None", "HmacSHA256", SECRET, claims))).status);
        // 密钥对、签名也对，但算法不是配置的那个
        assertEquals(403, run(preview(sign("HS512", "HmacSHA512", SECRET, claims))).status);
        // 头里写 HS256，实际用 HS512 算
        assertEquals(403, run(preview(sign("HS256", "HmacSHA512", SECRET, claims))).status);

        // 对照：配置成 HS512 之后，HS512 的令牌通过，HS256 的反而不通过
        ConfigConstants.setSignedPreviewAlgorithmValue("HS512");
        assertEquals(200, run(preview(sign("HS512", "HmacSHA512", SECRET, claims))).status);
        assertEquals(403, run(preview(sign("HS256", "HmacSHA256", SECRET, claims))).status);
    }

    @Test
    void enabledWithoutSecretRejectsEveryRequest() throws Exception {
        ConfigConstants.setSignedPreviewSecretValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_SECRET);
        Map<String, Object> claims = claims("url", FILE, "exp", now() + 300);
        Outcome outcome = run(preview(sign("HS256", "HmacSHA256", ConfigConstants.DEFAULT_SIGNED_PREVIEW_SECRET, claims)));
        assertEquals(403, outcome.status);
        assertTrue(outcome.body.contains("未配置密钥"), outcome.body);

        ConfigConstants.setSignedPreviewSecretValue(" ");
        assertEquals(403, run(preview(sign("HS256", "HmacSHA256", " ", claims))).status);
    }

    @Test
    void tokenUrlWinsOverEverySourceTheBrowserSends() throws Exception {
        MockHttpServletRequest request = preview(token("url", FILE, "exp", now() + 300));
        request.addParameter("url", base64(OTHER));
        request.addParameter("url", base64(OTHER));
        request.setParameter("urls", base64(OTHER));
        request.setParameter("currentUrl", base64(OTHER));
        request.setParameter("urlPath", base64(OTHER));
        request.setParameter("encryption", "aes");
        Outcome outcome = run(request);
        assertEquals(200, outcome.status);
        assertEquals(FILE, urlOf(outcome.reached));
        assertEquals(1, outcome.reached.getParameterValues("url").length);
        assertNull(outcome.reached.getParameter("urls"));
        assertNull(outcome.reached.getParameter("currentUrl"));
        assertNull(outcome.reached.getParameter("urlPath"));
        assertNull(outcome.reached.getParameter("encryption"));
        // 后面的信任站点、信任目录两个过滤器就是用这个方法取地址的
        assertEquals(List.of(FILE), WebUtils.getSourceUrls(outcome.reached));
    }

    @Test
    void trustHostCheckStillAppliesToTheTokenUrl() throws Exception {
        ConfigConstants.setTrustHostValue("files.example");
        TrustHostFilter trustHostFilter = new TrustHostFilter();
        for (String[] expectation : new String[][]{{FILE, "200"}, {OTHER, "403"}}) {
            MockHttpServletRequest request = preview(token("url", expectation[0], "exp", now() + 300));
            request.setParameter("url", base64(FILE));
            MockHttpServletResponse response = new MockHttpServletResponse();
            filter.doFilter(request, response, (req, res) -> trustHostFilter.doFilter(req, res, (r, s) -> { }));
            assertEquals(Integer.parseInt(expectation[1]), response.getStatus(), expectation[0]);
        }
    }

    @Test
    void watermarkComesFromTokenNotFromRequest() throws Exception {
        MockHttpServletRequest request = preview(token("url", FILE, "watermarkTxt", "张三 0012",
                "watermarkAlpha", 30, "watermarkColor", "red", "exp", now() + 300));
        request.setParameter("watermarkTxt", "");
        request.setParameter("watermarkAlpha", "0");
        request.setParameter("watermarkFontsize", "1px");
        Outcome outcome = run(request);
        assertEquals("张三 0012", outcome.reached.getParameter("watermarkTxt"));
        assertEquals("30", outcome.reached.getParameter("watermarkAlpha"));
        assertEquals("red", outcome.reached.getParameter("watermarkColor"));
        assertNull(outcome.reached.getParameter("watermarkFontsize"));

        // 令牌里没写水印时，请求里带的水印同样不生效（回到配置文件里的缺省水印）
        request = preview(token("url", FILE, "exp", now() + 300));
        request.setParameter("watermarkTxt", "自己加的");
        assertNull(run(request).reached.getParameter("watermarkTxt"));
    }

    @Test
    void forceUpdateComesFromTokenAndIsHonouredOncePerToken() throws Exception {
        MockHttpServletRequest request = preview(token("url", FILE, "exp", now() + 300));
        request.setParameter("forceUpdatedCache", "true");
        assertNull(run(request).reached.getParameter("forceUpdatedCache"));

        String forcing = token("url", FILE, "forceUpdatedCache", true, "exp", now() + 300, "jti", "first");
        assertEquals("true", run(preview(forcing)).reached.getParameter("forceUpdatedCache"));
        // 转换中的等待页会带着同一枚令牌整页刷新，第二次起不再强制重新转换
        assertNull(run(preview(forcing)).reached.getParameter("forceUpdatedCache"));
        assertNull(run(preview(forcing)).reached.getParameter("forceUpdatedCache"));

        // 另一枚令牌不受影响；字符串形式的 true 也认
        String another = token("url", FILE, "forceUpdatedCache", "true", "exp", now() + 300, "jti", "second");
        assertEquals("true", run(preview(another)).reached.getParameter("forceUpdatedCache"));
        String notForcing = token("url", FILE, "forceUpdatedCache", false, "exp", now() + 300);
        assertNull(run(preview(notForcing)).reached.getParameter("forceUpdatedCache"));
    }

    @Test
    void onlyAllowListedBrowserParametersSurvive() throws Exception {
        String token = token("url", FILE, "exp", now() + 300);
        MockHttpServletRequest request = preview(token);
        request.setParameter("officePreviewType", "image");
        request.setParameter("tifPreviewType", "jpg");
        request.setParameter("page", "3");
        request.setParameter("highlightall", "true");
        request.setParameter("filePassword", "123456");
        request.setParameter("key", "abc");
        request.setParameter("kkagent", "true");
        request.setParameter("usePasswordCache", "true");
        request.setParameter("anything", "else");
        Outcome outcome = run(request);
        assertEquals(200, outcome.status);
        Set<String> expected = new TreeSet<>(Set.of("url", "officePreviewType", "tifPreviewType", "page",
                "highlightall", "filePassword", "key"));
        assertEquals(expected, new TreeSet<>(outcome.reached.getParameterMap().keySet()));
        assertEquals(expected, new TreeSet<>(Collections.list(outcome.reached.getParameterNames())));
        assertEquals("image", outcome.reached.getParameter("officePreviewType"));
        assertEquals("3", outcome.reached.getParameter("page"));
        assertArrayEquals(new String[]{"123456"}, outcome.reached.getParameterValues("filePassword"));
        assertNull(outcome.reached.getParameter("kkagent"));
        assertNull(outcome.reached.getParameter("usePasswordCache"));
        assertNull(outcome.reached.getParameter("anything"));
        assertNull(outcome.reached.getParameter("token"));

        // 放行名单可配
        ConfigConstants.setSignedPreviewAllowParamsValue("page, kkagent");
        outcome = run(request);
        assertEquals(new TreeSet<>(Set.of("url", "page", "kkagent")), new TreeSet<>(outcome.reached.getParameterMap().keySet()));
    }

    @Test
    void allowListCannotHandTokenOwnedParametersBackToTheBrowser() throws Exception {
        ConfigConstants.setSignedPreviewAllowParamsValue(
                "url,urls,currentUrl,urlPath,encryption,watermarkTxt,watermarkAlpha,forceUpdatedCache,token,page");
        MockHttpServletRequest request = preview(token("url", FILE, "exp", now() + 300));
        request.setParameter("url", base64(OTHER));
        request.setParameter("urlPath", base64(OTHER));
        request.setParameter("encryption", "aes");
        request.setParameter("watermarkTxt", "自己加的");
        request.setParameter("watermarkAlpha", "0");
        request.setParameter("forceUpdatedCache", "true");
        request.setParameter("page", "2");
        Outcome outcome = run(request);
        assertEquals(new TreeSet<>(Set.of("url", "page")), new TreeSet<>(outcome.reached.getParameterMap().keySet()));
        assertEquals(FILE, urlOf(outcome.reached));
    }

    @Test
    void fileNameClaimIsCarriedInTheUrlTheSameWayAsToday() throws Exception {
        String encodedName = URLEncoder.encode("年度 报告.docx", StandardCharsets.UTF_8);
        Outcome outcome = run(preview(token("url", "https://files.example/download/42",
                "fullfilename", "年度 报告.docx", "exp", now() + 300)));
        assertEquals("https://files.example/download/42?fullfilename=" + encodedName, urlOf(outcome.reached));

        outcome = run(preview(token("url", "https://files.example/download?id=42",
                "fullfilename", "年度 报告.docx", "exp", now() + 300)));
        assertEquals("https://files.example/download?id=42&fullfilename=" + encodedName, urlOf(outcome.reached));
    }

    @Test
    void tokenParameterAndClaimNamesAreConfigurable() throws Exception {
        ConfigConstants.setSignedPreviewTokenParamValue("ticket");
        ConfigConstants.setSignedPreviewClaimUrlValue("src");
        ConfigConstants.setSignedPreviewClaimFilenameValue("name");
        ConfigConstants.setSignedPreviewClaimWatermarkValue("mark");
        ConfigConstants.setSignedPreviewClaimForceValue("refresh");

        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setParameter("ticket", token("src", FILE, "name", "a.docx", "mark", "水印", "refresh", true, "exp", now() + 300));
        Outcome outcome = run(request);
        assertEquals(200, outcome.status);
        assertEquals(FILE + "?fullfilename=a.docx", urlOf(outcome.reached));
        assertEquals("水印", outcome.reached.getParameter("watermarkTxt"));
        assertEquals("true", outcome.reached.getParameter("forceUpdatedCache"));
        assertNull(outcome.reached.getParameter("ticket"));

        // 改名之后，缺省名字的参数和字段都不再认
        assertEquals(403, run(preview(token("src", FILE, "exp", now() + 300))).status);
        request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setParameter("ticket", token("url", FILE, "exp", now() + 300));
        assertEquals(403, run(request).status);
    }

    @Test
    void picturesPreviewTakesItsImagesFromTheToken() throws Exception {
        String a = "https://files.example/a.jpg";
        String b = "https://files.example/b.jpg";
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/picturesPreview");
        request.setParameter("token", token("urls", List.of(a, b), "currentUrl", b, "exp", now() + 300));
        request.setParameter("urls", base64(OTHER));
        request.setParameter("currentUrl", base64(OTHER));
        Outcome outcome = run(request);
        assertEquals(200, outcome.status);
        assertEquals(a + "|" + b, unbase64(outcome.reached.getParameter("urls")));
        assertEquals(b, unbase64(outcome.reached.getParameter("currentUrl")));
        assertNull(outcome.reached.getParameter("url"));
        assertEquals(List.of(b, a, b), WebUtils.getSourceUrls(outcome.reached));

        // 也可以直接给用 | 分隔的字符串；不给 currentUrl 时请求里带的也不生效
        request.setParameter("token", token("urls", a + "|" + b, "exp", now() + 300));
        outcome = run(request);
        assertEquals(a + "|" + b, unbase64(outcome.reached.getParameter("urls")));
        assertNull(outcome.reached.getParameter("currentUrl"));

        // 只有单个文件地址的令牌不能拿来开多图预览，反过来也一样
        request.setParameter("token", token("url", a, "exp", now() + 300));
        assertEquals(403, run(request).status);
        assertEquals(403, run(preview(token("urls", List.of(a, b), "exp", now() + 300))).status);
    }

    @Test
    void tokensIssuedForOtherPurposesAreNotPreviewTokens() throws Exception {
        assertEquals(200, run(preview(token("use", "preview", "url", FILE, "exp", now() + 300))).status);
        // 取原文件时带的那种令牌里也有 url，不能反过来当预览令牌用
        assertEquals(403, run(preview(token("use", "fetch", "url", FILE, "exp", now() + 300))).status);
        assertEquals(403, run(preview(token("use", "something-else", "url", FILE, "exp", now() + 300))).status);
    }
}
