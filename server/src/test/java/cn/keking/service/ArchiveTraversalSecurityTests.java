package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static org.junit.jupiter.api.Assertions.*;

class ArchiveTraversalSecurityTests {
    @TempDir Path temp;

    @Test void existingExtractorRejectsZipSlipBeforeWritingOutsideArchive() throws Exception {
        String previous = ConfigConstants.getFileDir();
        ConfigConstants.setFileDirValue(temp.toString());
        try {
            Path archive = temp.resolve("malicious.zip");
            try (ZipOutputStream zip = new ZipOutputStream(Files.newOutputStream(archive))) {
                zip.putNextEntry(new ZipEntry("../outside-marker.txt"));
                zip.write("BENIGN-CANARY".getBytes());
                zip.closeEntry();
            }
            Exception error = assertThrows(Exception.class, () -> new CompressFileReader(null)
                    .unRar(archive.toString(), "", "malicious.zip", new FileAttribute()));
            assertTrue(error.getMessage().contains("Unsafe path detected"), error.toString());
            assertFalse(Files.exists(temp.resolve("outside-marker.txt")));
        } finally {
            ConfigConstants.setFileDirValue(previous);
        }
    }
}
