package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.concurrent.atomic.AtomicBoolean;

import static org.junit.jupiter.api.Assertions.*;

class PreviewSourceSecurityTests {
    private String previousLocalDir;
    @BeforeEach void setup() {
        previousLocalDir = ConfigConstants.getLocalPreviewDir();
        ConfigConstants.setLocalPreviewDirValue("/allowed-preview-root");
        ConfigConstants.setTrustHostValue("files.example");
        ConfigConstants.setNotTrustHostValue("127.0.0.1");
    }
    @AfterEach void restore() {
        org.springframework.test.util.ReflectionTestUtils.setField(ConfigConstants.class, "localPreviewDir", previousLocalDir);
        ConfigConstants.setTrustHostValue("default");
        ConfigConstants.setNotTrustHostValue("default");
    }
    private String encoded(String url) {
        return Base64.getEncoder().encodeToString(url.getBytes(StandardCharsets.UTF_8));
    }
    private MockHttpServletResponse filter(MockHttpServletRequest request) throws Exception {
        MockHttpServletResponse response = new MockHttpServletResponse();
        AtomicBoolean reached = new AtomicBoolean();
        new TrustHostFilter().doFilter(request, response, (req, res) -> reached.set(true));
        assertEquals(response.getStatus() == 200, reached.get());
        return response;
    }
    @ParameterizedTest
    @ValueSource(strings = {"url", "currentUrl", "urls"})
    void allowedDecoysCannotHideBlockedFetchTarget(String decoy) throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/getCorsFile");
        request.setParameter(decoy, encoded("https://files.example/allowed.pdf"));
        request.setParameter("urlPath", encoded("http://127.0.0.1/private.pdf"));
        assertEquals(403, filter(request).getStatus());
    }
    @Test void validatesEveryImageAndEveryRepeatedParameter() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/picturesPreview");
        request.setParameter("urls", encoded("https://files.example/a.jpg|http://127.0.0.1/b.jpg"));
        assertEquals(403, filter(request).getStatus());
        request = new MockHttpServletRequest("GET", "/getCorsFile");
        request.setParameter("urlPath", encoded("https://files.example/a.pdf"), encoded("http://127.0.0.1/a.pdf"));
        assertEquals(403, filter(request).getStatus());
    }
    @Test void preservesAllowedRequestsAndRejectsMissingOrMalformedSources() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/getCorsFile");
        assertEquals(403, filter(request).getStatus());
        request.setParameter("urlPath", "%%%bad");
        assertEquals(403, filter(request).getStatus());
        request.setParameter("urlPath", encoded("https://files.example/a.pdf"));
        assertEquals(200, filter(request).getStatus());
        request.setParameter("url", encoded("https://files.example/b.pdf"));
        assertEquals(200, filter(request).getStatus());
    }
    @Test void directoryFilterAlsoRejectsHiddenFileTargets() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/getCorsFile");
        request.setParameter("url", encoded("https://files.example/a.pdf"));
        request.setParameter("urlPath", encoded("file:///outside-preview-root/private.pdf"));
        MockHttpServletResponse response = new MockHttpServletResponse();
        new TrustDirFilter().doFilter(request, response, (req, res) -> fail("Unsafe URL reached controller"));
        assertEquals(403, response.getStatus());
    }
}
