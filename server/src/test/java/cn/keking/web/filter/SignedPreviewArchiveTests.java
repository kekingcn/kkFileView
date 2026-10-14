package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.FileHandlerService;
import cn.keking.service.impl.CompressFilePreviewImpl;
import cn.keking.utils.SignedPreviewUtils;
import freemarker.template.Configuration;
import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.io.StringWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import static cn.keking.SignedPreviewTestSupport.*;
import static org.junit.jupiter.api.Assertions.*;

class SignedPreviewArchiveTests {

    private static final String BASE_URL = "https://preview.example/";
    private static final String ROOT = "archive.zip_";

    @TempDir Path temp;
    private String previousDir;
    private Boolean previousCache;
    private final SignedPreviewFilter filter = new SignedPreviewFilter();

    @BeforeEach
    void setup() throws Exception {
        previousDir = ConfigConstants.getFileDir();
        previousCache = ConfigConstants.isCacheEnabled();
        ConfigConstants.setFileDirValue(temp.toString());
        ConfigConstants.setCacheEnabledValueValue(true);
        Files.createDirectories(temp.resolve(ROOT + "/nested"));
        Files.writeString(temp.resolve(ROOT + "/nested/visible.txt"), "visible");
        resetConfig();
        ConfigConstants.setSignedPreviewEnabledValue(true);
        ConfigConstants.setSignedPreviewSecretValue(SECRET);
    }

    @AfterEach
    void restore() {
        RequestContextHolder.resetRequestAttributes();
        ConfigConstants.setFileDirValue(previousDir);
        ConfigConstants.setCacheEnabledValueValue(previousCache);
        resetConfig();
    }

