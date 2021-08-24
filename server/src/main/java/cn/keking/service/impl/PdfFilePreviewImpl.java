package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;
import java.util.stream.Collectors;

import static cn.keking.service.impl.OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_ALL_IMAGES;
import static cn.keking.service.impl.OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE;

/**
 * Created by kl on 2018/1/17.
 * Content :处理pdf文件
 */
@Service
public class PdfFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    private final DownloadService downloadService;

    public PdfFilePreviewImpl(
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
        String fileName = fileAttribute.getName();
        String officePreviewType = fileAttribute.getOfficePreviewType();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + "pdf";

        if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType)) {
            //当文件不存在时，就去下载
            ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }
            String savePath = response.getContent().getSavePath();
            if (ConfigConstants.isCacheEnabled()) {
                fileHandlerService.addConvertedFile(pdfName, fileHandlerService.getRelativePath(savePath));
            }

            // 执行格式转换，并将转换结果的图片文件列表转为浏览器可访问的路径
            List<String> imageUrls = fileHandlerService
                    .pdf2jpg(savePath)
                    .stream()
                    .map(path -> baseUrl + fileHandlerService.getRelativePath(path))
                    .collect(Collectors.toList());

            if (imageUrls.size() < 1) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, "pdf转图片异常，请联系管理员");
            }

            model.addAttribute("imgurls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.get(0));
            if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
                return OFFICE_PICTURE_FILE_PREVIEW_PAGE;
            } else {
                return PICTURE_FILE_PREVIEW_PAGE;
            }

        } else {
            // 不是http开头，浏览器不能直接访问，需下载到本地
            if (url != null && !url.toLowerCase().startsWith("http")) {
                if (!fileHandlerService.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                    ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
                    if (response.isFailure()) {
                        return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                    }

                    String savePath = response.getContent().getSavePath();
                    model.addAttribute("pdfUrl", fileHandlerService.getRelativePath(savePath));

                    if (ConfigConstants.isCacheEnabled()) {
                        fileHandlerService.addConvertedFile(pdfName, fileHandlerService.getRelativePath(savePath));
                    }
                } else {
                    model.addAttribute("pdfUrl", pdfName);
                }
            } else {
                model.addAttribute("pdfUrl", url);
            }
        }
        return PDF_FILE_PREVIEW_PAGE;
    }
}
