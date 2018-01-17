package cn.keking.utils;

import cn.keking.model.FileType;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.junrar.Archive;
import com.github.junrar.exception.RarException;
import com.github.junrar.rarfile.FileHeader;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.compress.archivers.zip.ZipArchiveEntry;
import org.apache.commons.compress.archivers.zip.ZipFile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;

import java.io.*;
import java.math.BigDecimal;
import java.text.CollationKey;
import java.text.Collator;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author yudian-it
 * @date 2017/11/27
 */
@Component
public class ZipReader {
    static Pattern pattern = Pattern.compile("^\\d+");

    @Autowired
    FileUtils fileUtils;
    @Value("${file.dir}")
    String fileDir;

    ExecutorService executors = Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors());

    /**
     * 读取压缩文件
     * 文件压缩到统一目录fileDir下，并且命名使用压缩文件名+文件名因为文件名
     * 可能会重复(在系统中对于同一种类型的材料压缩文件内的文件是一样的，如果文件名
     * 重复，那么这里会被覆盖[同一个压缩文件中的不同目录中的相同文件名暂时不考虑])
     * <b>注：</b>
     * <p>
     *     文件名命名中的参数的说明：
     *     1.archiveName，为避免解压的文件中有重名的文件会彼此覆盖，所以加上了archiveName，因为在ufile中archiveName
     *     是不会重复的。
     *     2.level，这里层级结构的列表我是通过一个map来构造的，map的key是文件的名字，值是对应的文件，这样每次向map中
     *     加入节点的时候都会获取父节点是否存在，存在则会获取父节点的value并将当前节点加入到父节点的childList中(这里利用
     *     的是java语言的引用的特性)。
     * </p>
     * @param filePath
     */
    public String readZipFile(String filePath,String fileKey) {
        String archiveSeparator = "/";
        Map<String, FileNode> appender = Maps.newHashMap();
        List imgUrls=Lists.newArrayList();
        String baseUrl= (String) RequestContextHolder.currentRequestAttributes().getAttribute("baseUrl",0);
        String archiveFileName = fileUtils.getFileNameFromPath(filePath);
        try {
            ZipFile zipFile = new ZipFile(filePath, fileUtils.getFileEncodeUTFGBK(filePath));
            Enumeration<ZipArchiveEntry> entries = zipFile.getEntries();
            // 排序
            entries = sortZipEntries(entries);
            List<Map<String, ZipArchiveEntry>> entriesToBeExtracted = Lists.newArrayList();
            while (entries.hasMoreElements()){
                ZipArchiveEntry entry = entries.nextElement();
                String fullName = entry.getName();
                int level = fullName.split(archiveSeparator).length;
                // 展示名
                String originName = getLastFileName(fullName, archiveSeparator);
                String childName = level + "_" + originName;
                boolean directory = entry.isDirectory();
                if (!directory) {
                    childName = archiveFileName + "_" + originName;
                    entriesToBeExtracted.add(Collections.singletonMap(childName, entry));
                }
                String parentName = getLast2FileName(fullName, archiveSeparator, archiveFileName);
                parentName = (level-1) + "_" + parentName;
                FileType type=fileUtils.typeFromUrl(childName);
                if (type.equals(FileType.picture)){//添加图片文件到图片列表
                    imgUrls.add(baseUrl+childName);
                }
                FileNode node = new FileNode(originName, childName, parentName, new ArrayList<>(), directory,fileKey);
                addNodes(appender, parentName, node);
                appender.put(childName, node);
            }
            // 开启新的线程处理文件解压
            executors.submit(new ZipExtractorWorker(entriesToBeExtracted, zipFile, filePath));
            fileUtils.setRedisImgUrls(fileKey,imgUrls);
            return new ObjectMapper().writeValueAsString(appender.get(""));
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }



    /**
     * 排序zipEntries(对原来列表倒序)
     * @param entries
     */
    private Enumeration<ZipArchiveEntry> sortZipEntries(Enumeration<ZipArchiveEntry> entries) {
        List<ZipArchiveEntry> sortedEntries = Lists.newArrayList();
        while(entries.hasMoreElements()){
            sortedEntries.add(entries.nextElement());
        }
        Collections.sort(sortedEntries, Comparator.comparingInt(o -> o.getName().length()));
        return Collections.enumeration(sortedEntries);
    }

    public String unRar(String filePath,String fileKey){
        Map<String, FileNode> appender = Maps.newHashMap();
        List imgUrls=Lists.newArrayList();
        String baseUrl= (String) RequestContextHolder.currentRequestAttributes().getAttribute("baseUrl",0);
        try {
            Archive archive = new Archive(new File(filePath));
            List<FileHeader> headers = archive.getFileHeaders();
            headers = sortedHeaders(headers);
            String archiveFileName = fileUtils.getFileNameFromPath(filePath);
            List<Map<String, FileHeader>> headersToBeExtracted = Lists.newArrayList();
            for (FileHeader header : headers) {
                String fullName;
                if (header.isUnicode()) {
                    fullName = header.getFileNameW();
                }else {
                    fullName = header.getFileNameString();
                }
                // 展示名
                String originName = getLastFileName(fullName, "\\");
                String childName = originName;
                boolean directory = header.isDirectory();
                if (!directory) {
                    childName = archiveFileName + "_" + originName;
                    headersToBeExtracted.add(Collections.singletonMap(childName, header));
                }
                String parentName = getLast2FileName(fullName, "\\", archiveFileName);
                FileType type=fileUtils.typeFromUrl(childName);
                if (type.equals(FileType.picture)){//添加图片文件到图片列表
                    imgUrls.add(baseUrl+childName);
                }
                FileNode node = new FileNode(originName, childName, parentName, new ArrayList<>(), directory,fileKey);
                addNodes(appender, parentName, node);
                appender.put(childName, node);
            }
            executors.submit(new RarExtractorWorker(headersToBeExtracted, archive, filePath));
            fileUtils.setRedisImgUrls(fileKey,imgUrls);
            return new ObjectMapper().writeValueAsString(appender.get(""));
        } catch (RarException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void addNodes(Map<String, FileNode> appender, String parentName, FileNode node) {
        if (appender.containsKey(parentName)) {
            appender.get(parentName).getChildList().add(node);
            Collections.sort(appender.get(parentName).getChildList(), sortComparator);
//            appender.get(parentName).getChildList().sort((final FileNode h1, final FileNode h2) -> h1.getOriginName().compareTo(h2.getOriginName()));//排序
        }else { // 根节点
            FileNode nodeRoot = new FileNode(parentName, parentName, "", new ArrayList<>(), true);
            nodeRoot.getChildList().add(node);
            appender.put("", nodeRoot);
            appender.put(parentName, nodeRoot);
        }
    }

    private List<FileHeader> sortedHeaders(List<FileHeader> headers) {
        List<FileHeader> sortedHeaders = new ArrayList<>();
        Map<Integer, FileHeader> mapHeaders = new TreeMap<>();
        headers.forEach(header -> mapHeaders.put(header.getFileNameW().length(), header));
        for (Map.Entry<Integer, FileHeader> entry : mapHeaders.entrySet()){
            for (FileHeader header : headers) {
                if (entry.getKey().intValue() == header.getFileNameW().length()) {
                    sortedHeaders.add(header);
                }
            }
        }
        return sortedHeaders;
    }

    /**
     * 获取倒数第二个文件(夹)名
     * @param fullName
     * @param seperator
     *       压缩文件解压后，不同的压缩格式分隔符不一样zip是/，而rar是\
     * @param rootName
     *      根目录名:如果倒数第二个路径为空，那么赋值为rootName
     * @return
     */
    private static String getLast2FileName(String fullName, String seperator, String rootName) {
        if (fullName.endsWith(seperator)) {
            fullName = fullName.substring(0, fullName.length()-1);
        }
        // 1.获取剩余部分
        int endIndex = fullName.lastIndexOf(seperator);
        String leftPath = fullName.substring(0, endIndex == -1 ? 0 : endIndex);
        if (null != leftPath && leftPath.length() > 1) {
            // 2.获取倒数第二个
            return getLastFileName(leftPath, seperator);
        }else {
            return rootName;
        }
    }

    /**
     * 获取最后一个文件(夹)的名字
     * @param fullName
     * @param seperator
     *       压缩文件解压后，不同的压缩格式分隔符不一样zip是/，而rar是\
     * @return
     */
    private static String getLastFileName(String fullName, String seperator) {
        if (fullName.endsWith(seperator)) {
            fullName = fullName.substring(0, fullName.length()-1);
        }
        String newName = fullName;
        if (null != fullName && fullName.contains(seperator)) {
            newName = fullName.substring(fullName.lastIndexOf(seperator) + 1);
        }
        return newName;
    }

    public static Comparator<FileNode> sortComparator = new Comparator<FileNode>() {
        Collator cmp = Collator.getInstance(Locale.US);
        @Override
        public int compare(FileNode o1, FileNode o2) {
            // 判断两个对比对象是否是开头包含数字，如果包含数字则获取数字并按数字真正大小进行排序
            BigDecimal num1,num2;
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

    /**
     * 文件节点(区分文件上下级)
     */
    public class FileNode{

        private String originName;
        private String fileName;
        private String parentFileName;
        private boolean directory;
        private String fileKey;//用于图片预览时寻址
        private List<FileNode> childList;

        public FileNode() {
        }

        public FileNode(String originName, String fileName, String parentFileName, List<FileNode> childList, boolean directory) {
            this.originName = originName;
            this.fileName = fileName;
            this.parentFileName = parentFileName;
            this.childList = childList;
            this.directory = directory;
        }
        public FileNode(String originName, String fileName, String parentFileName, List<FileNode> childList, boolean directory,String fileKey) {
            this.originName = originName;
            this.fileName = fileName;
            this.parentFileName = parentFileName;
            this.childList = childList;
            this.directory = directory;
            this.fileKey=fileKey;
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

    /**
     * Zip文件抽取线程
     */
    class ZipExtractorWorker implements Runnable {

        private List<Map<String, ZipArchiveEntry>> entriesToBeExtracted;
        private ZipFile zipFile;
        private String filePath;

        public ZipExtractorWorker(List<Map<String, ZipArchiveEntry>> entriesToBeExtracted, ZipFile zipFile, String filePath) {
            this.entriesToBeExtracted = entriesToBeExtracted;
            this.zipFile = zipFile;
            this.filePath = filePath;
        }

        @Override
        public void run() {
            System.out.println("解析压缩文件开始《《《《《《《《《《《《《《《《《《《《《《《");
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
            if (new File(filePath).exists()) {
                new File(filePath).delete();
            }
            System.out.println("解析压缩文件结束《《《《《《《《《《《《《《《《《《《《《《《");
        }


        /**
         * 读取压缩文件并写入到fileDir文件夹下
         * @param childName
         * @param zipFile
         */
        private void extractZipFile(String childName, InputStream zipFile) {
            String outPath = fileDir + childName;
            try (OutputStream ot = new FileOutputStream(outPath)){
                byte[] inByte = new byte[1024];
                int len;
                while ((-1 != (len = zipFile.read(inByte)))){
                    ot.write(inByte, 0, len);
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Rar文件抽取
     */
    class RarExtractorWorker implements Runnable {
        private List<Map<String, FileHeader>> headersToBeExtracted;
        private Archive archive;
        /**
         * 用以删除源文件
         */
        private String filePath;

        public RarExtractorWorker(List<Map<String, FileHeader>> headersToBeExtracted, Archive archive, String filePath) {
            this.headersToBeExtracted = headersToBeExtracted;
            this.archive = archive;
            this.filePath = filePath;
        }

        @Override
        public void run() {
            System.out.println("解析压缩文件开始《《《《《《《《《《《《《《《《《《《《《《《");
            for (Map<String, FileHeader> entryMap : headersToBeExtracted) {
                String childName = entryMap.keySet().iterator().next();
                extractRarFile(childName, entryMap.values().iterator().next(), archive);
            }
            try {
                archive.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (new File(filePath).exists()) {
                new File(filePath).delete();
            }
            System.out.println("解析压缩文件结束《《《《《《《《《《《《《《《《《《《《《《《");
        }

        /**
         * 抽取rar文件到指定目录下
         * @param childName
         * @param header
         * @param archive
         */
        private void extractRarFile(String childName, FileHeader header, Archive archive) {
            String outPath = fileDir + childName;
            try(OutputStream ot = new FileOutputStream(outPath)) {
                archive.extractFile(header, ot);
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } catch (RarException e) {
                e.printStackTrace();
            }
        }
    }
}
