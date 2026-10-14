package cn.keking.utils;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

/**
 * 签名预览用到的 JWT 签发与校验（HMAC 一族：HS256、HS384、HS512）。
 * 只用 JDK 自带的 HMAC 和项目里已有的 Jackson，不引入新的依赖。
 */
public final class JwtUtils {

    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final TypeReference<LinkedHashMap<String, Object>> MAP_TYPE = new TypeReference<>() {
    };
    private static final Base64.Encoder ENCODER = Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder DECODER = Base64.getUrlDecoder();

    private JwtUtils() {
    }

    /**
     * 令牌没有通过校验
     */
    public static class JwtException extends Exception {

        private final boolean expired;

        public JwtException(String message) {
            this(message, false);
        }

        public JwtException(String message, boolean expired) {
            super(message);
            this.expired = expired;
        }

        /**
         * 是否因为过了有效期（其余情况都是令牌本身不对）
         */
        public boolean isExpired() {
            return expired;
        }
    }

    /**
     * 签发令牌
     *
     * @param claims    载荷
     * @param secret    密钥，按 UTF-8 字节使用
     * @param algorithm HS256、HS384 或 HS512
     * @return 三段式的 JWT
     */
    public static String sign(Map<String, Object> claims, String secret, String algorithm) {
        String macAlgorithm = macAlgorithm(algorithm);
        if (macAlgorithm == null) {
            throw new IllegalArgumentException("不支持的签名算法：" + algorithm);
        }
        try {
            Map<String, Object> header = new LinkedHashMap<>();
            header.put("alg", algorithm.toUpperCase(Locale.ROOT));
            header.put("typ", "JWT");
            String signingInput = ENCODER.encodeToString(MAPPER.writeValueAsBytes(header))
                    + "." + ENCODER.encodeToString(MAPPER.writeValueAsBytes(claims));
            return signingInput + "." + ENCODER.encodeToString(hmac(macAlgorithm, secret, signingInput));
        } catch (Exception e) {
            throw new IllegalStateException("签发令牌失败", e);
        }
    }

    /**
     * 校验令牌并取出载荷：令牌头里的算法必须就是配置的算法，签名必须对得上，
     * 必须带数字形式的 exp 且没有过期；带了 nbf 时还不能早于生效时间。
     *
     * @param token         三段式的 JWT
     * @param secret        密钥，按 UTF-8 字节使用
     * @param algorithm     HS256、HS384 或 HS512
     * @param leewaySeconds 比较时间时允许的时钟误差（秒）
     * @return 载荷
     */
    public static Map<String, Object> verify(String token, String secret, String algorithm, long leewaySeconds) throws JwtException {
        String macAlgorithm = macAlgorithm(algorithm);
        if (macAlgorithm == null) {
            throw new JwtException("不支持的签名算法：" + algorithm);
        }
        String[] parts = token == null ? new String[0] : token.split("\\.", -1);
        if (parts.length != 3) {
            throw new JwtException("令牌不是三段式的 JWT");
        }
        Map<String, Object> header;
        Map<String, Object> claims;
        byte[] signature;
        try {
            header = MAPPER.readValue(DECODER.decode(parts[0]), MAP_TYPE);
            claims = MAPPER.readValue(DECODER.decode(parts[1]), MAP_TYPE);
            signature = DECODER.decode(parts[2]);
        } catch (Exception e) {
            throw new JwtException("令牌无法解析");
        }
        if (header == null || claims == null || !algorithm.equalsIgnoreCase(String.valueOf(header.get("alg")))) {
            throw new JwtException("令牌的签名算法与配置的不一致");
        }
        byte[] expected;
        try {
            expected = hmac(macAlgorithm, secret, parts[0] + "." + parts[1]);
        } catch (Exception e) {
            throw new JwtException("无法计算签名");
        }
        if (!MessageDigest.isEqual(expected, signature)) {
            throw new JwtException("令牌的签名不正确");
        }
        long now = System.currentTimeMillis() / 1000;
        if (!(claims.get("exp") instanceof Number exp)) {
            throw new JwtException("令牌没有带有效期 exp");
        }
        if (now > exp.longValue() + leewaySeconds) {
            throw new JwtException("令牌已过期", true);
        }
        if (claims.get("nbf") instanceof Number nbf && now + leewaySeconds < nbf.longValue()) {
            throw new JwtException("令牌尚未生效");
        }
        return claims;
    }

    private static String macAlgorithm(String algorithm) {
        if (algorithm == null) {
            return null;
        }
        return switch (algorithm.toUpperCase(Locale.ROOT)) {
            case "HS256" -> "HmacSHA256";
            case "HS384" -> "HmacSHA384";
            case "HS512" -> "HmacSHA512";
            default -> null;
        };
    }

    private static byte[] hmac(String macAlgorithm, String secret, String signingInput) throws Exception {
        Mac mac = Mac.getInstance(macAlgorithm);
        mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8), macAlgorithm));
        return mac.doFinal(signingInput.getBytes(StandardCharsets.UTF_8));
    }
}
