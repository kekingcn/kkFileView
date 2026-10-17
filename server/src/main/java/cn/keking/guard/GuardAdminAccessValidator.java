package cn.keking.guard;

import com.guardcore.protocols.GuardRequest;
import com.guardcore.protocols.GuardResponse;
import com.guardcore.spring.CustomRouteValidator;
import kotlin.coroutines.Continuation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Limits who may reach the state-changing endpoints (upload, folder creation, delete, addTask).
 * Both checks are optional and off by default: an IP allowlist ({@code guard.kk.admin-allowed-ips})
 * and an API key ({@code guard.kk.admin-key}, sent in the {@code X-KK-Admin-Key} header).
 * When both are set, both must pass. The client IP is the one Guard Core resolved, so it honours
 * {@code guard.trusted-proxies} and ignores a spoofed X-Forwarded-For from any other peer.
 */
@Component(GuardAdminAccessValidator.BEAN_NAME)
@ConditionalOnProperty(name = "guard.enabled", havingValue = "true")
public class GuardAdminAccessValidator implements CustomRouteValidator {

    public static final String BEAN_NAME = "kkGuardAdminAccessValidator";
    static final String KEY_HEADER = "x-kk-admin-key";
    private static final Pattern IPV4_LITERAL = Pattern.compile("(\\d{1,3}\\.){3}\\d{1,3}");
    private static final Pattern IPV6_LITERAL = Pattern.compile("[0-9a-fA-F:.]*:[0-9a-fA-F:.]*");

    private final List<Network> allowedNetworks = new ArrayList<>();
    private final byte[] adminKey;

    public GuardAdminAccessValidator(@Value("${guard.kk.admin-allowed-ips:}") List<String> allowedIps,
                                     @Value("${guard.kk.admin-key:}") String adminKey) {
        for (String entry : allowedIps) {
            if (!entry.isBlank()) {
                allowedNetworks.add(Network.parse(entry.trim()));
            }
        }
        this.adminKey = adminKey.getBytes(StandardCharsets.UTF_8);
    }

    @Override
    public Object validate(GuardRequest request, Continuation<? super Object> continuation) {
        if (isIpAllowed(request) && isKeyAccepted(request)) {
            return null;
        }
        return forbidden();
    }

    private boolean isIpAllowed(GuardRequest request) {
        if (allowedNetworks.isEmpty()) {
            return true;
        }
        Object clientIp = request.getState().getAttr("client_ip");
        return clientIp instanceof String ip && allowedNetworks.stream().anyMatch(network -> network.contains(ip));
    }

    private boolean isKeyAccepted(GuardRequest request) {
        if (adminKey.length == 0) {
            return true;
        }
        String supplied = request.getHeaders().get(KEY_HEADER);
        return supplied != null && MessageDigest.isEqual(adminKey, supplied.getBytes(StandardCharsets.UTF_8));
    }

    private static GuardResponse forbidden() {
        byte[] body = "Forbidden".getBytes(StandardCharsets.UTF_8);
        Map<String, String> headers = new LinkedHashMap<>();
        headers.put("Content-Type", "text/plain; charset=utf-8");
        headers.put("Content-Length", String.valueOf(body.length));
        return new GuardResponse() {
            @Override public int getStatusCode() { return 403; }
            @Override public Map<String, String> getHeaders() { return headers; }
            @Override public byte[] getBody() { return body; }
        };
    }

    /** An IP or CIDR literal. Typos fail startup instead of silently widening or narrowing access. */
    record Network(byte[] address, int prefixLength) {

        static Network parse(String entry) {
            String[] parts = entry.split("/", -1);
            byte[] address = parts.length <= 2 ? literal(parts[0]) : null;
            if (address == null) {
                throw invalid(entry);
            }
            int prefix = address.length * 8;
            if (parts.length == 2) {
                try {
                    prefix = Integer.parseInt(parts[1]);
                } catch (NumberFormatException e) {
                    throw invalid(entry);
                }
                if (prefix < 0 || prefix > address.length * 8) {
                    throw invalid(entry);
                }
            }
            return new Network(address, prefix);
        }

        boolean contains(String ip) {
            byte[] candidate = literal(ip);
            if (candidate == null || candidate.length != address.length) {
                return false;
            }
            int fullBytes = prefixLength / 8;
            for (int i = 0; i < fullBytes; i++) {
                if (candidate[i] != address[i]) {
                    return false;
                }
            }
            int remainingBits = prefixLength % 8;
            if (remainingBits == 0) {
                return true;
            }
            int mask = 0xFF << (8 - remainingBits);
            return (candidate[fullBytes] & mask) == (address[fullBytes] & mask);
        }

        /** Only literals reach InetAddress, so this never performs a DNS lookup. IPv4-mapped IPv6 becomes IPv4. */
        private static byte[] literal(String value) {
            if (!IPV4_LITERAL.matcher(value).matches() && !IPV6_LITERAL.matcher(value).matches()) {
                return null;
            }
            try {
                return InetAddress.getByName(value).getAddress();
            } catch (UnknownHostException e) {
                return null;
            }
        }

        private static IllegalArgumentException invalid(String entry) {
            return new IllegalArgumentException("guard.kk.admin-allowed-ips: invalid entry '" + entry + "'");
        }
    }
}
