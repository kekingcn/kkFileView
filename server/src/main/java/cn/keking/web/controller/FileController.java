package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileType;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.CaptchaUtil;
import cn.keking.utils.DateUtils;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.RarUtils;
import cn.keking.utils.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.InvalidPathException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.attribute.BasicFileAttributes;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;

import static cn.keking.utils.CaptchaUtil.CAPTCHA_CODE;
import static cn.keking.utils.CaptchaUtil.CAPTCHA_GENERATE_TIME;

/**
 * @author yudian-it
 * 2017/12/1
 */
@RestController
public class FileController {

    private final Logger logger = LoggerFactory.getLogger(FileController.class);

    private final String fileDir = ConfigConstants.getFileDir();
    private final String demoDir = "demo";

    private final String demoPath = demoDir + File.separator;
    public static final String BASE64_DECODE_ERROR_MSG = "Base64解码失败，请检查你的 %s 是否采用 Base64 + urlEncode 双重编码了！";

    // 文件列表性能配置
    private static final int MAX_PAGE_SIZE = 100;
    private static final int MAX_TOTAL_FILES = 20000;
    private static final String DEFAULT_SORT_FIELD = null; // null表示使用默认排序（文件夹优先+时间降序）
    private static final String DEFAULT_ORDER = "desc";
    private static final boolean ENABLE_PERFORMANCE_LOG = true;
    private static final int PERFORMANCE_LOG_THRESHOLD = 1000; // 超过1000个文件记录性能日志

    // 内部类，用于高效存储文件信息
    private static class FileInfoWrapper implements Comparable<FileInfoWrapper> {
        private final String name;
        private final boolean isDirectory;
        private final long lastModified;
        private final long size;
        private final Path filePath;
        private Long creationTime = null;
        private boolean creationTimeLoaded = false;

        public FileInfoWrapper(File file) {
            this.name = file.getName();
            this.isDirectory = file.isDirectory();
            this.lastModified = file.lastModified();
            this.size = file.length();
            this.filePath = file.toPath();
        }

        public void loadCreationTime() {
            if (!creationTimeLoaded) {
                try {
                    BasicFileAttributes attrs = Files.readAttributes(filePath, BasicFileAttributes.class);
                    creationTime = attrs.creationTime().toMillis();
                } catch (IOException e) {
                    creationTime = lastModified; // 如果获取失败，使用修改时间
                }
                creationTimeLoaded = true;
            }
        }

        public String getName() { return name; }
        public boolean isDirectory() { return isDirectory; }
        public long getLastModified() { return lastModified; }
        public long getSize() { return size; }
        public Long getCreationTime() {
            if (!creationTimeLoaded) {
                loadCreationTime();
            }
            return creationTime;
        }
        public Path getFilePath() { return filePath; }

        @Override
        public int compareTo(FileInfoWrapper other) {
            return this.name.compareToIgnoreCase(other.name);
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            FileInfoWrapper that = (FileInfoWrapper) obj;
            return name.equalsIgnoreCase(that.name);
        }

        @Override
        public int hashCode() {
            return name.toLowerCase().hashCode();
        }
    }

    // 性能统计类
    private static class PerformanceStats {
        private final long startTime;
        private int fileCount;
        private int matchingCount;

        public PerformanceStats() {
            this.startTime = System.currentTimeMillis();
        }

        public void incrementFileCount() {
            fileCount++;
        }

        public void incrementMatchingCount() {
            matchingCount++;
        }

        public String getStats() {
            long endTime = System.currentTimeMillis();
            long duration = endTime - startTime;
            return String.format("处理 %d 个文件（匹配 %d 个），耗时 %d ms",
                    fileCount, matchingCount, duration);
        }
    }

