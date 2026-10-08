package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.FileHandlerService;
import cn.keking.service.ZtreeNodeVo;
import cn.keking.service.impl.CompressFilePreviewImpl;
import cn.keking.utils.RarUtils;
import freemarker.template.Configuration;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.ui.ExtendedModelMap;

import java.io.StringWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class ArchiveDirectorySecurityTests {
    @TempDir Path temp;
    private String previousDir;
    private Boolean previousCache;
    @BeforeEach void setup() throws Exception {
        previousDir = ConfigConstants.getFileDir();
        previousCache = ConfigConstants.isCacheEnabled();
        ConfigConstants.setFileDirValue(temp.toString());
        ConfigConstants.setCacheEnabledValueValue(true);
        Files.createDirectories(temp.resolve("archive.zip_/nested"));
        Files.writeString(temp.resolve("archive.zip_/nested/visible.txt"), "visible");
        Files.writeString(temp.resolve("private-document.pdf"), "secret");
    }
    @AfterEach void restore() {
        ConfigConstants.setFileDirValue(previousDir);
        ConfigConstants.setCacheEnabledValueValue(previousCache);
    }

    @Test void publicDirectoryEnumerationRouteIsAbsent() throws Exception {
        MockMvcBuilders.standaloneSetup(new FileController()).build()
                .perform(get("/directory").param("urls", "aHR0cDovLy8="))
                .andExpect(status().isNotFound());
    }
    @Test void treeIsConfinedAndDoesNotFollowLinksOrExposeAbsoluteParents() throws Exception {
        Files.createSymbolicLink(temp.resolve("archive.zip_/secret-link"), temp.resolve("private-document.pdf"));
        Files.createSymbolicLink(temp.resolve("archive.zip_/loop"), temp.resolve("archive.zip_"));
        List<ZtreeNodeVo> tree = RarUtils.getTree("archive.zip_");
        assertEquals("", tree.get(0).pid);
        assertEquals(1, tree.get(0).children.size());
        assertEquals("archive.zip_/nested/visible.txt", tree.get(0).children.get(0).children.get(0).id);
        assertThrows(SecurityException.class, () -> RarUtils.getTree(""));
        assertThrows(SecurityException.class, () -> RarUtils.getTree("/"));
        assertThrows(SecurityException.class, () -> RarUtils.getTree("../"));
    }
    @Test void cachedArchivePreviewRendersItsTreeWithoutAnEnumerationRequest() throws Exception {
        Files.writeString(temp.resolve("archive.zip_/quote'\"<script>.txt"), "safe");
        FileHandlerService handler = new FileHandlerService(null) {
            @Override public String getConvertedFile(String name) { return "archive.zip_"; }
        };
        FileAttribute file = new FileAttribute();
        file.setName("archive.zip");
        ExtendedModelMap model = new ExtendedModelMap();
        assertEquals("compress", new CompressFilePreviewImpl(handler, null, null)
                .filePreviewHandle("https://files.example/archive.zip", model, file));
        String json = (String) model.get("archiveTreeJson");
        assertTrue(json.contains("nested/visible.txt"));
        assertFalse(json.contains("private-document.pdf"));
        assertFalse(json.contains(temp.toString()));
        model.put("baseUrl", "https://preview.example/");
        for (String name : new String[]{"watermarkXSpace", "watermarkYSpace", "watermarkAlpha",
                "watermarkWidth", "watermarkHeight", "watermarkAngle"}) { model.put(name, "0"); }
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_32);
        cfg.setClassForTemplateLoading(getClass(), "/web");
        cfg.setClassicCompatible(true);
        StringWriter output = new StringWriter();
        cfg.getTemplate("compress.ftl").process(model, output);
        assertTrue(output.toString().contains("initTree(JSON.parse('"));
        assertFalse(output.toString().contains("directory?urls="));
        assertTrue(output.toString().contains("quote\\'"));
    }
}
