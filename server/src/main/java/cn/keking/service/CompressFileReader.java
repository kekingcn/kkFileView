package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileType;
import cn.keking.utils.FileHeaderRar;
import cn.keking.utils.KkFileUtils;
import cn.keking.web.filter.BaseUrlFilter;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.junrar.Archive;
import com.github.junrar.exception.RarException;
import com.github.junrar.rarfile.FileHeader;
import net.sf.sevenzipjbinding.*;
import net.sf.sevenzipjbinding.impl.RandomAccessFileInStream;
import net.sf.sevenzipjbinding.simple.ISimpleInArchive;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.springframework.stereotype.Component;

import java.io.*;
import java.math.BigDecimal;
import java.text.CollationKey;
import java.text.Collator;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * @author yudian-it
 * create 2017/11/27
 */
@Component
public class CompressFileReader {

    private static final Pattern pattern = Pattern.compile("^\\d+");
    private final FileHandlerService fileHandlerService;
    private final String fileDir = ConfigConstants.getFileDir();
    private final ExecutorService executors = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());

    public CompressFileReader(FileHandlerService fileHandlerService) {
        this.fileHandlerService = fileHandlerService;
    }

    public String unRar(String filePath, String fileKey) {
        Map<String, FileNode> appender = new HashMap<>();
        List<String> imgUrls = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        try {
            List<FileHeaderRar> items = getRar4Paths(filePath);
            String archiveFileName = fileHandlerService.getFileNameFromPath(filePath);
            List<Map<String, FileHeaderRar>> headersToBeExtract = new ArrayList<>();
            for (FileHeaderRar header : items) {
                String fullName = header.getFileNameW();
                String originName = getLastFileName(fullName);
                String childName = originName;
                boolean directory = header.getDirectory();
                if (!directory) {
                    childName = archiveFileName + "_" + originName;
                    headersToBeExtract.add(Collections.singletonMap(childName, header));
                }
                String parentName = getLast2FileName(fullName, archiveFileName);
                FileType type = FileType.typeFromUrl(childName);
                if (type.equals(FileType.PICTURE)) {
                    imgUrls.add(baseUrl + childName);
                }
                FileNode node =
                        new FileNode(originName, childName, parentName, new ArrayList<>(), directory, fileKey);
                addNodes(appender, parentName, node);
                appender.put(childName, node);
            }
            fileHandlerService.putImgCache(fileKey, imgUrls);
            executors.submit(new RarExtractorWorker(headersToBeExtract, filePath));
            return new ObjectMapper().writeValueAsString(appender.get(""));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<FileHeaderRar> getRar4Paths(String paths) {
        RandomAccessFile randomAccessFile = null;
        IInArchive inArchive = null;
        List<FileHeaderRar> itemPath = null;
        try {
            randomAccessFile = new RandomAccessFile(paths, "r");
            inArchive = SevenZip.openInArchive(null, new RandomAccessFileInStream(randomAccessFile));
            String folderName = paths.substring(paths.lastIndexOf(File.separator) + 1);
            String extractPath = paths.substring(0, paths.lastIndexOf(folderName));
            inArchive.extract(null, false, new ExtractCallback(inArchive, extractPath, folderName + "_"));
            ISimpleInArchive simpleInArchive = inArchive.getSimpleInterface();
            itemPath =
                    Arrays.stream(simpleInArchive.getArchiveItems())
                            .map(
                                    o -> {
                                        try {
                                            return new FileHeaderRar(o.getPath(), o.isFolder());
                                        } catch (SevenZipException e) {
                                            e.printStackTrace();
                                        }
                                        return null;
                                    })
                            .collect(Collectors.toList())
                            .stream()
                            .sorted(Comparator.comparing(FileHeaderRar::getFileNameW))
                            .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error occurs: " + e);
        } finally {
            if (inArchive != null) {
                try {
                    inArchive.close();
                } catch (SevenZipException e) {
                    System.err.println("Error closing archive: " + e);
                }
            }
            if (randomAccessFile != null) {
                try {
                    randomAccessFile.close();
                } catch (IOException e) {
                    System.err.println("Error closing file: " + e);
                }
            }
        }
        return itemPath;
    }


    private void addNodes(Map<String, FileNode> appender, String parentName, FileNode node) {
        if (appender.containsKey(parentName)) {
            appender.get(parentName).getChildList().add(node);
            appender.get(parentName).getChildList().sort(sortComparator);
        } else {
            // 根节点
            FileNode nodeRoot = new FileNode(parentName, parentName, "", new ArrayList<>(), true);
            nodeRoot.getChildList().add(node);
            appender.put("", nodeRoot);
            appender.put(parentName, nodeRoot);
        }
    }

    private static String getLast2FileName(String fullName, String rootName) {
        if (fullName.endsWith(File.separator)) {
            fullName = fullName.substring(0, fullName.length() - 1);
        }
        // 1.获取剩余部分
        int endIndex = fullName.lastIndexOf(File.separator);
        String leftPath = fullName.substring(0, endIndex == -1 ? 0 : endIndex);
        if (leftPath.length() > 1) {
            // 2.获取倒数第二个
            return getLastFileName(leftPath);
        } else {
            return rootName;
        }
    }

    private static String getLastFileName(String fullName) {
        if (fullName.endsWith(File.separator)) {
            fullName = fullName.substring(0, fullName.length() - 1);
        }
        String newName = fullName;
        if (fullName.contains(File.separator)) {
            newName = fullName.substring(fullName.lastIndexOf(File.separator) + 1);
        }
        return newName;
    }

    public static Comparator<FileNode> sortComparator = new Comparator<FileNode>() {
        final Collator cmp = Collator.getInstance(Locale.US);

        @Override
        public int compare(FileNode o1, FileNode o2) {
            // 判断两个对比对象是否是开头包含数字，如果包含数字则获取数字并按数字真正大小进行排序
            BigDecimal num1, num2;
            if (null != (num1 = isStartNumber(o1))
                    && null != (num2 = isStartNumber(o2))) {
                return num1.subtract(num2).intValue();
            }
            CollationKey c1 = cmp.getCollationKey(o1.getOriginName());
            CollationKey c2 = cmp.getCollationKey(o2.getOriginName());
            return cmp.compare(c1.getSourceString(), c2.getSourceString());
        }
    };

    private static BigDecimal isStartNumber(FileNode src) {
        Matcher matcher = pattern.matcher(src.getOriginName());
        if (matcher.find()) {
            return new BigDecimal(matcher.group());
        }
        return null;
    }

    public static class FileNode {

        private String originName;
        private String fileName;
        private String parentFileName;
        private boolean directory;
        //用于图片预览时寻址
        private String fileKey;
        private List<FileNode> childList;

        public FileNode(String originName, String fileName, String parentFileName, List<FileNode> childList, boolean directory) {
            this.originName = originName;
            this.fileName = fileName;
            this.parentFileName = parentFileName;
            this.childList = childList;
            this.directory = directory;
        }

        public FileNode(String originName, String fileName, String parentFileName, List<FileNode> childList, boolean directory, String fileKey) {
            this.originName = originName;
            this.fileName = fileName;
            this.parentFileName = parentFileName;
            this.childList = childList;
            this.directory = directory;
            this.fileKey = fileKey;
        }

        public String getFileKey() {
            return fileKey;
        }

        public void setFileKey(String fileKey) {
            this.fileKey = fileKey;
        }

        public String getFileName() {
            return fileName;
        }

        public void setFileName(String fileName) {
            this.fileName = fileName;
        }

        public String getParentFileName() {
            return parentFileName;
        }

        public void setParentFileName(String parentFileName) {
            this.parentFileName = parentFileName;
        }

        public List<FileNode> getChildList() {
            return childList;
        }

        public void setChildList(List<FileNode> childList) {
            this.childList = childList;
        }

        @Override
        public String toString() {
            try {
                return new ObjectMapper().writeValueAsString(this);
            } catch (JsonProcessingException e) {
                e.printStackTrace();
                return "";
            }
        }

        public String getOriginName() {
            return originName;
        }

        public void setOriginName(String originName) {
            this.originName = originName;
        }

        public boolean isDirectory() {
            return directory;
        }

        public void setDirectory(boolean directory) {
            this.directory = directory;
        }
    }

    class ZipExtractorWorker implements Runnable {

        private final List<Map<String, ZipArchiveEntry>> entriesToBeExtracted;
        private final ZipFile zipFile;
        private final String filePath;

        public ZipExtractorWorker(List<Map<String, ZipArchiveEntry>> entriesToBeExtracted, ZipFile zipFile, String filePath) {
            this.entriesToBeExtracted = entriesToBeExtracted;
            this.zipFile = zipFile;
            this.filePath = filePath;
        }

        @Override
        public void run() {
            for (Map<String, ZipArchiveEntry> entryMap : entriesToBeExtracted) {
                String childName = entryMap.keySet().iterator().next();
                ZipArchiveEntry entry = entryMap.values().iterator().next();
                try {
                    extractZipFile(childName, zipFile.getInputStream(entry));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            try {
                zipFile.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            KkFileUtils.deleteFileByPath(filePath);
        }

        private void extractZipFile(String childName, InputStream zipFile) {
            String outPath = fileDir + childName;
            try (OutputStream ot = new FileOutputStream(outPath)) {
                byte[] inByte = new byte[1024];
                int len;
                while ((-1 != (len = zipFile.read(inByte)))) {
                    ot.write(inByte, 0, len);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    class RarExtractorWorker implements Runnable {
        private final List<Map<String, FileHeader>> headersToBeExtracted;

        private final List<Map<String, FileHeaderRar>> headersToBeExtract;

        private final Archive archive;
        /**
         * 用以删除源文件
         */
        private final String filePath;

        public RarExtractorWorker(
                List<Map<String, FileHeader>> headersToBeExtracted, Archive archive, String filePath) {
            this.headersToBeExtracted = headersToBeExtracted;
            this.archive = archive;
            this.filePath = filePath;
            headersToBeExtract = null;
        }

        public RarExtractorWorker(
                List<Map<String, FileHeaderRar>> headersToBeExtract, String filePath) {
            this.headersToBeExtract = headersToBeExtract;
            this.filePath = filePath;
            archive = null;
            headersToBeExtracted = null;
        }

        @Override
        public void run() {
            for (Map<String, FileHeader> entryMap : headersToBeExtracted) {
                String childName = entryMap.keySet().iterator().next();
                extractRarFile(childName, entryMap.values().iterator().next(), archive);
            }
            try {
                archive.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            KkFileUtils.deleteFileByPath(filePath);
        }

        private void extractRarFile(String childName, FileHeader header, Archive archive) {
            String outPath = fileDir + childName;
            try (OutputStream ot = new FileOutputStream(outPath)) {
                archive.extractFile(header, ot);
            } catch (IOException | RarException e) {
                e.printStackTrace();
            }
        }
    }

    private static class ExtractCallback implements IArchiveExtractCallback {
        private final IInArchive inArchive;

        private final String extractPath;
        private final String folderName;

        public ExtractCallback(IInArchive inArchive, String extractPath, String folderName) {
            this.inArchive = inArchive;
            if (!extractPath.endsWith("/") && !extractPath.endsWith("\\")) {
                extractPath += File.separator;
            }
            this.extractPath = extractPath;
            this.folderName = folderName;
        }

        @Override
        public void setTotal(long total) {

        }

        @Override
        public void setCompleted(long complete) {

        }

        @Override
        public ISequentialOutStream getStream(int index, ExtractAskMode extractAskMode) throws SevenZipException {
            String filePath = inArchive.getStringProperty(index, PropID.PATH);
            String real = folderName + filePath.substring(filePath.lastIndexOf(File.separator) + 1);
            File f = new File(extractPath + real);
            f.delete();
            return data -> {
                FileOutputStream fos = null;
                try {
                    File path = new File(extractPath + real);
                    if (!path.getParentFile().exists()) {
                        path.getParentFile().mkdirs();
                    }
                    if (!path.exists()) {
                        path.createNewFile();
                    }
                    fos = new FileOutputStream(path, true);
                    fos.write(data);
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (fos != null) {
                            fos.flush();
                            fos.close();
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                return data.length;
            };
        }

        @Override
        public void prepareOperation(ExtractAskMode extractAskMode) {

        }

        @Override
        public void setOperationResult(ExtractOperationResult extractOperationResult) {
        }

    }
}
