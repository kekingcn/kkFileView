package cn.keking.service.compress;

import cn.keking.model.FileNode;
import cn.keking.model.FileType;
import cn.keking.service.FileHandlerService;
import cn.keking.utils.KkFileUtils;
import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 封装对压缩包的预览操作。预览压缩包的过程需要得到三部分内容：
 * <ol>
 *     <li>压缩包的树结构</li>
 *     <li>可预览的图片列表</li>
 *     <li>解压到目标文件夹</li>
 * </ol>
 *
 * @param <EntryType> 压缩项的类型
 */
public abstract class ArchiveProcessor<EntryType> {

    private static final Logger log = LoggerFactory.getLogger(ArchiveProcessor.class);

    protected final String archiveFilePath;

    protected final String outputRootPath;

    protected final FileHandlerService fileHandlerService;

    protected ArchiveProcessor(
        String archiveFilePath, FileHandlerService fileHandlerService
    ) {
        this.archiveFilePath = archiveFilePath;
        this.fileHandlerService = fileHandlerService;
        this.outputRootPath = Paths.get(archiveFilePath).getParent()
            .resolve(FilenameUtils.getBaseName(archiveFilePath))
            .toAbsolutePath().toString();
    }

    public ArchiveResult process() throws IOException {
        try {
            return process0();
        } finally {
            try {
                closeFile();
                KkFileUtils.deleteFileByPath(archiveFilePath);
            } catch (IOException e) {
                // ignore this
            }
        }
    }

    private ArchiveResult process0() throws IOException {
        Map<String, EntryType> entries = getEntries(archiveFilePath);
        Map<String, FileNode> fileNodeMap = new HashMap<>();
        List<String> imageUrls = new ArrayList<>();
        String archiveName = FilenameUtils.getName(archiveFilePath);

        for (Map.Entry<String, EntryType> mapItem : entries.entrySet()) {
            String entryName = mapItem.getKey();
            String outputFileName = entryName.replace("/", "@");
            EntryType entry = mapItem.getValue();
            boolean isDirectory = isDirectory(entry);

            // 构建 FileNode
            FileNode fileNode = new FileNode();
            fileNode.setFileKey(archiveName);
            fileNode.setFileName(outputFileName);
            fileNode.setParentFileName(getParentName(entryName));
            fileNode.setOriginName(FilenameUtils.getName(entryName));
            fileNode.setDirectory(isDirectory);
            fileNodeMap.put(entryName, fileNode);

            if (!isDirectory) {

                // 执行解压
                String outputFilePath = Paths.get(outputRootPath, outputFileName).toString();
                fileNode.setFileName(fileHandlerService.getRelativeUrl(outputFilePath));
                extract(entry, outputFilePath);

                // 添加图片列表
                FileType type = FileType.typeFromUrl(outputFileName);
                if (type.equals(FileType.PICTURE)) {
                    imageUrls.add(fileHandlerService.getFileUrl(outputFilePath));
                }
            }
        }

        FileNode root = new FileNode();
        root.setFileKey(archiveName);
        root.setFileName(archiveName);
        root.setOriginName(root.getFileName());
        root.setDirectory(true);
        fileNodeMap.put("", root);

        for (FileNode node : fileNodeMap.values()) {
            String parentFileName = node.getParentFileName();
            FileNode parentNode = fileNodeMap.get(parentFileName);
            if (parentNode != null) {
                parentNode.addChild(node);
            }
        }

        fileHandlerService.putImgCache(archiveName, imageUrls);

        return new ArchiveResult(root, imageUrls);
    }

    private String getParentName(String entryName) {
        int i = entryName.lastIndexOf("/");
        return i == -1 ? "" : entryName.substring(0, i);
    }

    ///////////////////////////////////////////////////////////////////

    protected abstract Map<String, EntryType> getEntries(String archiveFilePath) throws IOException;

    protected abstract boolean isDirectory(EntryType entry);

    protected abstract void extract(EntryType entry, String outputFilePath) throws IOException;

    protected abstract void closeFile() throws IOException;
}