    @PostMapping("/fileUpload")
    public ReturnResponse<Object> fileUpload(@RequestParam("file") MultipartFile file,
                                             @RequestParam(value = "path", defaultValue = "") String path) {
        ReturnResponse<Object> checkResult = this.fileUploadCheck(file, path);
        if (checkResult.isFailure()) {
            return checkResult;
        }

        String uploadPath = fileDir + demoPath;
        if (!ObjectUtils.isEmpty(path)) {
            uploadPath += path + File.separator;
        }

        File outFile = new File(uploadPath);
        if (!outFile.exists() && !outFile.mkdirs()) {
            logger.error("创建文件夹【{}】失败，请检查目录权限！", uploadPath);
            return ReturnResponse.failure("创建文件夹失败，请检查目录权限！");
        }

        String fileName = checkResult.getContent().toString();
        logger.info("上传文件：{}{}", uploadPath, fileName);

        try (InputStream in = file.getInputStream();
             OutputStream out = Files.newOutputStream(Paths.get(uploadPath + fileName))) {
            StreamUtils.copy(in, out);
            return ReturnResponse.success(null);
        } catch (IOException e) {
            logger.error("文件上传失败", e);
            return ReturnResponse.failure("文件上传失败");
        }
    }

    @PostMapping("/createFolder")
    public ReturnResponse<Object> createFolder(@RequestParam(value = "path", defaultValue = "") String path,
                                               @RequestParam("folderName") String folderName) {
        if (ConfigConstants.getFileUploadDisable()) {
            return ReturnResponse.failure("文件上传接口已禁用");
        }
        try {
            // 验证文件夹名称
            if (ObjectUtils.isEmpty(folderName)) {
                return ReturnResponse.failure("文件夹名称不能为空");
            }

            if (KkFileUtils.isIllegalFileName(folderName)) {
                return ReturnResponse.failure("非法文件夹名称");
            }
            String basePath = fileDir + demoPath;
            if (!ObjectUtils.isEmpty(path)) {
                basePath += path + File.separator;
            }

            File newFolder = new File(basePath + folderName);
            if (newFolder.exists()) {
                return ReturnResponse.failure("文件夹已存在");
            }

            if (newFolder.mkdirs()) {
                logger.info("创建文件夹：{}", newFolder.getAbsolutePath());
                return ReturnResponse.success();
            } else {
                logger.error("创建文件夹失败：{}", newFolder.getAbsolutePath());
                return ReturnResponse.failure("创建文件夹失败，请检查目录权限");
            }
        } catch (Exception e) {
            logger.error("创建文件夹异常", e);
            return ReturnResponse.failure("创建文件夹失败：" + e.getMessage());
        }
    }

    @PostMapping("/deleteFile")
    public ReturnResponse<Object> deleteFile(HttpServletRequest request, String fileName, String password) {
        ReturnResponse<Object> checkResult = this.deleteFileCheck(request, fileName, password);
        if (checkResult.isFailure()) {
            return checkResult;
        }
        fileName = checkResult.getContent().toString();

        // 构建完整路径
        String fullPath = fileDir + demoPath + fileName;
        File file = new File(fullPath);

        logger.info("删除文件/文件夹：{}", file.getAbsolutePath());
        if (file.exists()) {
            if (file.isDirectory()) {
                // 删除文件夹及其内容
                if (deleteDirectory(file)) {
                    WebUtils.removeSessionAttr(request, CAPTCHA_CODE);
                    return ReturnResponse.success();
                } else {
                    String msg = String.format("删除文件夹【%s】失败，请检查目录权限！", file.getPath());
                    logger.error(msg);
                    return ReturnResponse.failure(msg);
                }
            } else {
                // 删除文件
                if (file.delete()) {
                    WebUtils.removeSessionAttr(request, CAPTCHA_CODE);
                    return ReturnResponse.success();
                } else {
                    String msg = String.format("删除文件【%s】失败，请检查目录权限！", file.getPath());
                    logger.error(msg);
                    return ReturnResponse.failure(msg);
                }
            }
        } else {
            return ReturnResponse.failure("文件或文件夹不存在");
        }
    }

    /**
     * 递归删除目录
     */
    private boolean deleteDirectory(File dir) {
        if (dir.isDirectory()) {
            File[] children = dir.listFiles();
            if (children != null) {
                for (File child : children) {
                    boolean success = deleteDirectory(child);
                    if (!success) {
                        return false;
                    }
                }
            }
        }
        return dir.delete();
    }

