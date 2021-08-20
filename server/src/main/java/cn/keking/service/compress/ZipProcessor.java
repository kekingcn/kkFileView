package cn.keking.service.compress;

import cn.keking.service.FileHandlerService;
import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

// ZIP 格式的压缩包操作接口实现
public class ZipProcessor extends ArchiveProcessor<ZipEntry> {

    private ZipFile zipFile;

    public ZipProcessor(String archiveFilePath, FileHandlerService fileHandlerService) {
        super(archiveFilePath, fileHandlerService);
    }

    @Override
    protected Map<String, ZipEntry> getEntries(String archiveFilePath) throws IOException {
        Map<String, ZipEntry> result = new HashMap<>();
        zipFile = new ZipFile(archiveFilePath);
        Enumeration<? extends ZipEntry> entries = zipFile.entries();
        while (entries.hasMoreElements()) {
            ZipEntry zipEntry = entries.nextElement();
            result.put(zipEntry.getName(), zipEntry);
        }
        return result;
    }

    @Override
    protected boolean isDirectory(ZipEntry entry) {
        return entry.isDirectory();
    }

    @Override
    protected void extract(ZipEntry entry, String outputFilePath) throws IOException {
        Files.createDirectories(Paths.get(outputFilePath).getParent());
        InputStream is = zipFile.getInputStream(entry);
        try (OutputStream os = Files.newOutputStream(Paths.get(outputFilePath))) {
            IOUtils.copy(is, os);
        }
    }

    @Override
    protected void closeFile() throws IOException {
        if (zipFile != null) {
            zipFile.close();
        }
    }
}
