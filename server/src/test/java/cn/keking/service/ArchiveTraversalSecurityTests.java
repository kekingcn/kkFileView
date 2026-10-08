package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static org.junit.jupiter.api.Assertions.*;

class ArchiveTraversalSecurityTests {
    @TempDir Path temp;

    @Test void existingExtractorRejectsZipSlipBeforeWritingOutsideArchive() throws Exception {
        String previous = ConfigConstants.getFileDir();
        try {
            CompressFileReader reader = new CompressFileReader(null);
            for (String directory : List.of("first", "second")) {
                Path root = Files.createDirectory(temp.resolve(directory));
                ConfigConstants.setFileDirValue(root.toString());
                Path archive = root.resolve("malicious.zip");
                try (ZipOutputStream zip = new ZipOutputStream(Files.newOutputStream(archive))) {
                    zip.putNextEntry(new ZipEntry("../outside-marker.txt"));
                    zip.write("BENIGN-CANARY".getBytes());
                    zip.closeEntry();
                }
                Exception error = assertThrows(Exception.class, () -> reader
                        .unRar(archive.toString(), "", "malicious.zip", new FileAttribute()));
                assertTrue(error.getMessage().contains("Unsafe path detected"), error.toString());
                assertTrue(Files.isDirectory(root.resolve("malicious.zip_")));
                assertFalse(Files.exists(root.resolve("outside-marker.txt")));
            }
        } finally {
            ConfigConstants.setFileDirValue(previous);
        }
    }
}
