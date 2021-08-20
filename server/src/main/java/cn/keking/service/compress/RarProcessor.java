package cn.keking.service.compress;

import cn.keking.service.FileHandlerService;
import com.github.junrar.Archive;
import com.github.junrar.exception.RarException;
import com.github.junrar.rarfile.FileHeader;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// RAR 格式的压缩包操作接口实现
public class RarProcessor extends ArchiveProcessor<FileHeader> {

    private Archive archive;

    public RarProcessor(String archiveFilePath, FileHandlerService fileHandlerService) {
        super(archiveFilePath, fileHandlerService);
    }

    @Override
    protected Map<String, FileHeader> getEntries(String archiveFilePath) throws IOException {
        try {
            this.archive = new Archive(new FileInputStream(archiveFilePath));
        } catch (IOException e) {
            throw e;
        } catch (Exception e) {
            throw new IOException(e);
        }
        List<FileHeader> headers = archive.getFileHeaders();
        Map<String, FileHeader> map = new HashMap<>();
        headers.forEach(header ->
            map.put(header.isUnicode()? header.getFileNameW(): header.getFileNameString(), header)
        );
        return map;
    }

    @Override
    protected boolean isDirectory(FileHeader entry) {
        return entry.isDirectory();
    }

    @Override
    protected void extract(FileHeader entry, String outputFilePath) throws IOException {
        try (OutputStream os = Files.newOutputStream(Paths.get(outputFilePath))) {
            archive.extractFile(entry, os);
        } catch (RarException e) {
            throw new IOException(e);
        }
    }

    @Override
    protected void closeFile() throws IOException {
        if (archive != null) {
            archive.close();
        }
    }
}
