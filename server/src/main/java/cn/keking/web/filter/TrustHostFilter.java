package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.WebUtils;

import java.io.IOException;
import java.util.Map;
import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.nio.charset.StandardCharsets;
import java.util.Set;
import java.util.regex.Pattern;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.commons.collections4.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;

/**
 * @author chenjh
 * @since 2020/2/18 19:13
 */
public class TrustHostFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(TrustHostFilter.class);
    private final Map<String, Pattern> wildcardPatternCache = new ConcurrentHashMap<>();
    private String notTrustHostHtmlView;

    @Override
    public void init(FilterConfig filterConfig) {
        ClassPathResource classPathResource = new ClassPathResource("web/notTrustHost.html");
        try {
            classPathResource.getInputStream();
            byte[] bytes = FileCopyUtils.copyToByteArray(classPathResource.getInputStream());
            this.notTrustHostHtmlView = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            logger.error("Failed to load notTrustHost.html file", e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String url = request.getParameter("file");
        if (url == null || url.trim().isEmpty()) {
            url = WebUtils.getSourceUrl(request);
        }
        String host = WebUtils.getHost(url);
        if (isNotTrustHost(host) || !WebUtils.isValidUrl(url)) {
            String currentHost = host == null ? "UNKNOWN" : host;
            if (response instanceof HttpServletResponse httpServletResponse) {
                httpServletResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
            }
            response.setCharacterEncoding(StandardCharsets.UTF_8.name());
            response.setContentType("text/html;charset=UTF-8");
            String html = this.notTrustHostHtmlView == null
                    ? "<html><head><meta charset=\"utf-8\"></head><body>当前预览文件来自不受信任的站点：" + currentHost + "</body></html>"
                    : this.notTrustHostHtmlView.replace("${current_host}", currentHost);
            response.getWriter().write(html);
            response.getWriter().close();
        } else {
            chain.doFilter(request, response);
        }
    }

    public boolean isNotTrustHost(String host) {
        if (host == null || host.trim().isEmpty()) {
            logger.warn("主机名为空或无效，拒绝访问");
            return true;
        }

        // 如果配置了黑名单，优先检查黑名单
        if (CollectionUtils.isNotEmpty(ConfigConstants.getNotTrustHostSet())
                && matchAnyPattern(host, ConfigConstants.getNotTrustHostSet())) {
            return true;
        }
        // 如果配置了白名单，检查是否在白名单中
        if (CollectionUtils.isNotEmpty(ConfigConstants.getTrustHostSet())) {
            // 支持通配符 * 表示允许所有主机
            if (ConfigConstants.getTrustHostSet().contains("*")) {
                logger.debug("允许所有主机访问（通配符模式）: {}", host);
                return false;
            }
            return !matchAnyPattern(host, ConfigConstants.getTrustHostSet());
        }

        // 安全加固：默认拒绝所有未配置的主机（防止SSRF攻击）
        // 如果需要允许所有主机，请在配置文件中明确设置 trust.host = *
        logger.warn("未配置信任主机列表，拒绝访问主机: {}，请在配置文件中设置 trust.host 或 KK_TRUST_HOST 环境变量", host);
        return true;
    }

    private boolean matchAnyPattern(String host, Set<String> hostPatterns) {
        String normalizedHost = host.toLowerCase(Locale.ROOT);
        for (String hostPattern : hostPatterns) {
            if (matchHostPattern(normalizedHost, hostPattern)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 支持三种匹配方式：
     * 1. 精确匹配：example.com
     * 2. 通配符匹配：*.example.com、192.168.*
     * 3. IPv4 CIDR：192.168.0.0/16
     */
    private boolean matchHostPattern(String host, String hostPattern) {
        if (hostPattern == null || hostPattern.trim().isEmpty()) {
            return false;
        }
        String pattern = hostPattern.trim().toLowerCase(Locale.ROOT);

        if ("*".equals(pattern)) {
            return true;
        }

        if (pattern.contains("/")) {
            return matchIpv4Cidr(host, pattern);
        }

        if (pattern.contains("*")) {
            if (isIpv4WildcardPattern(pattern)) {
                return matchIpv4Wildcard(host, pattern);
            }
            Pattern compiledPattern = wildcardPatternCache.computeIfAbsent(pattern, key -> Pattern.compile(wildcardToRegex(key)));
            return compiledPattern.matcher(host).matches();
        }

        return host.equals(pattern);
    }

    private boolean isIpv4WildcardPattern(String pattern) {
        return pattern.matches("^[0-9.*]+$") && pattern.contains(".");
    }

    private boolean matchIpv4Wildcard(String host, String pattern) {
        if (parseLiteralIpv4(host) == null) {
            return false;
        }
        String[] hostParts = host.split("\\.");
        String[] patternParts = pattern.split("\\.");
        if (hostParts.length != 4 || patternParts.length < 1 || patternParts.length > 4) {
            return false;
        }
        for (int i = 0; i < patternParts.length; i++) {
            String p = patternParts[i];
            if ("*".equals(p)) {
                continue;
            }
            if (!p.equals(hostParts[i])) {
                return false;
            }
        }
        return true;
    }

    private String wildcardToRegex(String wildcard) {
        StringBuilder regexBuilder = new StringBuilder("^");
        String[] parts = wildcard.split("\\*", -1);
        for (int i = 0; i < parts.length; i++) {
            regexBuilder.append(Pattern.quote(parts[i]));
            if (i < parts.length - 1) {
                regexBuilder.append(".*");
            }
        }
        regexBuilder.append("$");
        return regexBuilder.toString();
    }

    private boolean matchIpv4Cidr(String host, String cidr) {
        try {
            String[] parts = cidr.split("/");
            if (parts.length != 2) {
                return false;
            }
            Long hostInt = parseLiteralIpv4(host);
            Long networkInt = parseLiteralIpv4(parts[0]);
            int prefixLength = Integer.parseInt(parts[1]);

            if (hostInt == null || networkInt == null || prefixLength < 0 || prefixLength > 32) {
                return false;
            }

            long mask = prefixLength == 0 ? 0L : (0xFFFFFFFFL << (32 - prefixLength)) & 0xFFFFFFFFL;
            return (hostInt & mask) == (networkInt & mask);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    /**
     * 仅解析字面量 IPv4 地址（不做 DNS 解析），防止 DNS rebinding/TOCTOU 风险。
     */
    private Long parseLiteralIpv4(String input) {
        if (input == null || input.trim().isEmpty()) {
            return null;
        }
        String[] parts = input.trim().split("\\.");
        if (parts.length != 4) {
            return null;
        }
        long result = 0L;
        for (String part : parts) {
            if (part.isEmpty() || part.length() > 3) {
                return null;
            }
            int value;
            try {
                value = Integer.parseInt(part);
            } catch (NumberFormatException e) {
                return null;
            }
            if (value < 0 || value > 255) {
                return null;
            }
            result = (result << 8) | value;
        }
        return result;
    }

    @Override
    public void destroy() {

    }

}
