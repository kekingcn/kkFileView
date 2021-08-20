package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.compress.ArchiveResult;
import cn.keking.service.compress.RarProcessor;
import cn.keking.service.compress.SevenZipProcessor;
import cn.keking.service.compress.ZipProcessor;
import cn.keking.utils.Jackson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :处理压缩包文件
 */
@Service
public class CompressFilePreviewImpl implements FilePreview {

    private static final Logger log = LoggerFactory.getLogger(CompressFilePreviewImpl.class);

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    private final DownloadService downloadService;
    private final Map<String, Extractor> extractors = new HashMap<>();

    @FunctionalInterface
    private interface Extractor {

        /**
         * 解压压缩包，并将文件列表放入 {@link FileHandlerService#putImgCache(java.lang.String, java.util.List)}
         *
         * @param archivePath     压缩包路径
         * @param archiveCacheKey 缓存 key
         *
         * @return 解压出来的文件列表
         */
        ArchiveResult extract(String archivePath, String archiveCacheKey) throws IOException;
    }

    public CompressFilePreviewImpl(
        FileHandlerService fileHandlerService,
        OtherFilePreviewImpl otherFilePreview,
        DownloadService downloadService
    ) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
        this.downloadService = downloadService;
    }

    @PostConstruct
    private void init() {
        extractors.put("zip", this::readZipFile);
        extractors.put("jar", this::readZipFile);
        extractors.put("gzip", this::readZipFile);
        extractors.put("rar", this::readRarFile);
        extractors.put("7z", this::read7zFile);
    }

    private ArchiveResult read7zFile(String filePath, String fileKey) throws IOException {
        return new SevenZipProcessor(filePath, fileHandlerService).process();
    }

    private ArchiveResult readRarFile(String filePath, String fileKey) throws IOException {
        return new RarProcessor(filePath, fileHandlerService).process();
    }

    private ArchiveResult readZipFile(String filePath, String fileKey) throws IOException {
        return new ZipProcessor(filePath, fileHandlerService).process();
    }

    // 默认处理方法
    private ArchiveResult handleDefault(String savePath, String convertedKey) {
        return null;
    }

    ///////////////////////////////////////////////////////////////////

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String convertedKey = fileAttribute.getName();
        String suffix = fileAttribute.getSuffix();
        String entryTreeJson = null;
        List<String> imgUrls = new ArrayList<>();

        try {
            // 判断文件名是否存在(redis缓存读取)
            String convertedFile = fileHandlerService.getConvertedFile(convertedKey);
            if (!StringUtils.hasText(convertedFile) || !ConfigConstants.isCacheEnabled()) {
                ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }

                String savePath = response.getContent().getSavePath();
                Extractor extractor = extractors.getOrDefault(suffix, this::handleDefault);
                ArchiveResult result = extractor.extract(savePath, convertedKey);
                if (result != null) {
                    entryTreeJson = Jackson.toJsonString(result.getTree());
                    imgUrls = result.getImageUrls();
                }
            } else {
                entryTreeJson = convertedFile;
            }
        } catch (Exception e) {
            log.error("打开压缩文件失败", e);
            return otherFilePreview.notSupportedFile(
                model, fileAttribute, e.getMessage() == null ? e.toString() : e.getMessage()
            );
        }

        if (entryTreeJson != null && !"null".equals(entryTreeJson)) {
            model.addAttribute("fileTree", entryTreeJson);
            model.addAttribute("imgUrls", imgUrls);
            return COMPRESS_FILE_PREVIEW_PAGE;
        } else {
            return otherFilePreview.notSupportedFile(model, fileAttribute, "压缩文件类型不受支持，尝试在压缩的时候选择RAR4格式");
        }
    }
}
