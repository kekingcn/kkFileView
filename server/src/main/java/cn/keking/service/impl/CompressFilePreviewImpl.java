package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.CompressFileReader;
import cn.keking.service.DownloadService;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.compress.ArchiveResult;
import cn.keking.service.compress.ZipProcessor;
import cn.keking.utils.Jackson;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :处理压缩包文件
 */
@Service
public class CompressFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final CompressFileReader compressFileReader;
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
        String extract(String archivePath, String archiveCacheKey);
    }

    public CompressFilePreviewImpl(
            FileHandlerService fileHandlerService,
            CompressFileReader compressFileReader,
            OtherFilePreviewImpl otherFilePreview,
            DownloadService downloadService
    ) {
        this.fileHandlerService = fileHandlerService;
        this.compressFileReader = compressFileReader;
        this.otherFilePreview = otherFilePreview;
        this.downloadService = downloadService;
    }

    @PostConstruct
    private void init() {
        extractors.put("zip", this::readZipFile);
        extractors.put("jar", compressFileReader::readZipFile);
        extractors.put("gzip", compressFileReader::readZipFile);
        extractors.put("rar", compressFileReader::unRar);
        extractors.put("7z", compressFileReader::read7zFile);
    }

    private String readZipFile(String filePath, String fileKey) {

        ReturnResponse<ArchiveResult> response =
            new ZipProcessor(filePath, fileHandlerService).process();

        if (response.isFailure()) {
            return null;
        } else {
            return Jackson.toJsonString(response.getContent().getTree());
        }
    }

    private String handleDefault(String savePath, String convertedKey) {
        return null;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String convertedKey = fileAttribute.getName();
        String suffix = fileAttribute.getSuffix();
        String entryTreeJson;

        // 判断文件名是否存在(redis缓存读取)
        if (!StringUtils.hasText(fileHandlerService.getConvertedFile(convertedKey)) || !ConfigConstants.isCacheEnabled()) {

            ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }

            String savePath = response.getContent().getSavePath();
            Extractor extractor = extractors.getOrDefault(suffix, this::handleDefault);
            entryTreeJson = extractor.extract(savePath, convertedKey);

        } else {
            entryTreeJson = fileHandlerService.getConvertedFile(convertedKey);
        }

        if (entryTreeJson != null && !"null".equals(entryTreeJson)) {
            model.addAttribute("fileTree", entryTreeJson);
            return COMPRESS_FILE_PREVIEW_PAGE;
        } else {
            return otherFilePreview.notSupportedFile(model, fileAttribute, "压缩文件类型不受支持，尝试在压缩的时候选择RAR4格式");
        }
    }
}
