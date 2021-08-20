package cn.keking.service.compress;

import cn.keking.service.FileHandlerService;
import cn.keking.utils.KkFileUtils;

import java.io.IOException;
import java.io.InputStream;
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
        zipFile.stream().forEach(entry -> result.put(entry.getName(), entry));
        return result;
    }

    @Override
    protected boolean isDirectory(ZipEntry entry) {
        return entry.isDirectory();
    }

    @Override
    protected void extract(ZipEntry entry, String outputFilePath) throws IOException {
        InputStream is = zipFile.getInputStream(entry);
        KkFileUtils.writeFile(is, outputFilePath);
    }

    @Override
    protected void closeFile() throws IOException {
        if (zipFile != null) {
            zipFile.close();
        }
    }
}
