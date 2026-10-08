package cn.keking.utils;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.test.util.ReflectionTestUtils;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

class FtpCommandSecurityTests {
    @ParameterizedTest
    @ValueSource(strings = {
            "file.txt%0D%0ANOOP", "file.txt%0d%0aNOOP/clean.txt",
            "file.txt%0D%0ANOOP?fullfilename=clean.txt", "file.txt%0aNOOP", "file.txt%00"
    })
    void rejectsDecodedControlsBeforeDownloadOrPreviewConnects(String path) {
        String url = "ftp://127.0.0.1/" + path;
        IOException download = assertThrows(IOException.class,
                () -> FtpUtils.download(url, "1", "unused", "user", "pass", "UTF-8"));
        IOException preview = assertThrows(IOException.class,
                () -> FtpUtils.preview(url, "1", "unused", "user", "pass", "UTF-8"));
        assertTrue(download.getMessage().contains("control characters"));
        assertTrue(preview.getMessage().contains("control characters"));
    }

    @Test
    void rejectsControlsInCredentialsBeforeConnecting() {
        IOException error = assertThrows(IOException.class,
                () -> FtpUtils.preview("ftp://127.0.0.1/file.txt", "1", "unused",
                        "user\r\nNOOP", "pass", "UTF-8"));
        assertTrue(error.getMessage().contains("control characters"));
        error = assertThrows(IOException.class,
                () -> FtpUtils.download("ftp://127.0.0.1/file.txt", "1", "unused",
                        "user", "pass\nNOOP", "UTF-8"));
        assertTrue(error.getMessage().contains("control characters"));
    }

    @Test
    void preservesOrdinaryEncodedNamesAndDoesNotDoubleDecode() {
        Object info = ReflectionTestUtils.invokeMethod(FtpUtils.class, "parseFtpConnectionInfo",
                "ftp://files.example/a%20b/%E4%B8%AD%E6%96%87%250D.txt", "21", "user", "pass", "UTF-8");
        assertEquals("/a b/中文%0D.txt", ReflectionTestUtils.getField(info, "remoteFilePath"));
    }
}
