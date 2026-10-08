package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.io.TempDir;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.nio.file.Files;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class UploadPathSecurityTests {
    @TempDir Path temp;
    private String oldDir;
    private Boolean oldDisabled;
    private MockMvc mvc;

    @BeforeEach void setup() throws Exception {
        oldDir = ConfigConstants.getFileDir();
        oldDisabled = ConfigConstants.getFileUploadDisable();
        ConfigConstants.setFileDirValue(Files.createDirectory(temp.resolve("files")).toString());
        ConfigConstants.setFileUploadDisableValue(false);
        mvc = MockMvcBuilders.standaloneSetup(new FileController()).build();
    }

    @AfterEach void restore() {
        ConfigConstants.setFileDirValue(oldDir);
        ConfigConstants.setFileUploadDisableValue(oldDisabled);
    }

    private MockMultipartFile file() {
        return new MockMultipartFile("file", "canary.pdf", "application/pdf", "CANARY".getBytes());
    }

    @ParameterizedTest
    @ValueSource(strings = {"../../outside", "..\\..\\outside", "/tmp/outside", "C:\\outside",
            "\\\\server\\share", "a/../outside", ".. /outside", "bad\0path"})
    void refusesTraversalAtBothHttpEndpoints(String path) throws Exception {
        mvc.perform(multipart("/fileUpload").file(file()).param("path", path))
                .andExpect(jsonPath("$.code").value(1));
        mvc.perform(post("/createFolder").param("path", path).param("folderName", "new"))
                .andExpect(jsonPath("$.code").value(1));
        assertFalse(Files.exists(temp.resolve("outside")));
    }

    @Test void preservesNestedUploadsAndRefusesOverwrite() throws Exception {
        mvc.perform(multipart("/fileUpload").file(file()).param("path", "nested/child"))
                .andExpect(jsonPath("$.code").value(0));
        Path target = temp.resolve("files/demo/nested/child/canary.pdf");
        assertEquals("CANARY", Files.readString(target));
        mvc.perform(multipart("/fileUpload").file(file()).param("path", "nested/child"))
                .andExpect(jsonPath("$.code").value(1));
        mvc.perform(post("/createFolder").param("path", "nested\\child").param("folderName", "new"))
                .andExpect(jsonPath("$.code").value(0));
        assertTrue(Files.isDirectory(target.getParent().resolve("new")));
    }

    @Test void refusesParentSymlinksAndExistingFileSymlinks() throws Exception {
        Path root = Files.createDirectory(temp.resolve("files/demo"));
        Path outside = Files.createDirectory(temp.resolve("outside"));
        Files.createSymbolicLink(root.resolve("link"), outside);
        mvc.perform(multipart("/fileUpload").file(file()).param("path", "link/new"))
                .andExpect(jsonPath("$.code").value(1));
        mvc.perform(post("/createFolder").param("path", "link/new").param("folderName", "new"))
                .andExpect(jsonPath("$.code").value(1));
        assertFalse(Files.exists(outside.resolve("new")));
        Files.createSymbolicLink(root.resolve("canary.pdf"), outside.resolve("missing.pdf"));
        mvc.perform(multipart("/fileUpload").file(file()))
                .andExpect(jsonPath("$.code").value(1));
        assertFalse(Files.exists(outside.resolve("missing.pdf")));
    }

    @Test void uploadDisableStillBlocksBothEndpoints() throws Exception {
        ConfigConstants.setFileUploadDisableValue(true);
        mvc.perform(multipart("/fileUpload").file(file())).andExpect(jsonPath("$.code").value(1));
        mvc.perform(post("/createFolder").param("folderName", "new"))
                .andExpect(jsonPath("$.code").value(1));
        assertFalse(Files.exists(temp.resolve("files/demo")));
    }
}
