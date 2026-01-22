package cn.keking.utils;

import java.util.Set;
import java.util.regex.Pattern;

/**
 * @author mks155
 * @date 2026/1/22
 * @description 域名/IP匹配工具
 * 支持：*.example.com, example.com, localhost, 127.0.0.1, 192.168.*, 172.16.*, 10.*
 */
public final class DomainIpMatcherUtil {

    // IPv4地址正则
    private static final Pattern IPV4_PATTERN =
            Pattern.compile("^(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.(25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$");

    // 域名正则
    private static final Pattern DOMAIN_PATTERN =
            Pattern.compile("^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");

    private static final String WILDCARD_PREFIX = "*.";

    /**
     * 检查域名/IP是否在允许的配置列表中
     */
    public static boolean isAllowed(Set<String> allowedPatterns, String host) {
        if (allowedPatterns == null || allowedPatterns.isEmpty() || host == null) {
            return false;
        }

        String trimmedHost = host.trim();
        if (trimmedHost.isEmpty()) {
            return false;
        }

        for (String pattern : allowedPatterns) {
            if (pattern == null) continue;

            String trimmedPattern = pattern.trim();
            if (trimmedPattern.isEmpty()) continue;

            if (matchPattern(trimmedPattern, trimmedHost)) {
                return true;
            }
        }

        return false;
    }

    /**
     * 匹配单个模式
     */
    private static boolean matchPattern(String pattern, String host) {
        // 1. 精确匹配（需要验证格式，防止无效域名/IP被精确匹配）
        if (pattern.equals(host)) {
            // 只有格式合法才允许精确匹配
            return isValidDomain(pattern) || isIpFormat(pattern) || isSpecialDomain(pattern);
        }

        // 2. IP段匹配（10.*, 192.168.*, 192.168.1.*）
        if (isIpSegmentPattern(pattern)) {
            return matchIpSegment(pattern, host);
        }

        // 3. 通配符域名（*.example.com）
        if (pattern.startsWith(WILDCARD_PREFIX)) {
            return matchWildcardDomain(pattern, host);
        }

        // 4. 精确IP匹配（已在第一步处理）
        if (isIpFormat(pattern) && isIpFormat(host)) {
            return false;
        }

        // 5. 特殊域名（localhost, 127.0.0.1）
        if (isSpecialDomain(pattern)) {
            return isSpecialDomain(host) && pattern.equalsIgnoreCase(host);
        }

        return false;
    }

    /**
     * 匹配通配符域名：*.example.com
     * 规则：
     * - 必须以 .suffix 结尾（不区分大小写）
     * - 不能等于suffix
     * - 子域名部分必须有效（防止evil.com.example.com）
     * - 只能匹配一级子域名（a.example.com 可以，a.b.example.com 不行）
     * - 域名不区分大小写
     */
    private static boolean matchWildcardDomain(String pattern, String domain) {
        // 去掉 "*." 并转换为小写
        String suffix = pattern.substring(2).toLowerCase();
        String domainLower = domain.toLowerCase();

        // 验证后缀格式
        if (!isValidDomain(suffix)) {
            return false;
        }

        // 必须以 .suffix 结尾
        if (!domainLower.endsWith("." + suffix)) {
            return false;
        }

        // 不能等于suffix
        if (domainLower.equals(suffix)) {
            return false;
        }

        // 提取子域名部分
        String subdomain = domainLower.substring(0, domainLower.length() - suffix.length() - 1);

        // 防止多级子域名：a.b.example.com 不应匹配 *.example.com
        if (subdomain.contains(".")) {
            return false;
        }

        // 验证子域名（防止evil.com.example.com）
        return isValidSubdomain(subdomain);
    }

    /**
     * 匹配IP段：10.*, 192.168.*, 192.168.1.*
     * 支持2、3、4段格式
     */
    private static boolean matchIpSegment(String pattern, String host) {
        if (!isIpFormat(host)) {
            return false;
        }

        String[] patternParts = pattern.split("\\.");
        String[] hostParts = host.split("\\.");

        // 支持2、3、4段pattern匹配4段host
        if (hostParts.length != 4) {
            return false;
        }

        // 只比较pattern的段数，pattern的每一段对应host的对应段
        for (int i = 0; i < patternParts.length; i++) {
            if ("*".equals(patternParts[i])) {
                continue;
            }
            if (!patternParts[i].equals(hostParts[i])) {
                return false;
            }
        }
        return true;
    }

    /**
     * 判断是否是IP段模式（10.*, 192.168.*, 192.168.1.*）
     * 支持2、3、4段格式
     */
    private static boolean isIpSegmentPattern(String str) {
        if (str == null || !str.contains("*")) {
            return false;
        }

        String[] parts = str.split("\\.");
        // 支持2、3、4段：10.*, 192.168.*, 192.168.1.*
        if (parts.length < 2 || parts.length > 4) {
            return false;
        }

        for (String part : parts) {
            if ("*".equals(part)) {
                continue;
            }
            if (!isNumeric(part)) {
                return false;
            }
            int num = Integer.parseInt(part);
            if (num < 0 || num > 255) {
                return false;
            }
        }
        return true;
    }

    /**
     * 判断是否是标准IPv4格式
     */
    private static boolean isIpFormat(String str) {
        return str != null && IPV4_PATTERN.matcher(str).matches();
    }

    /**
     * 判断是否是特殊域名（localhost, 127.0.0.1）
     */
    private static boolean isSpecialDomain(String str) {
        if (str == null) {
            return false;
        }
        return "localhost".equalsIgnoreCase(str) || "127.0.0.1".equals(str);
    }

    /**
     * 验证域名格式
     */
    private static boolean isValidDomain(String domain) {
        if (domain == null || domain.isEmpty() || domain.length() > 253) {
            return false;
        }

        // 特殊域名直接通过
        if (isSpecialDomain(domain)) {
            return true;
        }

        // 格式检查
        if (domain.startsWith(".") || domain.endsWith(".") || domain.contains("..")) {
            return false;
        }

        String[] parts = domain.split("\\.");
        for (String part : parts) {
            if (part.isEmpty() || part.length() > 63) {
                return false;
            }
            if (part.startsWith("-") || part.endsWith("-")) {
                return false;
            }
            if (!DOMAIN_PATTERN.matcher(part).matches()) {
                return false;
            }
        }
        return true;
    }

    /**
     * 验证子域名（防止绕过）
     */
    private static boolean isValidSubdomain(String subdomain) {
        if (subdomain == null || subdomain.isEmpty()) {
            return false;
        }
        if (subdomain.contains("*") || subdomain.contains(" ") || subdomain.contains("@") || subdomain.contains(";")) {
            return false;
        }
        if (subdomain.replace(".", "").isEmpty()) {
            return false;
        }
        return isValidDomain(subdomain);
    }

    /**
     * 判断是否是数字
     */
    private static boolean isNumeric(String str) {
        if (str == null || str.isEmpty()) {
            return false;
        }
        for (char c : str.toCharArray()) {
            if (!Character.isDigit(c)) {
                return false;
            }
        }
        return true;
    }

}