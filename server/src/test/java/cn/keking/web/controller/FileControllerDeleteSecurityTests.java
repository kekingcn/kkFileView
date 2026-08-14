package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.ReturnResponse;
import jakarta.servlet.http.HttpServletRequest;
import org.apache.commons.codec.binary.Base64;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.io.IOException;
import java.lang.reflect.Method;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class FileControllerDeleteSecurityTests {

    @TempDir
    Path tempDir;

    private String originalFileDir;
    private String originalPassword;
    private Boolean originalDeleteCaptcha;

    @BeforeEach
    void configureDemoDirectory() throws IOException {
        originalFileDir = ConfigConstants.getFileDir();
        originalPassword = ConfigConstants.getPassword();
        originalDeleteCaptcha = ConfigConstants.getDeleteCaptcha();
        Files.createDirectory(tempDir.resolve("demo"));
        ConfigConstants.setFileDirValue(tempDir.toString());
        ConfigConstants.setDeleteCaptchaValue(false);
    }

    @AfterEach
    void restoreConfiguration() {
        ConfigConstants.setFileDirValue(originalFileDir);
        ConfigConstants.setPasswordValue(originalPassword);
        ConfigConstants.setDeleteCaptchaValue(originalDeleteCaptcha);
    }

    @Test
    void shouldDisableDeletionWhenNoPasswordIsConfigured() throws IOException {
        ConfigConstants.setPasswordValue("false");
        Path victim = Files.writeString(tempDir.resolve("demo/victim.txt"), "keep");
        FileController controller = new FileController();

        ReturnResponse<Object> response = controller.deleteFile(
                new MockHttpServletRequest(), encodeFileName("victim.txt"), "false");

        assertTrue(response.isFailure());
        assertTrue(Files.exists(victim));
    }

    @Test
    void shouldRequireAnExactCaseSensitivePassword() throws IOException {
        ConfigConstants.setPasswordValue("Strong-Delete-Password");
        Path victim = Files.writeString(tempDir.resolve("demo/victim.txt"), "delete me");
        FileController controller = new FileController();

        ReturnResponse<Object> wrongCase = controller.deleteFile(
                new MockHttpServletRequest(), encodeFileName("victim.txt"), "strong-delete-password");
        assertTrue(wrongCase.isFailure());
        assertTrue(Files.exists(victim));

        ReturnResponse<Object> correct = controller.deleteFile(
                new MockHttpServletRequest(), encodeFileName("victim.txt"), "Strong-Delete-Password");
        assertTrue(correct.isSuccess());
        assertFalse(Files.exists(victim));
    }

    @Test
    void shouldExposeDeletionOnlyAsPost() throws NoSuchMethodException {
        Method method = FileController.class.getMethod(
                "deleteFile", HttpServletRequest.class, String.class, String.class);

        assertNotNull(method.getAnnotation(PostMapping.class));
        assertNull(method.getAnnotation(GetMapping.class));
    }

    @Test
    void shouldKeepDeletionDisabledAndCredentialsOutOfUrlsByDefault() throws IOException {
        String properties = readResource("application.properties");
        String template = readResource("web/main/index.ftl");

        assertTrue(properties.contains("delete.password = ${KK_DELETE_PASSWORD:false}"));
        assertTrue(template.contains("type: 'POST'"));
        assertTrue(template.contains("$.post('${baseUrl}deleteFile'"));
        assertFalse(template.contains("deleteFile?"));
        assertFalse(template.contains("默认密码:123456"));
    }

    private String encodeFileName(String fileName) {
        String value = "file://localhost/" + fileName;
        return Base64.encodeBase64String(value.getBytes(StandardCharsets.UTF_8));
    }

    private String readResource(String path) throws IOException {
        ClassPathResource resource = new ClassPathResource(path);
        return new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    }
}
