package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 签名预览：按配置校验接入方签发的令牌，以及签发 kkFileView 自己用的两种令牌
 * （压缩包内文件、取原文件）。三种令牌用同一把密钥，靠载荷里的用途字段区分，互相不能顶替；
 * 用途字段的名字和三种用途的值都可配，配得分不清时整套功能按配置有误处理。
 */
public final class SignedPreviewUtils {

    private static final Logger logger = LoggerFactory.getLogger(SignedPreviewUtils.class);

    /**
     * 校验通过后，令牌的载荷放在请求的这个属性里
     */
    public static final String CLAIMS_ATTRIBUTE = "signedPreviewClaims";

    public static final String CLAIM_ARCHIVE_ROOT = "root";
    public static final String CLAIM_ARCHIVE_PREFIX = "prefix";

    /**
     * 除水印文字外的水印参数：令牌里的字段名缺省与请求参数名相同，可用 signed.preview.claim.map 改名
     */
    public static final List<String> WATERMARK_PARAMS = List.of("watermarkXSpace", "watermarkYSpace", "watermarkFont",
            "watermarkFontsize", "watermarkColor", "watermarkAlpha", "watermarkWidth", "watermarkHeight", "watermarkAngle");

    private SignedPreviewUtils() {
    }

    /**
     * 是否配置了密钥（缺省值 false 表示没有配置）
     */
    public static boolean isSecretConfigured() {
        String secret = ConfigConstants.getSignedPreviewSecret();
        return StringUtils.hasText(secret) && !ConfigConstants.DEFAULT_SIGNED_PREVIEW_SECRET.equalsIgnoreCase(secret.trim());
    }

    /**
     * 用途字段的配置是否可用：字段名和三种用途的值都不为空，且三个值互不相同。
     * 不满足时入口拒绝全部请求、也不签发自己的令牌，三种令牌不会被当成同一种。
     */
    public static boolean isUseConfigValid() {
        String preview = ConfigConstants.getSignedPreviewUsePreview();
        String archive = ConfigConstants.getSignedPreviewUseArchive();
        String fetch = ConfigConstants.getSignedPreviewUseFetch();
        return StringUtils.hasText(ConfigConstants.getSignedPreviewClaimUse())
                && StringUtils.hasText(preview) && StringUtils.hasText(archive) && StringUtils.hasText(fetch)
                && !preview.equals(archive) && !preview.equals(fetch) && !archive.equals(fetch);
    }

    /**
     * 取原文件时这一次是否真的会带令牌：开关开着、配了密钥、用途配置可用
     */
    public static boolean isFetchSigningActive() {
        return ConfigConstants.isSignedFetchEnabled() && isSecretConfigured() && isUseConfigValid();
    }

    /**
     * 请求参数在令牌里对应的字段名（用于其余水印参数和 currentUrl）
     */
    public static String claimName(String param) {
        return ConfigConstants.getSignedPreviewClaimMap().getOrDefault(param, param);
    }

    /**
     * 按配置的密钥、算法、时钟误差校验令牌
     */
    public static Map<String, Object> verify(String token) throws JwtUtils.JwtException {
        return JwtUtils.verify(token, ConfigConstants.getSignedPreviewSecret(),
                ConfigConstants.getSignedPreviewAlgorithm(), ConfigConstants.getSignedPreviewLeeway());
    }