    /** 模拟「压缩包的预览请求已经过了签名校验」：请求上挂着校验过的令牌内容和 baseUrl。 */
    private void withinVerifiedRequest(Map<String, Object> claims) {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/onlinePreview");
        request.setAttribute("baseUrl", BASE_URL);
        if (claims != null) {
            request.setAttribute(SignedPreviewUtils.CLAIMS_ATTRIBUTE, claims);
        }
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));
    }

    private ExtendedModelMap archivePage() {
        FileHandlerService handler = new FileHandlerService(null) {
            @Override public String getConvertedFile(String name) { return ROOT; }
        };
        FileAttribute file = new FileAttribute();
        file.setName("archive.zip");
        ExtendedModelMap model = new ExtendedModelMap();
        assertEquals("compress", new CompressFilePreviewImpl(handler, null, null)
                .filePreviewHandle("https://files.example/archive.zip", model, file));
        return model;
    }

    private String render(ExtendedModelMap model) throws Exception {
        model.put("baseUrl", BASE_URL);
        for (String name : new String[]{"watermarkXSpace", "watermarkYSpace", "watermarkAlpha",
                "watermarkWidth", "watermarkHeight", "watermarkAngle"}) { model.put(name, "0"); }
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_32);
        cfg.setClassForTemplateLoading(getClass(), "/web");
        cfg.setClassicCompatible(true);
        StringWriter output = new StringWriter();
        cfg.getTemplate("compress.ftl").process(model, output);
        return output.toString();
    }

    /** 与 compress.ftl 的 buildPreviewUrl 拼法一致的包内文件地址。 */
    private static String entryUrl(String root, String id, String name) {
        return BASE_URL + id + "?kkCompressfileKey=" + root
                + "&kkCompressfilepath=" + URLEncoder.encode(id, StandardCharsets.UTF_8)
                + "&fullfilename=" + URLEncoder.encode(name, StandardCharsets.UTF_8);
    }

    private static String archiveToken(String root, long exp) {
        return token("use", "archive", "root", root, "prefix", BASE_URL + root + "/",
                "watermarkTxt", "张三 0012", "exp", exp);
    }

    private HttpServletRequest open(String path, String token, String url) throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", path);
        request.setParameter("token", token);
        request.setParameter(path.endsWith("picturesPreview") ? "urls" : "url", base64(url));
        request.setParameter("watermarkTxt", "");
        MockHttpServletResponse response = new MockHttpServletResponse();
        HttpServletRequest[] reached = new HttpServletRequest[1];
        filter.doFilter(request, response, (req, res) -> reached[0] = (HttpServletRequest) req);
        assertEquals(response.getStatus() == 200, reached[0] != null);
        return reached[0];
    }

    @Test
    void archivePageIsUnchangedWhenDisabled() throws Exception {
        ConfigConstants.setSignedPreviewEnabledValue(false);
        withinVerifiedRequest(claims("url", "https://files.example/archive.zip", "exp", now() + 300));
        ExtendedModelMap model = archivePage();
        assertNull(model.get("archiveTokenQuery"));
        String page = render(model);
        assertTrue(page.contains("previewUrl += \"&key="), "模板原有的拼接还在");
        assertFalse(page.contains("token="), "关闭时页面里不应出现令牌");
    }

    @Test
    void archivePageRendersWithoutTokenOutsideAVerifiedRequest() throws Exception {
        // 不在一次请求里
        assertNull(archivePage().get("archiveTokenQuery"));
        // 在请求里，但这次请求没有经过签名校验
        withinVerifiedRequest(null);
        ExtendedModelMap model = archivePage();
        assertNull(model.get("archiveTokenQuery"));
        assertFalse(render(model).contains("token="));
    }

    @Test
    void archivePageCarriesATokenBoundToThatArchive() throws Exception {
        ConfigConstants.setSignedPreviewTtlValue(120);
        withinVerifiedRequest(claims("url", "https://files.example/archive.zip", "watermarkTxt", "张三 0012",
                "watermarkAlpha", 30, "forceUpdatedCache", true, "exp", now() + 300));
        ExtendedModelMap model = archivePage();
        String query = (String) model.get("archiveTokenQuery");
        assertNotNull(query, "开启后压缩包页面应拿到一枚令牌");
        assertTrue(query.startsWith("&token="), query);

        Map<String, Object> issued = verified(query.substring("&token=".length()));
        assertEquals("archive", issued.get("use"));
        assertEquals(ROOT, issued.get("root"));
        assertEquals(BASE_URL + ROOT + "/", issued.get("prefix"));
        assertEquals("张三 0012", issued.get("watermarkTxt"));
        assertEquals(30, issued.get("watermarkAlpha"));
        assertNull(issued.get("url"), "压缩包令牌里不带外层的文件地址");
        assertNull(issued.get("forceUpdatedCache"));
        long exp = ((Number) issued.get("exp")).longValue();
        assertTrue(exp >= now() + 110 && exp <= now() + 125, "有效期按 signed.preview.ttl 算：" + (exp - now()));

        assertTrue(render(model).contains("previewUrl += \"" + query + "\";"), "模板拼包内文件链接时要带上令牌");
    }

    @Test
    void tokenIssuedByTheArchivePageOpensItsOwnEntries() throws Exception {
        withinVerifiedRequest(claims("url", "https://files.example/archive.zip", "watermarkTxt", "张三 0012", "exp", now() + 300));
        String query = (String) archivePage().get("archiveTokenQuery");
        assertNotNull(query);
        String url = entryUrl(ROOT, ROOT + "/nested/visible.txt", "visible.txt");
        HttpServletRequest reached = open("/onlinePreview", query.substring("&token=".length()), url);
        assertNotNull(reached, "本压缩包里的文件应放行");
        assertEquals(url, unbase64(reached.getParameter("url")));
        assertEquals("张三 0012", reached.getParameter("watermarkTxt"), "水印沿用打开压缩包时令牌里的");
    }

    @Test
    void archiveTokenOnlyOpensEntriesOfItsOwnArchive() throws Exception {
        String token = archiveToken(ROOT, now() + 300);
        // 对照：本压缩包里的文件放行
        assertNotNull(open("/onlinePreview", token, entryUrl(ROOT, ROOT + "/nested/visible.txt", "visible.txt")));
        assertNotNull(open("/onlinePreview", token, entryUrl(ROOT, ROOT + "/名字 带空格.txt", "名字 带空格.txt")));

        // 别的压缩包
        assertNull(open("/onlinePreview", token, entryUrl("other.zip_", "other.zip_/secret.txt", "secret.txt")));
        // 压缩包名对得上，路径却指到别处
        assertNull(open("/onlinePreview", token, entryUrl(ROOT, "other.zip_/secret.txt", "secret.txt")));
        assertNull(open("/onlinePreview", token, entryUrl(ROOT, ROOT + "/../other.zip_/secret.txt", "secret.txt")));
        assertNull(open("/onlinePreview", token, BASE_URL + ROOT + "/a.txt?kkCompressfileKey=" + ROOT
                + "&kkCompressfilepath=" + ROOT + "%2F%2e%2e%2Fprivate.pdf&fullfilename=a.txt"));
        assertNull(open("/onlinePreview", token, BASE_URL + ROOT + "/a.txt?kkCompressfileKey=" + ROOT
                + "&kkCompressfilepath=" + ROOT + "%252F%252e%252e%252Fprivate.pdf&fullfilename=a.txt"));
        assertNull(open("/onlinePreview", token, BASE_URL + ROOT + "/a.txt?kkCompressfileKey=" + ROOT
                + "&kkCompressfilepath=" + ROOT + "%5C..%5Cprivate.pdf&fullfilename=a.txt"));
        assertNull(open("/onlinePreview", token, BASE_URL + ROOT + "/../other.zip_/secret.txt?kkCompressfileKey=" + ROOT
                + "&kkCompressfilepath=" + ROOT + "%2Fa.txt&fullfilename=a.txt"));
        // 普通文件地址：不带压缩包参数的、带着压缩包参数但不在本服务的压缩包目录下的
        assertNull(open("/onlinePreview", token, "https://files.example/doc/report.docx"));
        assertNull(open("/onlinePreview", token, "https://files.example/doc/report.docx?kkCompressfileKey=" + ROOT
                + "&kkCompressfilepath=" + ROOT + "%2Fnested%2Fvisible.txt&fullfilename=visible.txt"));
        assertNull(open("/onlinePreview", token, BASE_URL + "report.docx"));
        // 多图预览不认压缩包令牌
        assertNull(open("/picturesPreview", token, BASE_URL + ROOT + "/nested/a.jpg"));
        // 过期
        assertNull(open("/onlinePreview", archiveToken(ROOT, now() - 3600),
                entryUrl(ROOT, ROOT + "/nested/visible.txt", "visible.txt")));
    }
}
