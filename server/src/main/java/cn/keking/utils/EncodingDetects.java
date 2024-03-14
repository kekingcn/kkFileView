package cn.keking.utils;

import com.ibm.icu.text.CharsetDetector;
import com.ibm.icu.text.CharsetMatch;
import org.mozilla.universalchardet.UniversalDetector;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.file.Files;

/**
 * @author asiawu
 * @date 2023/07/20 17:26
 * @description: 自动获取文件的编码
 */
public class EncodingDetects {
    private static final int DEFAULT_LENGTH = 4096;
    private static final int LIMIT = 50;
    private static final Logger logger = LoggerFactory.getLogger(EncodingDetects.class);

    public static String getJavaEncode(String filePath) {
        return getJavaEncode(new File(filePath));
    }

    public static String getJavaEncode(File file) {
        int len = Math.min(DEFAULT_LENGTH, (int) file.length());
        byte[] content = new byte[len];
        try (InputStream fis = Files.newInputStream(file.toPath())) {
            fis.read(content, 0, len);
        } catch (IOException e) {
            logger.error("文件读取失败:{}", file.getPath());
        }
        return getJavaEncode(content);
    }

    public static String getJavaEncode(byte[] content) {
        if (content != null && content.length <= LIMIT) {
            return SimpleEncodingDetects.getJavaEncode(content);
        }
        UniversalDetector detector = new UniversalDetector(null);
        detector.handleData(content, 0, content.length);
        detector.dataEnd();
        String charsetName = detector.getDetectedCharset();
        if (charsetName == null) {
            CharsetDetector cd = new CharsetDetector();
            cd.setText(content);
            CharsetMatch cm = cd.detect();
            if (cm != null) {
                charsetName = cm.getName();
            } else {
                charsetName = Charset.defaultCharset().name();
            }
        }
        return charsetName;
    }
}
