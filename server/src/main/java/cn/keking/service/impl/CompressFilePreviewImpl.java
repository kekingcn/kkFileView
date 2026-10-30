package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FileHandlerService;
import cn.keking.service.CompressFileReader;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.RarUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.EncryptedDocumentException;
import org.slf4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.util.concurrent.TimeUnit;

/**
 * Created by kl on 2018/1/17.
 * Content :处理压缩包文件
 */
@Service
public class CompressFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final CompressFileReader compressFileReader;
    private final OtherFilePreviewImpl otherFilePreview;
    private static final String Rar_PASSWORD_MSG = "password";
    private static final long COMPRESS_LOCK_WAIT_SECONDS = 50L;
    private static final Logger logger = org.slf4j.LoggerFactory.getLogger(CompressFileReader.class);


    public CompressFilePreviewImpl(FileHandlerService fileHandlerService, CompressFileReader compressFileReader, OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.compressFileReader = compressFileReader;
        this.otherFilePreview = otherFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String filePassword = fileAttribute.getFilePassword();
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        String fileTree;
        if (cacheReady(fileName, forceUpdatedCache)) {
            fileTree = fileHandlerService.getConvertedFile(fileName);
        } else if (!fileHandlerService.tryCompressLock(fileName, COMPRESS_LOCK_WAIT_SECONDS, TimeUnit.SECONDS)) {
            logger.info("压缩包等锁超时，fileName:{}", fileName);
            return otherFilePreview.notSupportedFile(model, fileAttribute, "压缩包正在解压，请稍后重新打开");
        } else {
            try {
                if (cacheReady(fileName, forceUpdatedCache)) {
                    fileTree = fileHandlerService.getConvertedFile(fileName);
                } else {
                    ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                    if (response.isFailure()) {
                        return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                    }
                    String filePath = response.getContent();
                    fileTree = null;
                    try {
                        fileTree = compressFileReader.unRar(filePath, filePassword, fileName, fileAttribute);
                    } catch (Exception e) {
                        if (e.getMessage() != null && e.getMessage().toLowerCase().contains(Rar_PASSWORD_MSG)) {
                            model.addAttribute("needFilePassword", true);
                            return EXEL_FILE_PREVIEW_PAGE;
                        } else {
                            logger.error("Error processing RAR file: " + e.getMessage(), e);
                        }
                    }
                    if (ObjectUtils.isEmpty(fileTree)) {
                        return otherFilePreview.notSupportedFile(model, fileAttribute, "该压缩包文件无法处理!");
                    }
                    if (!fileAttribute.isCompressFile() && ConfigConstants.getDeleteSourceFile()) {
                        KkFileUtils.deleteFileByPath(filePath);
                    }
                    if (ConfigConstants.isCacheEnabled()) {
                        fileHandlerService.addConvertedFile(fileName, fileTree);
                    }
                }
            } finally {
                fileHandlerService.unlockCompress(fileName);
            }
        }
        model.addAttribute("fileName", fileName);
        model.addAttribute("fileTree", fileTree);
        try {
            model.addAttribute("archiveTreeJson", new ObjectMapper().writeValueAsString(RarUtils.getTree(fileTree)));
        } catch (IOException | SecurityException e) {
            logger.warn("Unable to read the previewed archive directory", e);
            return otherFilePreview.notSupportedFile(model, fileAttribute, "该压缩包目录无法读取!");
        }
        return COMPRESS_FILE_PREVIEW_PAGE;
    }

    private boolean cacheReady(String fileName, boolean forceUpdatedCache) {
        return !forceUpdatedCache
                && ConfigConstants.isCacheEnabled()
                && StringUtils.hasText(fileHandlerService.getConvertedFile(fileName));
    }
}
