package cn.keking.service.compress;

import cn.keking.service.FileHandlerService;
import cn.keking.utils.Bytes;
import cn.keking.utils.KkFileUtils;
import org.apache.commons.compress.archivers.sevenz.SevenZArchiveEntry;
import org.apache.commons.compress.archivers.sevenz.SevenZFile;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class SevenZipProcessor extends ArchiveProcessor<SevenZArchiveEntry> {

    private SevenZFile zipFile;

    private final Map<String, byte[]> contentMap = new HashMap<>();

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

        SevenZArchiveEntry entry = zipFile.getNextEntry();
        while (entry != null) {
            map.put(entry.getName(), entry);
            byte[] content = Bytes.read(4096, buffer -> zipFile.read(buffer));
            contentMap.put(entry.getName(), content);
            entry = zipFile.getNextEntry();
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
            KkFileUtils.writeFile(bytes, outputFilePath);
        }
    }

    @Override
    protected void closeFile() throws IOException {
        if (zipFile != null) {
            zipFile.close();
        }
    }
}
