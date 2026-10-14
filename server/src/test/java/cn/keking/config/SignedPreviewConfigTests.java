package cn.keking.config;

import cn.keking.web.filter.SignedPreviewFilter;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.core.io.ClassPathResource;

import java.nio.charset.StandardCharsets;

import static org.junit.jupiter.api.Assertions.*;

class SignedPreviewConfigTests {

    @ParameterizedTest
    @ValueSource(strings = {"application.properties", "test.properties"})
    void shippedConfigKeepsSignedPreviewAndSignedFetchOff(String file) throws Exception {
        String properties = new String(new ClassPathResource(file).getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        assertTrue(properties.contains("signed.preview.enabled = ${KK_SIGNED_PREVIEW_ENABLED:false}"));
        assertTrue(properties.contains("signed.fetch.enabled = ${KK_SIGNED_FETCH_ENABLED:false}"));
        assertTrue(properties.contains("signed.preview.secret = ${KK_SIGNED_PREVIEW_SECRET:false}"));
    }

    @ParameterizedTest
    @ValueSource(strings = {"application.properties", "test.properties"})
    void shippedConfigListsEveryOptionWithItsDefault(String file) throws Exception {
        String properties = new String(new ClassPathResource(file).getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        for (String line : new String[]{
                "signed.preview.claim.use = ${KK_SIGNED_PREVIEW_CLAIM_USE:use}",
                "signed.preview.use.preview = ${KK_SIGNED_PREVIEW_USE_PREVIEW:preview}",
                "signed.preview.use.archive = ${KK_SIGNED_PREVIEW_USE_ARCHIVE:archive}",
                "signed.preview.use.fetch = ${KK_SIGNED_PREVIEW_USE_FETCH:fetch}",
                "signed.preview.use.required = ${KK_SIGNED_PREVIEW_USE_REQUIRED:false}",
                "signed.preview.claim.map = ${KK_SIGNED_PREVIEW_CLAIM_MAP:default}",
                "signed.preview.archive.ttl = ${KK_SIGNED_PREVIEW_ARCHIVE_TTL:default}",
                "signed.fetch.ttl = ${KK_SIGNED_FETCH_TTL:default}",
                "signed.fetch.claim.url = ${KK_SIGNED_FETCH_CLAIM_URL:url}",
                "signed.fetch.header.prefix = ${KK_SIGNED_FETCH_HEADER_PREFIX:default}",
                "signed.preview.allow.params = ${KK_SIGNED_PREVIEW_ALLOW_PARAMS:officePreviewType,tifPreviewType,page,highlightall,filePassword,key}"}) {
            assertTrue(properties.contains(line + '\n'), line);
        }
    }

    @Test
    void defaultsUsedWhenNothingIsConfiguredKeepBothSwitchesOff() {
        assertEquals("false", ConfigConstants.DEFAULT_SIGNED_PREVIEW_ENABLED);
        assertEquals("false", ConfigConstants.DEFAULT_SIGNED_FETCH_ENABLED);
    }

    @Test
    void signedPreviewFilterCoversBothPreviewEntriesAndRunsBeforeTheTrustFilters() {
        WebConfig webConfig = new WebConfig();
        FilterRegistrationBean<SignedPreviewFilter> registration = webConfig.getSignedPreviewFilter();
        assertEquals(2, registration.getUrlPatterns().size());
        assertTrue(registration.getUrlPatterns().contains("/onlinePreview"));
        assertTrue(registration.getUrlPatterns().contains("/picturesPreview"));
        // 在统一字符集的过滤器之后，在信任站点、信任目录、水印三个过滤器之前
        assertTrue(registration.getOrder() > webConfig.getChinesePathFilter().getOrder());
        assertTrue(registration.getOrder() < webConfig.getTrustHostFilter().getOrder());
        assertTrue(registration.getOrder() < webConfig.getTrustDirFilter().getOrder());
        assertTrue(registration.getOrder() < webConfig.getWatermarkConfigFilter().getOrder());
    }
}
