package cn.keking.utils;

import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author mks155
 * @date 2026/1/22
 * @description 域名/IP匹配工具
 * 支持：*.example.com, example.com, localhost, 127.0.0.1, 192.168.*, 172.16.*, 10.*
 */
public final class DomainIpMatcherUtilTests {
    private static final Logger log = LoggerFactory.getLogger(DomainIpMatcherUtilTests.class);

    @Test
    public void runAllTests() {
        log.info("=== DomainIpMatcher增强测试开始 ===");

        List<String> failures = new ArrayList<>();
        int testCount = 0;

        // ========== 1. 域名通配符测试 ==========
        Set<String> patterns1 = Set.of("*.example.com", "*.test.com", "example.com", "www.example.com");
        test("api.example.com", true, patterns1, ++testCount, failures);
        test("localhost.example.com", true, patterns1, ++testCount, failures);
        test("a.b.example.com", false, patterns1, ++testCount, failures);
        test("evil.com", false, patterns1, ++testCount, failures);
        test("example.com.evil.com", false, patterns1, ++testCount, failures);
        test("example.test.com", true, patterns1, ++testCount, failures);
        test("example.com.test.com", false, patterns1, ++testCount, failures);
        test("example.com", true, patterns1, ++testCount, failures);
        test("www.example.com", true, patterns1, ++testCount, failures);

        // ========== 2. IP段匹配测试 ==========
        Set<String> patterns2 = Set.of("192.168.*", "10.*", "172.16.*", "192.168.0.1", "172.17.*");
        test("192.168.1.1", true, patterns2, ++testCount, failures);
        test("192.168.0.100", true, patterns2, ++testCount, failures);
        test("192.168.255.255", true, patterns2, ++testCount, failures);
        test("10.0.0.1", true, patterns2, ++testCount, failures);
        test("172.16.0.1", true, patterns2, ++testCount, failures);
        test("192.169.1.1", false, patterns2, ++testCount, failures);
        test("11.0.0.1", false, patterns2, ++testCount, failures);
        test("192.168.0.1", true, patterns2, ++testCount, failures);

        // ========== 3. 精确IP和特殊域名 ==========
        Set<String> patterns3 = Set.of("127.0.0.1", "localhost");
        test("127.0.0.1", true, patterns3, ++testCount, failures);
        test("127.0.0.2", false, patterns3, ++testCount, failures);
        test("128.0.0.1", false, patterns3, ++testCount, failures);
        test("localhost", true, patterns3, ++testCount, failures);
        test("LOCALHOST", true, patterns3, ++testCount, failures);
        test("local", false, patterns3, ++testCount, failures);

        // ========== 4. 边界和空值测试 ==========
        Set<String> patterns4 = Set.of("*.example.com");
        test("", false, patterns4, ++testCount, failures);
        test("   ", false, patterns4, ++testCount, failures);
        test(null, false, patterns4, ++testCount, failures);
        test("example.com", false, Set.of(), ++testCount, failures);
        test("example.com", false, null, ++testCount, failures);

        // ========== 5. 恶意输入测试 ==========
        Set<String> patterns5 = Set.of("*.example.com", "192.168.*");
        test("example.com; DROP TABLE", false, patterns5, ++testCount, failures);
        test("example.com/../evil.com", false, patterns5, ++testCount, failures);
        test("example.com<script>", false, patterns5, ++testCount, failures);
        test("example.com@evil.com", false, patterns5, ++testCount, failures);
        test("a".repeat(100) + "." + "b".repeat(100), false, patterns5, ++testCount, failures);
        test("a".repeat(64) + ".example.com", false, patterns5, ++testCount, failures);

        // ========== 6. IP段变体测试 ==========
        test("10.0.0.1", true, Set.of("10.0.0.*"), ++testCount, failures);
        test("10.0.1.1", false, Set.of("10.0.0.*"), ++testCount, failures);
        test("10.0.0.255", true, Set.of("10.0.0.*"), ++testCount, failures);
        test("10.0.0.0", true, Set.of("10.0.0.*"), ++testCount, failures);
        test("10.0.0.1", true, Set.of("10.0.*"), ++testCount, failures);
        test("10.0.1.1", true, Set.of("10.0.*"), ++testCount, failures);
        test("10.1.0.1", false, Set.of("10.0.*"), ++testCount, failures);

        // ========== 7. 域名通配符变体 ==========
        test("example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("a.example.com", true, Set.of("*.example.com"), ++testCount, failures);
        test("a.b.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("example.com.evil.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("evil.com.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("123.example.com", true, Set.of("*.example.com"), ++testCount, failures);
        test("a-b.example.com", true, Set.of("*.example.com"), ++testCount, failures);

        // ========== 8. 边界值测试 ==========
        test("192.168.0.0", true, Set.of("192.168.*"), ++testCount, failures);
        test("192.168.255.255", true, Set.of("192.168.*"), ++testCount, failures);
        test("10.0.0.0", true, Set.of("10.*"), ++testCount, failures);
        test("10.255.255.255", true, Set.of("10.*"), ++testCount, failures);
        test("a.example.com", true, Set.of("*.example.com"), ++testCount, failures);
        test("a" + "b".repeat(63) + ".example.com", false, Set.of("*.example.com"), ++testCount, failures);

        // ========== 9. 格式边界测试 ==========
        test("a_b.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("a.example.com.", false, Set.of("*.example.com"), ++testCount, failures);
        test("a b.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("192.168.1", false, Set.of("192.168.*"), ++testCount, failures);
        test("192.168.1.2.3", false, Set.of("192.168.*"), ++testCount, failures);
        test("192.168.1.1.1", false, Set.of("192.168.*"), ++testCount, failures);
        test("-example.com", false, Set.of("-example.com"), ++testCount, failures);
        test("example-.com", false, Set.of("example-.com"), ++testCount, failures);
        test("example..com", false, Set.of("example..com"), ++testCount, failures);
        test(".example.com", false, Set.of(".example.com"), ++testCount, failures);
        test("example.com.", false, Set.of("example.com."), ++testCount, failures);
        test("example@com", false, Set.of("example@com"), ++testCount, failures);
        test("example com", false, Set.of("example com"), ++testCount, failures);

        // ========== 10. 安全绕过测试 ==========
        test("127.0.0.1.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("example.com.example.com", false, Set.of("*.example.com"), ++testCount, failures);
        test("192.168.1.1.1", false, Set.of("192.168.*"), ++testCount, failures);
        test("10.0.0.1.1", false, Set.of("10.*"), ++testCount, failures);
        test("evil.com; DROP TABLE", false, Set.of("*.example.com"), ++testCount, failures);
        test("example.com/../evil.com", false, Set.of("*.example.com"), ++testCount, failures);

        // ========== 11. 混合模式测试 ==========
        Set<String> mixed = Set.of("*.example.com", "192.168.*", "localhost", "10.0.0.*");
        test("api.example.com", true, mixed, ++testCount, failures);
        test("192.168.1.1", true, mixed, ++testCount, failures);
        test("localhost", true, mixed, ++testCount, failures);
        test("10.0.0.1", true, mixed, ++testCount, failures);
        test("10.0.1.1", false, mixed, ++testCount, failures);
        test("evil.com", false, mixed, ++testCount, failures);

        // ========== 12. 大小写测试 ==========
        test("API.EXAMPLE.COM", true, Set.of("*.example.com"), ++testCount, failures);
        test("api.example.com", true, Set.of("*.example.com"), ++testCount, failures);
        test("LOCALHOST", true, Set.of("localhost"), ++testCount, failures);
        test("192.168.1.1", true, Set.of("192.168.*"), ++testCount, failures);
        test("192.168.1.1", true, Set.of("192.168.1.*"), ++testCount, failures);

        // ========== 13. 长域名测试 ==========
        test("a" + "b".repeat(50) + ".example.com", true, Set.of("*.example.com"), ++testCount, failures);
        test("192.168.1.1", true, Set.of("192.168.*"), ++testCount, failures);
        test("192.168.1.1", true, Set.of("192.168.1.*"), ++testCount, failures);

        // ========== 14. 性能测试==========
        Set<String> largeSet = new HashSet<>();
        for (int i = 0; i < 100; i++) {
            largeSet.add("*.sub" + i + ".example.com");
            largeSet.add("192.168." + i + ".*");
        }
        largeSet.add("example.com");
        largeSet.add("10.0.0.1");
        long start = System.currentTimeMillis();
        for (int i = 0; i < 1000; i++) {
            DomainIpMatcherUtil.isAllowed(largeSet, "api.sub50.example.com");
            DomainIpMatcherUtil.isAllowed(largeSet, "192.168.50.1");
            DomainIpMatcherUtil.isAllowed(largeSet, "10.0.0.1");
            DomainIpMatcherUtil.isAllowed(largeSet, "evil.com");
        }
        long duration = System.currentTimeMillis() - start;
        if (duration >= 1000) {
            String failure = "  ❌ [88] 性能测试 1000次 耗时 " + duration + "ms (期望 < 1000ms)";
            failures.add(failure);
            log.error(failure);
        } else {
            log.info("  ✅ [88] 性能测试 1000次 耗时: {}ms (期望 < 1000ms)", duration);
        }

        // ==========统一报告==========
        log.info("=== 测试总结 ===");
        log.info("总测试数: {}", testCount);
        log.info("通过数: {}", testCount - failures.size());
        log.info("失败数: {}", failures.size());

        if (failures.isEmpty()) {
            log.info("🎉 所有测试通过！");
        } else {
            log.error("❌ 测试失败详情:");
            for (String failure : failures) {
                log.error("  - {}", failure);
            }
            throw new AssertionError("共 " + failures.size() + " 个测试失败，请查看上方详细信息");
        }
    }

    /**
     * 测试辅助方法 - 实时显示结果，记录失败
     */
    private static void test(String input, boolean expected, Set<String> patterns, int index, List<String> failures) {
        boolean actual = DomainIpMatcherUtil.isAllowed(patterns, input);
        String inputStr = input == null ? "null" : (input.isEmpty() ? "\"\"" : input);
        if (inputStr.length() > 50) {
            inputStr = inputStr.substring(0, 47) + "...";
        }
        String status = actual == expected ? "✅" : "❌";
        log.info("  {} [{}] {} -> {} (期望: {})", status, index, inputStr, actual, expected);

        if (actual != expected) {
            String failure = "[" + index + "] " + inputStr + " -> " + actual + " (期望: " + expected + ")";
            failures.add(failure);
        }
    }

}