package cn.keking;

import cn.keking.utils.EncodingDetects;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.File;
import java.net.URISyntaxException;

/**
 * 编码检测测试类
 *
 * @author asiawu3
 * @create 2023-07-24 16:53
 **/
@SpringBootTest
public class EncodingTests {
    @Test
    void testCharDet() throws URISyntaxException {
        for (int i = 0; i < 28; i++) {
            File dir = new File(getClass().getClassLoader().getResource("testData\\" + i).toURI());
            String dirPath = dir.getPath();
            String textFileName = dir.list()[0];
            String textFilePath = dirPath + "/" + textFileName;
            System.out.printf("%-15s -->\t %-10s\n", textFileName, EncodingDetects.getJavaEncode(textFilePath));
        }
    }
}
