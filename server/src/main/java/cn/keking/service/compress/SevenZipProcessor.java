package cn.keking.service.compress;

import cn.keking.service.FileHandlerService;
import org.apache.commons.compress.archivers.sevenz.SevenZArchiveEntry;
import org.apache.commons.compress.archivers.sevenz.SevenZFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class SevenZipProcessor extends ArchiveProcessor<SevenZArchiveEntry> {

    private SevenZFile zipFile;

    private Map<String, byte[]> contentMap;

    public SevenZipProcessor(String archiveFilePath, FileHandlerService fileHandlerService) {
        super(archiveFilePath, fileHandlerService);
    }

    /**
     * 因为 SevenZFile 不支持读取指定的 SevenZArchiveEntry，所以只能在这里遍历先读取所有内容
     */
    @Override
    protected Map<String, SevenZArchiveEntry> getEntries(String archiveFilePath) throws IOException {
        Map<String, SevenZArchiveEntry> map = new HashMap<>();
        zipFile = new SevenZFile(new File(archiveFilePath));
        Iterable<SevenZArchiveEntry> entries = zipFile.getEntries();
        for (SevenZArchiveEntry entry : entries) {
            map.put(entry.getName(), entry);
            byte[] content = new byte[(int) entry.getSize()];
            zipFile.read(content, 0, content.length);
            contentMap.put(entry.getName(), content);
        }
        return map;
    }

    @Override
    protected boolean isDirectory(SevenZArchiveEntry entry) {
        return entry.isDirectory();
    }

    @Override
    protected void extract(SevenZArchiveEntry entry, String outputFilePath) throws IOException {
        byte[] bytes = contentMap.get(entry.getName());
        if (bytes != null) {
            Files.write(Paths.get(outputFilePath), bytes);
        }
    }

    @Override
    protected void closeFile() throws IOException {
        if (zipFile != null) {
            zipFile.close();
        }
    }
}
