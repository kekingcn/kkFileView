package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.MD5;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 将 {@link cn.keking.utils.DownloadUtils} 重新实现为 DownloadService 是为了解决两个问题：
 * <ol>
 *     <li>缓存问题，下载服务应该能够利用 ETag 等机制判断已缓存的文件是否可以跳过下载</li>
 *     <li>因为没有区分域名，会导致不同域名下的同名文件相互覆盖。这里先实现将域名纳入缓存key，实际上需要更加细致的判断，比如是否要将参数纳入缓存key。</li>
 * </ol>
 * 直接将缓存 key 作为文件名不合适，因为考虑到缓存 key 可能会比较长。合适的做法是将 key 转为 md5。
 */
@Service
public class DownloadService {

    private static final Logger log = LoggerFactory.getLogger(DownloadService.class);

    // 这是一个配置项。之所以不使用静态成员，是为了给运行时修改配置留出余地。
    private String fileDir = ConfigConstants.getFileDir();

    /**
     * 下载文件，已经缓存的文件将跳过实际下载，返回之前下载的结果。
     * TODO: 多线程并发下载同一个文件，应进行同步，保证只下载一次
     *
     * @param fileAttribute 文件信息
     *
     * @return 下载结果
     */
    public ReturnResponse<DownloadResult> downloadFile(FileAttribute fileAttribute) {
        try {
            URL url = new URL(fileAttribute.getUrl());
            String etag = getEtag(url);
            String cacheKey = generateCacheKey(url, etag);
            String savePath = generateSavePath(cacheKey, fileAttribute);

            // etag 为空表示不可缓存，此时直接下载并覆盖原来的文件；
            // etag 不为空则表示可缓存，此时只要有文件在就取该文件作为下载结果。

            if (etag == null || !alreadyCached(savePath)) {
                log.info("文件没有缓存，需要下载 url={} savePath={}", url, savePath);
                downloadAndSave(url, savePath);
            } else {
                log.info("文件已经下载过，不再重复下载 url={} savePath={}", url, savePath);
            }

            return ReturnResponse.success(new DownloadResult(savePath));

        } catch (Exception e) {
            log.error("Error downloading file {}", fileAttribute, e);
            return ReturnResponse.failure(e.getMessage());
        }
    }

    /**
     * 判断文件是否已经被缓存。这里只简单的判断文件是否已经存在
     */
    private boolean alreadyCached(String savePath) {
        return Files.exists(Paths.get(savePath));
    }

    /**
     * 执行实际的下载并保存到指定位置
     *
     * @param url      要下载的文件地址
     * @param savePath 要保存到的位置
     */
    private void downloadAndSave(URL url, String savePath) throws IOException {
        Path path = Paths.get(savePath);
        Files.createDirectories(path.getParent());
        try (OutputStream fos = Files.newOutputStream(path)) {
            IOUtils.copy(url.openStream(), fos);
        }
    }

    /**
     * 生成下载路径，格式为 [fileDir]/[md5(0:2)]/[md5(2:4)]/[md5].[suffix]
     */
    private String generateSavePath(String cacheKey, FileAttribute fileAttribute) {
        String md5 = MD5.generateMd5(cacheKey);
        return joinPath(
                fileDir, md5.substring(0, 2), md5.substring(2, 4), md5 + "." + fileAttribute.getSuffix()
        );
    }

    /**
     * 将路径的多个部分合并成一个完整的文件系统路径
     */
    private static String joinPath(String... paths) {

        // 去掉空元素，对第一个元素去掉末尾的 '/' 字符，其他元素去掉头尾的 '/' 字符
        List<String> fixedPaths = new ArrayList<>(paths.length);
        for (int i = 0; i < paths.length; i++) {
            String path = paths[i];
            if (StringUtils.isNotBlank(path)) {
                if (i == 0) {
                    fixedPaths.add(StringUtils.removeEnd(path, "/"));
                } else {
                    fixedPaths.add(StringUtils.removeStart(StringUtils.removeEnd(path, "/"), "/"));
                }
            }
        }

        return String.join(File.separator, fixedPaths);
    }

    /**
     * 生成缓存 key
     */
    private String generateCacheKey(URL url, String etag) {
        return String.join(";",
                url.getHost(), String.valueOf(url.getPort()), FilenameUtils.getName(url.getPath()), etag
        );
    }

    /**
     * 获取指定地址的 ETag，如果没有则返回 null
     */
    private String getEtag(URL url) throws IOException {
        String etag = null;

        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
        urlConnection.setRequestMethod("HEAD");

        Map<String, List<String>> headers = urlConnection.getHeaderFields();
        if (headers.containsKey("ETag")) {
            etag = headers.get("ETag").get(0);
        }
        return etag;
    }
}
