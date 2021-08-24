package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FilePreview;
import cn.keking.service.FileHandlerService;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import static cn.keking.service.impl.OfficeFilePreviewImpl.getPreviewType;
import static cn.keking.utils.KkFileUtils.changeExtension;

/**
 * @author chenjh
 * @since 2019/11/21 14:28
 */
@Service
public class CadFilePreviewImpl implements FilePreview {

    private static final String OFFICE_PREVIEW_TYPE_IMAGE = "image";
    private static final String OFFICE_PREVIEW_TYPE_ALL_IMAGES = "allImages";
    private static final String FILE_DIR = ConfigConstants.getFileDir();

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    private final DownloadService downloadService;

    public CadFilePreviewImpl(
            FileHandlerService fileHandlerService,
            OtherFilePreviewImpl otherFilePreview,
            DownloadService downloadService
    ) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
        this.downloadService = downloadService;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        // 预览Type，参数传了就取参数的，没传取系统默认
        String officePreviewType = fileAttribute.getOfficePreviewType() == null ? ConfigConstants.getOfficePreviewType() : fileAttribute.getOfficePreviewType();
        String fileName = fileAttribute.getName();
        String convertedFileKey = changeExtension(fileName, ".pdf");

        String baseUrl = BaseUrlFilter.getBaseUrl();
        String originalPath;
        String convertedFilePath;

        // 判断之前是否已转换过，如果转换过，直接返回，否则执行转换
        if (!fileHandlerService.listConvertedFiles().containsKey(convertedFileKey) || !ConfigConstants.isCacheEnabled()) {
            ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }
            originalPath = response.getContent().getSavePath();
            convertedFilePath = changeExtension(originalPath, ".pdf");
            if (StringUtils.hasText(originalPath)) {
                boolean convertResult = fileHandlerService.cadToPdf(originalPath, convertedFilePath);
                if (!convertResult) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, "cad文件转换异常，请联系管理员");
                }
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileHandlerService.addConvertedFile(convertedFileKey, convertedFilePath);
                }
            }
        } else {
            convertedFilePath = fileHandlerService.listConvertedFiles().get(convertedFileKey);
        }

        if (baseUrl != null && (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType))) {
            return getPreviewType(model, fileAttribute, officePreviewType, baseUrl, convertedFilePath, fileHandlerService, OFFICE_PREVIEW_TYPE_IMAGE,otherFilePreview);
        } else {
            model.addAttribute("pdfUrl", fileHandlerService.getRelativePath(convertedFilePath).replace("\\", "/"));
            return PDF_FILE_PREVIEW_PAGE;
        }
    }
}