    /**
     * 验证码方法
     */
    @RequestMapping("/deleteFile/captcha")
    public void captcha(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!ConfigConstants.getDeleteCaptcha()) {
            return;
        }

        response.setContentType("image/jpeg");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", -1);
        String captchaCode = WebUtils.getSessionAttr(request, CAPTCHA_CODE);
        long captchaGenerateTime = WebUtils.getLongSessionAttr(request, CAPTCHA_GENERATE_TIME);
        long timeDifference = DateUtils.calculateCurrentTimeDifference(captchaGenerateTime);

        // 验证码为空，且生成验证码超过50秒，重新生成验证码
        if (timeDifference > 50 && ObjectUtils.isEmpty(captchaCode)) {
            captchaCode = CaptchaUtil.generateCaptchaCode();
            // 更新验证码
            WebUtils.setSessionAttr(request, CAPTCHA_CODE, captchaCode);
            WebUtils.setSessionAttr(request, CAPTCHA_GENERATE_TIME, DateUtils.getCurrentSecond());
        } else {
            captchaCode = ObjectUtils.isEmpty(captchaCode) ? "wait" : captchaCode;
        }

        ServletOutputStream outputStream = response.getOutputStream();
        ImageIO.write(CaptchaUtil.generateCaptchaPic(captchaCode), "jpeg", outputStream);
        outputStream.close();
    }

    /**
     * 生产环境优化版本：先收集所有路径，按名称排序，再处理
     * 优点：确保不丢失文件，结果确定性，统计准确
     */
    @PostMapping("/listFiles")
    public Map<String, Object> getFiles(@RequestParam(value = "path", defaultValue = "") String path,
                                        @RequestParam(value = "searchText", defaultValue = "") String searchText,
                                        @RequestParam(defaultValue = "0") int page,
                                        @RequestParam(defaultValue = "20") int size,
                                        @RequestParam(required = false) String sort,
                                        @RequestParam(required = false) String order) {

        Map<String, Object> result = new HashMap<>();
        PerformanceStats stats = new PerformanceStats();

        try {
            // ==================== 1. 参数验证和限制 ====================
            if (page < 0) page = 0;
            if (size <= 0) size = 20;
            if (size > MAX_PAGE_SIZE) size = MAX_PAGE_SIZE;

            // 验证排序参数
            if (sort != null && !isValidSortParameter(sort)) {
                logger.warn("无效的排序字段: {}, 使用默认排序", sort);
                sort = DEFAULT_SORT_FIELD;
            }

            // 验证排序方向
            if (order != null && !isValidOrderParameter(order)) {
                logger.warn("无效的排序方向: {}, 使用默认方向", order);
                order = DEFAULT_ORDER;
            }

            // ==================== 2. 构建路径和验证 ====================
            Path currentDir;
            try {
                currentDir = resolveDirectoryUnderRoot(Paths.get(fileDir, demoDir), path);
            } catch (InvalidPathException | SecurityException e) {
                logger.warn("拒绝访问 demo 目录之外的文件列表路径");
                result.put("total", 0);
                result.put("data", Collections.emptyList());
                result.put("error", "非法目录路径");
                return result;
            } catch (IOException e) {
                logger.error("解析 demo 目录失败", e);
                result.put("total", 0);
                result.put("data", Collections.emptyList());
                return result;
            }

            if (!Files.isDirectory(currentDir)) {
                result.put("total", 0);
                result.put("data", Collections.emptyList());
                return result;
            }

            // ==================== 3. 收集所有文件路径 ====================
            List<Path> allPaths = new ArrayList<>();
            long collectStartTime = System.currentTimeMillis();

            try (DirectoryStream<Path> stream = Files.newDirectoryStream(currentDir)) {
                for (Path entry : stream) {
                    allPaths.add(entry);
                    stats.incrementFileCount();
                }
            } catch (IOException e) {
                logger.error("读取目录失败: {}", currentDir, e);
                result.put("total", 0);
                result.put("data", Collections.emptyList());
                return result;
            }

            long collectEndTime = System.currentTimeMillis();
            int totalFilesInDirectory = allPaths.size();

            // ==================== 4. 按名称排序确保确定性 ====================
            // 按文件名排序，确保每次结果一致
            allPaths.sort(Comparator.comparing(pathh -> pathh.getFileName().toString().toLowerCase()));
            long sortEndTime = System.currentTimeMillis();

            // ==================== 5. 遍历排序后的路径，进行过滤和处理 ====================
            List<FileInfoWrapper> matchedFiles = new ArrayList<>();
            int actualMatchingCount = 0;
            boolean truncated = false;

            String searchLower = ObjectUtils.isEmpty(searchText) ? null : searchText.toLowerCase();

            for (Path entry : allPaths) {
                File file = entry.toFile();

                // 搜索过滤
                if (searchLower != null) {
                    if (!file.getName().toLowerCase().contains(searchLower)) {
                        continue; // 不匹配，跳过
                    }
                }

                // 统计匹配总数
                actualMatchingCount++;
                stats.incrementMatchingCount();

                // 如果还没达到最大处理限制，添加到结果集
                if (matchedFiles.size() < MAX_TOTAL_FILES) {
                    matchedFiles.add(new FileInfoWrapper(file));
                } else {
                    // 超过限制，标记截断但继续计数
                    truncated = true;
                }
            }

            long filterEndTime = System.currentTimeMillis();
            int displayedCount = matchedFiles.size(); // 实际显示的数量

            // ==================== 6. 根据排序需求加载额外属性 ====================
            if ("creationTime".equals(sort)) {
                // 如果需要按创建时间排序，提前加载创建时间
                for (FileInfoWrapper info : matchedFiles) {
                    info.loadCreationTime();
                }
            }

            // ==================== 7. 排序 ====================
            Comparator<FileInfoWrapper> comparator = getFileInfoComparator(sort, order);
            if (comparator != null) {
                // 根据文件数量选择合适的排序策略
                if (matchedFiles.size() > 1000) {
                    // 大文件集使用并行排序
                    matchedFiles.sort(comparator);
                } else {
                    matchedFiles.sort(comparator);
                }
            }

            long sortingEndTime = System.currentTimeMillis();

            // ==================== 8. 分页处理 ====================
            List<Map<String, Object>> fileList = new ArrayList<>();
            int start = page * size;
            int end = Math.min(start + size, displayedCount);

            if (start < displayedCount) {
                for (int i = start; i < end; i++) {
                    FileInfoWrapper info = matchedFiles.get(i);
                    Map<String, Object> fileInfo = convertFileInfoToMap(info, path);
                    fileList.add(fileInfo);
                }
            }

            long pagingEndTime = System.currentTimeMillis();

            // ==================== 9. 构建返回结果 ====================
            result.put("total", actualMatchingCount); // 实际匹配总数
            result.put("displayedCount", displayedCount); // 实际显示的数量
            result.put("totalInDirectory", totalFilesInDirectory); // 目录中总文件数
            result.put("data", fileList);
            result.put("page", page);
            result.put("size", size);
            result.put("totalPages", (int) Math.ceil((double) actualMatchingCount / size));

            // 添加性能统计（如果需要）
            if (ENABLE_PERFORMANCE_LOG && totalFilesInDirectory > PERFORMANCE_LOG_THRESHOLD) {
                result.put("performance", buildPerformanceStats(
                        collectEndTime - collectStartTime,
                        sortEndTime - collectEndTime,
                        filterEndTime - sortEndTime,
                        sortingEndTime - filterEndTime,
                        pagingEndTime - sortingEndTime,
                        pagingEndTime - collectStartTime
                ));
            }

            // 如果有限制，告知用户
            if (truncated) {
                result.put("warning", String.format(
                        "文件数量过多（匹配 %d 个文件），仅显示前 %d 个文件（按名称排序）。请使用搜索功能缩小范围。",
                        actualMatchingCount, MAX_TOTAL_FILES
                ));
                result.put("truncated", true);
            }

            // 记录性能日志
            if (ENABLE_PERFORMANCE_LOG && totalFilesInDirectory > PERFORMANCE_LOG_THRESHOLD) {
                logger.info("文件列表查询性能: {}", stats.getStats());
            }

        } catch (Exception e) {
            logger.error("获取文件列表失败", e);
            result.put("total", 0);
            result.put("data", Collections.emptyList());
            result.put("error", "获取文件列表失败: " + e.getMessage());
        }

        return result;
    }

    /**
     * Resolve an existing directory below the configured demo root.
     *
     * <p>Both lexical normalization and real-path checks are required: the
     * former blocks traversal and absolute paths, while the latter prevents a
     * symlink inside the demo directory from escaping the configured root.</p>
     */
    static Path resolveDirectoryUnderRoot(Path root, String requestedPath) throws IOException {
        Path normalizedRoot = root.toAbsolutePath().normalize();
        String relativePath = requestedPath == null ? "" : requestedPath.replace('\\', '/');

        if (relativePath.indexOf('\0') >= 0
                || relativePath.startsWith("/")
                || relativePath.matches("^[A-Za-z]:.*")) {
            throw new SecurityException("Absolute paths are not allowed");
        }

        Path relative = Paths.get(relativePath);
        if (relative.isAbsolute()) {
            throw new SecurityException("Absolute paths are not allowed");
        }
        for (Path segment : relative) {
            if ("..".equals(segment.toString())) {
                throw new SecurityException("Parent path segments are not allowed");
            }
        }

        Path resolved = normalizedRoot.resolve(relative).normalize();
        if (!resolved.startsWith(normalizedRoot)) {
            throw new SecurityException("Path escapes the configured root");
        }

        Path realRoot = normalizedRoot.toRealPath();
        Path realResolved = resolved.toRealPath();
        if (!realResolved.startsWith(realRoot)) {
            throw new SecurityException("Path escapes the configured root through a symbolic link");
        }
        return realResolved;
    }

    /**
     * 构建性能统计信息
     */
    private Map<String, Object> buildPerformanceStats(long collectTime, long sortTime,
                                                      long filterTime, long sortingTime,
                                                      long pagingTime, long totalTime) {
        Map<String, Object> perfStats = new HashMap<>();
        perfStats.put("collectPaths", collectTime + "ms");
        perfStats.put("sortPaths", sortTime + "ms");
        perfStats.put("filterFiles", filterTime + "ms");
        perfStats.put("sortResults", sortingTime + "ms");
        perfStats.put("paging", pagingTime + "ms");
        perfStats.put("total", totalTime + "ms");
        return perfStats;
    }

    /**
     * 验证排序参数
     */
    private boolean isValidSortParameter(String sort) {
        if (sort == null || sort.trim().isEmpty()) {
            return true;
        }

        Set<String> validSorts = new HashSet<>(Arrays.asList(
                "name", "lastModified", "creationTime", "size", "isDirectory"
        ));

        return validSorts.contains(sort.trim().toLowerCase());
    }

    /**
     * 验证排序方向参数
     */
    private boolean isValidOrderParameter(String order) {
        if (order == null || order.trim().isEmpty()) {
            return true;
        }

        String orderLower = order.trim().toLowerCase();
        return "asc".equals(orderLower) || "desc".equals(orderLower);
    }

    /**
     * 获取文件信息比较器
     */
    private Comparator<FileInfoWrapper> getFileInfoComparator(String sort, String order) {
        if (sort == null || sort.trim().isEmpty()) {
            // 默认排序：文件夹优先，然后按修改时间降序
            return (f1, f2) -> {
                // 空安全检查
                if (f1 == null && f2 == null) return 0;
                if (f1 == null) return 1;
                if (f2 == null) return -1;

                // 文件夹优先
                boolean f1IsDir = f1.isDirectory();
                boolean f2IsDir = f2.isDirectory();

                if (f1IsDir && !f2IsDir) return -1;
                if (!f1IsDir && f2IsDir) return 1;

                // 都是文件夹或都是文件时，按修改时间降序
                long time1 = f1.getLastModified();
                long time2 = f2.getLastModified();

                if (time1 != time2) {
                    // 使用 Long.compare 返回 int，避免转换
                    return Long.compare(time2, time1); // 降序：time2 - time1
                }

                // 修改时间相同，按名称升序（忽略大小写）
                return String.CASE_INSENSITIVE_ORDER.compare(f1.getName(), f2.getName());
            };
        }

        boolean isDesc = "desc".equalsIgnoreCase(order);
        String sortLower = sort.toLowerCase();

        switch (sortLower) {
            case "name":
                Comparator<FileInfoWrapper> nameComparator = Comparator.comparing(
                        FileInfoWrapper::getName, String.CASE_INSENSITIVE_ORDER
                );
                return isDesc ? nameComparator.reversed() : nameComparator;

            case "lastmodified":
                Comparator<FileInfoWrapper> timeComparator = Comparator.comparing(FileInfoWrapper::getLastModified);
                return isDesc ? timeComparator.reversed() : timeComparator;

            case "creationtime":
                Comparator<FileInfoWrapper> creationTimeComparator = Comparator.comparing(FileInfoWrapper::getCreationTime);
                return isDesc ? creationTimeComparator.reversed() : creationTimeComparator;

            case "size":
                // 文件夹优先，然后按大小排序
                Comparator<FileInfoWrapper> sizeComparator = (f1, f2) -> {
                    if (f1 == null && f2 == null) return 0;
                    if (f1 == null) return 1;
                    if (f2 == null) return -1;

                    boolean f1IsDir = f1.isDirectory();
                    boolean f2IsDir = f2.isDirectory();

                    if (f1IsDir && !f2IsDir) return -1;
                    if (!f1IsDir && f2IsDir) return 1;
                    if (f1IsDir && f2IsDir) {
                        // 都是文件夹按名称排序
                        return f1.getName().compareToIgnoreCase(f2.getName());
                    }

                    // 都是文件时按大小排序
                    return Long.compare(f1.getSize(), f2.getSize());
                };
                return isDesc ? sizeComparator.reversed() : sizeComparator;

            case "isdirectory":
                // 按文件夹优先排序
                return (f1, f2) -> {
                    if (f1 == null && f2 == null) return 0;
                    if (f1 == null) return 1;
                    if (f2 == null) return -1;

                    boolean f1IsDir = f1.isDirectory();
                    boolean f2IsDir = f2.isDirectory();

                    if (f1IsDir && !f2IsDir) return -1;
                    if (!f1IsDir && f2IsDir) return 1;

                    // 都是文件夹或都是文件时，按修改时间降序
                    long time1 = f1.getLastModified();
                    long time2 = f2.getLastModified();

                    if (time1 != time2) {
                        return Long.compare(time2, time1); // 降序
                    }

                    // 修改时间相同，按名称升序
                    return String.CASE_INSENSITIVE_ORDER.compare(f1.getName(), f2.getName());
                };

            default:
                logger.warn("未知的排序字段: {}, 使用默认排序", sort);
                // 返回默认比较器
                return getFileInfoComparator(null, order);
        }
    }

    /**
     * 将 FileInfoWrapper 转换为 Map
     */
    private Map<String, Object> convertFileInfoToMap(FileInfoWrapper info, String path) {
        Map<String, Object> fileMap = new HashMap<>();

        fileMap.put("name", info.getName());
        fileMap.put("isDirectory", info.isDirectory());
        fileMap.put("lastModified", info.getLastModified());
        fileMap.put("size", info.getSize());
        fileMap.put("creationTime", info.getCreationTime());

        // 构建路径信息
        String relativePath = demoDir + "/" + (ObjectUtils.isEmpty(path) ? "" : path + "/") + info.getName();
        fileMap.put("relativePath", relativePath);

        // 如果是目录，保存完整的相对路径用于导航
        if (info.isDirectory()) {
            String fullPath = ObjectUtils.isEmpty(path) ? info.getName() : path + "/" + info.getName();
            fileMap.put("fullPath", fullPath);
        }

        return fileMap;
    }

    /**
     * 上传文件前校验
     */
    private ReturnResponse<Object> fileUploadCheck(MultipartFile file, String path) {
        if (ConfigConstants.getFileUploadDisable()) {
            return ReturnResponse.failure("文件上传接口已禁用");
        }

        String fileName = WebUtils.getFileNameFromMultipartFile(file);
        if (fileName.lastIndexOf(".") == -1) {
            return ReturnResponse.failure("不允许上传的类型");
        }
        if (!KkFileUtils.isAllowedUpload(fileName)) {
            return ReturnResponse.failure("不允许上传的文件类型: " + fileName);
        }
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return ReturnResponse.failure("不允许上传的文件名: " + fileName);
        }
        FileType type = FileType.typeFromFileName(fileName);
        if (Objects.equals(type, FileType.OTHER)) {
            return ReturnResponse.failure("该文件格式还不支持预览，请联系管理员，添加该格式: " + fileName);
        }

        // 判断是否存在同名文件
        if (existsFile(fileName, path)) {
            return ReturnResponse.failure("存在同名文件，请先删除原有文件再次上传");
        }

        return ReturnResponse.success(fileName);
    }

    /**
     * 删除文件前校验
     */
    private ReturnResponse<Object> deleteFileCheck(HttpServletRequest request, String fileName, String password) {
        if (ObjectUtils.isEmpty(fileName)) {
            return ReturnResponse.failure("文件名为空，删除失败！");
        }
        try {
            fileName = WebUtils.decodeUrl(fileName, "base64");
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, fileName);
            return ReturnResponse.failure(errorMsg + "删除失败！");
        }

        if (ObjectUtils.isEmpty(fileName)) {
            return ReturnResponse.failure("文件名为空，删除失败！");
        }
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return ReturnResponse.failure("非法文件名，删除失败！");
        }

        if (ObjectUtils.isEmpty(password)) {
            return ReturnResponse.failure("密码 or 验证码为空，删除失败！");
        }

        boolean captchaEnabled = ConfigConstants.getDeleteCaptcha();
        String expectedPassword = captchaEnabled ?
                WebUtils.getSessionAttr(request, CAPTCHA_CODE) :
                ConfigConstants.getPassword();

        if (!captchaEnabled && (!StringUtils.hasText(expectedPassword)
                || "false".equalsIgnoreCase(expectedPassword))) {
            return ReturnResponse.failure("文件删除接口已禁用，请先配置 delete.password");
        }

        if (!StringUtils.hasText(expectedPassword)) {
            return ReturnResponse.failure("验证码已失效，请刷新后重试！");
        }

        if (!MessageDigest.isEqual(password.getBytes(StandardCharsets.UTF_8),
                expectedPassword.getBytes(StandardCharsets.UTF_8))) {
            logger.error("删除文件【{}】失败，密码错误！", fileName);
            return ReturnResponse.failure("删除文件失败，密码错误！");
        }

        return ReturnResponse.success(fileName);
    }

    @GetMapping("/directory")
    public Object directory(String urls) {
        String fileUrl;
        try {
            fileUrl = WebUtils.decodeUrl(urls,"base64");
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "url");
            return ReturnResponse.failure(errorMsg);
        }
        fileUrl = fileUrl.replaceAll("http://", "");
        if (KkFileUtils.isIllegalFileName(fileUrl)) {
            return ReturnResponse.failure("不允许访问的路径:");
        }
        return RarUtils.getTree(fileUrl);
    }

    private boolean existsFile(String fileName, String path) {
        String fullPath = fileDir + demoPath;
        if (!ObjectUtils.isEmpty(path)) {
            fullPath += path + File.separator;
        }
        File file = new File(fullPath + fileName);
        return file.exists();
    }
}