    /**
     * 压缩包预览页拼包内文件链接时要追加的那一段（&amp;参数名=令牌）。
     * 只有当前请求通过了签名校验才签发；签名预览没开、不在一次请求里、请求没有校验过时返回空串。
     *
     * @param root 压缩包解开后的目录名
     */
    public static String currentArchiveTokenQuery(String root) {
        if (!ConfigConstants.isSignedPreviewEnabled() || !isSecretConfigured() || !isUseConfigValid() || !StringUtils.hasText(root)) {
            return "";
        }
        RequestAttributes attributes = RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return "";
        }
        Object verified = attributes.getAttribute(CLAIMS_ATTRIBUTE, RequestAttributes.SCOPE_REQUEST);
        Object baseUrl = attributes.getAttribute("baseUrl", RequestAttributes.SCOPE_REQUEST);
        if (!(verified instanceof Map<?, ?> outerClaims) || !(baseUrl instanceof String)) {
            return "";
        }
        Map<String, Object> claims = new LinkedHashMap<>();
        claims.put(ConfigConstants.getSignedPreviewClaimUse(), ConfigConstants.getSignedPreviewUseArchive());
        claims.put(CLAIM_ARCHIVE_ROOT, root);
        claims.put(CLAIM_ARCHIVE_PREFIX, baseUrl + root + "/");
        // 水印沿用打开压缩包时那枚令牌里的
        copyClaim(outerClaims, claims, ConfigConstants.getSignedPreviewClaimWatermark());
        WATERMARK_PARAMS.forEach(name -> copyClaim(outerClaims, claims, claimName(name)));
        return "&" + URLEncoder.encode(ConfigConstants.getSignedPreviewTokenParam(), StandardCharsets.UTF_8) + "="
                + issue(claims, ConfigConstants.getSignedPreviewArchiveTtl());
    }

    /**
     * 取原文件时附带的令牌；没开或没配密钥时返回 null。
     *
     * @param url 本次请求的地址
     */
    public static String issueFetchToken(String url) {
        if (!ConfigConstants.isSignedFetchEnabled()) {
            return null;
        }
        if (!isFetchSigningActive()) {
            logger.warn("已开启 signed.fetch.enabled 但没有配置 signed.preview.secret，或三种用途的值配置有误，取原文件时不带令牌");
            return null;
        }
        Map<String, Object> claims = new LinkedHashMap<>();
        claims.put(ConfigConstants.getSignedPreviewClaimUse(), ConfigConstants.getSignedPreviewUseFetch());
        putNested(claims, ConfigConstants.getSignedFetchClaimUrl(), url);
        return issue(claims, ConfigConstants.getSignedFetchTtl());
    }

    /**
     * 取件令牌放进请求头时的值：配了前缀就是「前缀 + 空格 + 令牌」
     */
    public static String fetchHeaderValue(String fetchToken) {
        String prefix = ConfigConstants.getSignedFetchHeaderPrefix();
        return StringUtils.hasText(prefix) ? prefix + " " + fetchToken : fetchToken;
    }

    /**
     * 按点分路径把值放进载荷：a.b.c 放成 {"a":{"b":{"c":值}}}；路径为空时放在 url 字段
     */
    @SuppressWarnings("unchecked")
    private static void putNested(Map<String, Object> claims, String path, Object value) {
        String[] segments = Arrays.stream(path == null ? new String[0] : path.split("\\."))
                .map(String::trim).filter(StringUtils::hasText).toArray(String[]::new);
        if (segments.length == 0) {
            segments = new String[]{ConfigConstants.DEFAULT_SIGNED_FETCH_CLAIM_URL};
        }
        Map<String, Object> current = claims;
        for (int i = 0; i < segments.length - 1; i++) {
            Object next = current.get(segments[i]);
            if (!(next instanceof Map)) {
                next = new LinkedHashMap<String, Object>();
                current.put(segments[i], next);
            }
            current = (Map<String, Object>) next;
        }
        current.put(segments[segments.length - 1], value);
    }

    private static String issue(Map<String, Object> claims, long ttlSeconds) {
        long now = System.currentTimeMillis() / 1000;
        claims.put("iat", now);
        claims.put("exp", now + ttlSeconds);
        return JwtUtils.sign(claims, ConfigConstants.getSignedPreviewSecret(), ConfigConstants.getSignedPreviewAlgorithm());
    }

    private static void copyClaim(Map<?, ?> from, Map<String, Object> to, String name) {
        Object value = from.get(name);
        if (value != null) {
            to.put(name, value);
        }
    }
}
