package cn.keking.utils;

import org.junit.jupiter.api.Test;

public class WebUtilsTests {

    @Test
    void encodeUrlFileNameTest() {
        // 测试对URL中的文件名部分进行UTF-8编码
        String in = "https://file.keking.cn/demo/hello#0.txt";
        String out = "https://file.keking.cn/demo/hello%230.txt";
        assert WebUtils.encodeUrlFileName(in).equals(out);
    }

    @Test
    void encodeUrlFileNameTestWithParams() {
        // 测试对URL中的文件名部分进行UTF-8编码
        // URL带参数
        // 文件名"#hello&world"中的"&"应该被编码成为"%26"，而?后的参数列表中的"&"不会被编码
        String in = "https://file.keking.cn/demo/#hello&world.txt?param0=0&param1=1";
        String out = "https://file.keking.cn/demo/%23hello%26world.txt?param0=0&param1=1";
        assert WebUtils.encodeUrlFileName(in).equals(out);
    }

    @Test
    void encodeUrlFullFileNameTestWithParams() {
        // 测试对URL中使用fullfilename参数的文件名部分进行UTF-8编码
        String in = "https://file.keking.cn/demo/download?param0=0&fullfilename=hello#0.txt";
        String out = "https://file.keking.cn/demo/download?param0=0&fullfilename=hello%230.txt";
        assert WebUtils.encodeUrlFileName(in).equals(out);
    }
}
