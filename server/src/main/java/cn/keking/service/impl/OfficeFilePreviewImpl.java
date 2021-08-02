package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.OfficeToPdfService;
import cn.keking.web.filter.BaseUrlFilter;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

import static cn.keking.utils.KkFileUtils.changeExtension;
import static org.apache.commons.lang3.StringUtils.*;

/**
 * Created by kl on 2018/1/17.
 * Content :处理office文件
 */
@Service
public class OfficeFilePreviewImpl implements FilePreview {

    public static final String OFFICE_PREVIEW_TYPE_IMAGE = "image";

    public static final String OFFICE_PREVIEW_TYPE_ALL_IMAGES = "allImages";

    private final FileHandlerService fileHandlerService;

    private final OfficeToPdfService officeToPdfService;

    private final OtherFilePreviewImpl otherFilePreview;

    private final DownloadService downloadService;

    private final Map<String, BiFunction<Model, FileAttribute, String>> handlerMappings = new HashMap<>();

    {
        handlerMappings.put("xls", this::handleSpreadSheet);
        handlerMappings.put("xlsx", this::handleSpreadSheet);
    }

    public OfficeFilePreviewImpl(
            FileHandlerService fileHandlerService, OfficeToPdfService officeToPdfService,
            OtherFilePreviewImpl otherFilePreview, DownloadService downloadService
    ) {
        this.fileHandlerService = fileHandlerService;
        this.officeToPdfService = officeToPdfService;
        this.otherFilePreview = otherFilePreview;
        this.downloadService = downloadService;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {

        // Office 文件有多种类型，需要不同的流程来处理
        BiFunction<Model, FileAttribute, String>
                handler = handlerMappings.getOrDefault(fileAttribute.getSuffix(), this::handleDefault);

        return handler.apply(model, fileAttribute);
    }

    // 将中间格式的文件转换为图片
    static String getPreviewType(
            Model model, FileAttribute fileAttribute, String officePreviewType, String baseUrl,
            String outFilePath, FileHandlerService fileHandlerService, String officePreviewTypeImage,
            OtherFilePreviewImpl otherFilePreview) {

        String suffix = fileAttribute.getSuffix();
        boolean isPPT = suffix.equalsIgnoreCase("ppt") || suffix.equalsIgnoreCase("pptx");

        // 执行格式转换，并将转换结果的图片文件列表转为浏览器可访问的路径
        List<String> imageUrls = fileHandlerService
                .pdf2jpg(outFilePath)
                .stream()
                .map(path -> path.replace("\\", "/"))
                .map(path -> appendIfMissing(baseUrl, "/") + removeStart(fileHandlerService.getRelativePath(path), "/"))
                .collect(Collectors.toList());

        if (CollectionUtils.isEmpty(imageUrls)) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, "office转图片异常，请联系管理员");
        }
        model.addAttribute("imgurls", imageUrls);
        model.addAttribute("currentUrl", imageUrls.get(0));
        if (officePreviewTypeImage.equals(officePreviewType)) {
            // PPT 图片模式使用专用预览页面
            return (isPPT ? PPT_FILE_PREVIEW_PAGE : OFFICE_PICTURE_FILE_PREVIEW_PAGE);
        } else {
            return PICTURE_FILE_PREVIEW_PAGE;
        }
    }

    ///////////////////////////////////////////////////////////////////

    // 是否要以图片方式预览
    private boolean isImagePreview(FileAttribute fileAttribute) {
        String type = fileAttribute.getOfficePreviewType();
        return Objects.equals(OFFICE_PREVIEW_TYPE_IMAGE, type) ||
                Objects.equals(OFFICE_PREVIEW_TYPE_ALL_IMAGES, type);
    }

    // 判断中间文件是否未缓存。如果没有启用缓存则返回 true
    private boolean isIntermediateFileNotCached(String intermediateFileName) {
        return !ConfigConstants.isCacheEnabled() ||
                !fileHandlerService.listConvertedFiles().containsKey(intermediateFileName);
    }

    // 当启用缓存时，将文件路径缓存到 ConvertedFile 下
    private void cacheIntermediateFileIfNeeded(String key, String filePath) {
        if (ConfigConstants.isCacheEnabled()) {
            fileHandlerService.addConvertedFile(key, filePath);
        }
    }

    // 将本地绝对路径转为浏览器可访问的相对路径
    private String toRelativeUrl(String absolutePath) {
        return fileHandlerService.getRelativePath(absolutePath).replace("\\", "/");
    }

    ///////////////////////////////////////////////////////////////////

    private String handleSpreadSheet(Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String intermediateKey = changeExtension(fileName, ".html");
        String intermediateFilePath;

        if (isIntermediateFileNotCached(intermediateKey)) {
            ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }

            String originFilePath = response.getContent().getSavePath();
            intermediateFilePath = changeExtension(originFilePath, ".html");

            officeToPdfService.openOfficeToPDF(originFilePath, intermediateFilePath);
            fileHandlerService.doActionConvertedFile(intermediateFilePath);
            cacheIntermediateFileIfNeeded(intermediateKey, intermediateFilePath);
        } else {
            intermediateFilePath = fileHandlerService.getConvertedFile(intermediateKey);
        }

        model.addAttribute("pdfUrl", toRelativeUrl(intermediateFilePath));
        return EXEL_FILE_PREVIEW_PAGE;
    }

    private String handleDefault(Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String intermediateKey = changeExtension(fileName, ".pdf");
        String intermediateFilePath;

        if (isIntermediateFileNotCached(intermediateKey)) {
            ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }

            String originFilePath = response.getContent().getSavePath();
            intermediateFilePath = changeExtension(originFilePath, ".pdf");
            officeToPdfService.openOfficeToPDF(originFilePath, intermediateFilePath);
            cacheIntermediateFileIfNeeded(intermediateKey, intermediateFilePath);
        } else {
            intermediateFilePath = fileHandlerService.getConvertedFile(intermediateKey);
        }

        if (isImagePreview(fileAttribute)) {
            return getPreviewType(
                    model, fileAttribute, fileAttribute.getOfficePreviewType(),
                    BaseUrlFilter.getBaseUrl(), intermediateFilePath, fileHandlerService,
                    OFFICE_PREVIEW_TYPE_IMAGE, otherFilePreview);
        } else {
            model.addAttribute("pdfUrl", toRelativeUrl(intermediateFilePath));
            return PDF_FILE_PREVIEW_PAGE;
        }
    }
}
