package cn.keking;

import cn.keking.config.ConfigConstants;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 签名预览测试共用的小工具：令牌在这里按 JWT 规范独立签发和拆解，不经过被测代码，
 * 这样被测的签发或校验写错时，测试不会跟着一起错。
 */
public final class SignedPreviewTestSupport {

    public static final String SECRET = "unit-test-secret-0123456789abcdef";
    private static final ObjectMapper MAPPER = new ObjectMapper();

    private SignedPreviewTestSupport() {
    }

    public static long now() {
        return System.currentTimeMillis() / 1000;
    }

    /** 载荷里依次给键、值；用默认密钥、HS256 签。 */
    public static String token(Object... keyValues) {
        return sign("HS256", "HmacSHA256", SECRET, claims(keyValues));
    }

    public static Map<String, Object> claims(Object... keyValues) {
        Map<String, Object> claims = new LinkedHashMap<>();
        for (int i = 0; i < keyValues.length; i += 2) {
            claims.put((String) keyValues[i], keyValues[i + 1]);
        }
        return claims;
    }

    /** 头里写的算法与真正用来算签名的算法分开给，方便造出两者不一致的令牌。 */
    public static String sign(String headerAlg, String macAlgorithm, String secret, Map<String, Object> claims) {
        try {
            String header = encode(("{\"alg\":\"" + headerAlg + "\",\"typ\":\"JWT\"}").getBytes(StandardCharsets.UTF_8));
            String payload = encode(MAPPER.writeValueAsBytes(claims));
            String signingInput = header + "." + payload;
            if (macAlgorithm == null) {
                return signingInput + ".";
            }
            Mac mac = Mac.getInstance(macAlgorithm);
            mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), macAlgorithm));
            return signingInput + "." + encode(mac.doFinal(signingInput.getBytes(StandardCharsets.UTF_8)));
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    /** 用默认密钥按 HS256 验签并取出载荷；签名对不上就抛错。 */
    @SuppressWarnings("unchecked")
    public static Map<String, Object> verified(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length != 3) {
                throw new AssertionError("不是三段的 JWT：" + token);
            }
            Map<String, Object> header = MAPPER.readValue(Base64.getUrlDecoder().decode(parts[0]), Map.class);
            if (!"HS256".equals(header.get("alg"))) {
                throw new AssertionError("令牌头里的算法不是 HS256：" + header);
            }
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(new SecretKeySpec(SECRET.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
            String expected = encode(mac.doFinal((parts[0] + "." + parts[1]).getBytes(StandardCharsets.UTF_8)));
            if (!expected.equals(parts[2])) {
                throw new AssertionError("签名与默认密钥对不上");
            }
            return MAPPER.readValue(Base64.getUrlDecoder().decode(parts[1]), Map.class);
        } catch (AssertionError e) {
            throw e;
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    /** 取件请求头里可能带前缀（例如 Bearer），去掉前缀后验签取载荷。 */
    public static Map<String, Object> verifiedBearer(String headerValue) {
        if (headerValue == null || !headerValue.startsWith("Bearer ")) {
            throw new AssertionError("请求头的值不是 Bearer 加令牌：" + headerValue);
        }
        return verified(headerValue.substring("Bearer ".length()));
    }

    public static String base64(String text) {
        return Base64.getEncoder().encodeToString(text.getBytes(StandardCharsets.UTF_8));
    }

    public static String unbase64(String text) {
        return new String(Base64.getDecoder().decode(text), StandardCharsets.UTF_8);
    }

    private static String encode(byte[] bytes) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /** 把签名预览的全部配置项恢复成缺省值（缺省即关闭）。 */
    public static void resetConfig() {
        ConfigConstants.setSignedPreviewEnabledValue(Boolean.parseBoolean(ConfigConstants.DEFAULT_SIGNED_PREVIEW_ENABLED));
        ConfigConstants.setSignedPreviewSecretValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_SECRET);
        ConfigConstants.setSignedPreviewAlgorithmValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_ALGORITHM);
        ConfigConstants.setSignedPreviewTokenParamValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_TOKEN_PARAM);
        ConfigConstants.setSignedPreviewClaimUrlValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_URL);
        ConfigConstants.setSignedPreviewClaimUrlsValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_URLS);
        ConfigConstants.setSignedPreviewClaimFilenameValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_FILENAME);
        ConfigConstants.setSignedPreviewClaimWatermarkValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_WATERMARK);
        ConfigConstants.setSignedPreviewClaimForceValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_FORCE);
        ConfigConstants.setSignedPreviewAllowParamsValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_ALLOW_PARAMS);
        ConfigConstants.setSignedPreviewTtlValue(Long.parseLong(ConfigConstants.DEFAULT_SIGNED_PREVIEW_TTL));
        ConfigConstants.setSignedPreviewLeewayValue(Long.parseLong(ConfigConstants.DEFAULT_SIGNED_PREVIEW_LEEWAY));
        ConfigConstants.setSignedFetchEnabledValue(Boolean.parseBoolean(ConfigConstants.DEFAULT_SIGNED_FETCH_ENABLED));
        ConfigConstants.setSignedFetchHeaderValue(ConfigConstants.DEFAULT_SIGNED_FETCH_HEADER);
        ConfigConstants.setSignedPreviewClaimUseValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_USE);
        ConfigConstants.setSignedPreviewUsePreviewValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_USE_PREVIEW);
        ConfigConstants.setSignedPreviewUseArchiveValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_USE_ARCHIVE);
        ConfigConstants.setSignedPreviewUseFetchValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_USE_FETCH);
        ConfigConstants.setSignedPreviewUseRequiredValue(Boolean.parseBoolean(ConfigConstants.DEFAULT_SIGNED_PREVIEW_USE_REQUIRED));
        ConfigConstants.setSignedPreviewClaimMapValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_CLAIM_MAP);
        ConfigConstants.setSignedPreviewArchiveTtlValue(ConfigConstants.DEFAULT_SIGNED_PREVIEW_ARCHIVE_TTL);
        ConfigConstants.setSignedFetchTtlValue(ConfigConstants.DEFAULT_SIGNED_FETCH_TTL);
        ConfigConstants.setSignedFetchClaimUrlValue(ConfigConstants.DEFAULT_SIGNED_FETCH_CLAIM_URL);
        ConfigConstants.setSignedFetchHeaderPrefixValue(ConfigConstants.DEFAULT_SIGNED_FETCH_HEADER_PREFIX);
    }
}
