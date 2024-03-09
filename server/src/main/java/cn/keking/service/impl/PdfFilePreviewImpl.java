package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.WebUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.EncryptedDocumentException;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.io.IOException;
import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :处理pdf文件
 */
@Service
public class PdfFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    private static final String PDF_PASSWORD_MSG = "password";
    public PdfFilePreviewImpl(FileHandlerService fileHandlerService, OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
    }
    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String pdfName = fileAttribute.getName();  //获取原始文件名
        String officePreviewType = fileAttribute.getOfficePreviewType(); //转换类型
        boolean forceUpdatedCache=fileAttribute.forceUpdatedCache();  //是否启用强制更新命令
        String outFilePath = fileAttribute.getOutFilePath();  //生成的文件路径
        String originFilePath = fileAttribute.getOriginFilePath();  //原始文件路径
        if (OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType)) {
            //当文件不存在时，就去下载
            if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, pdfName);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }
                originFilePath = response.getContent();
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileHandlerService.addConvertedFile(pdfName, fileHandlerService.getRelativePath(originFilePath));
                }
            }
            List<String> imageUrls;
            try {
                imageUrls = fileHandlerService.pdf2jpg(originFilePath,outFilePath, pdfName, fileAttribute);
            } catch (Exception e) {
                Throwable[] throwableArray = ExceptionUtils.getThrowables(e);
                for (Throwable throwable : throwableArray) {
                    if (throwable instanceof IOException || throwable instanceof EncryptedDocumentException) {
                        if (e.getMessage().toLowerCase().contains(PDF_PASSWORD_MSG)) {
                            model.addAttribute("needFilePassword", true);
                            return EXEL_FILE_PREVIEW_PAGE;
                        }
                    }
                }
                return otherFilePreview.notSupportedFile(model, fileAttribute, "pdf转图片异常，请联系管理员");
            }
            if (imageUrls == null || imageUrls.size() < 1) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, "pdf转图片异常，请联系管理员");
            }
            model.addAttribute("imgUrls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.get(0));
            if (OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
                return OFFICE_PICTURE_FILE_PREVIEW_PAGE;
            } else {
                return PICTURE_FILE_PREVIEW_PAGE;
            }
        } else {
            // 不是http开头，浏览器不能直接访问，需下载到本地
            if (url != null && !url.toLowerCase().startsWith("http")) {
                if (!fileHandlerService.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                    ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, pdfName);
                    if (response.isFailure()) {
                        return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                    }
                    model.addAttribute("pdfUrl", fileHandlerService.getRelativePath(response.getContent()));
                    if (ConfigConstants.isCacheEnabled()) {
                        // 加入缓存
                        fileHandlerService.addConvertedFile(pdfName, fileHandlerService.getRelativePath(outFilePath));
                    }
                } else {
                    model.addAttribute("pdfUrl", WebUtils.encodeFileName(pdfName));
                }
            } else {
                model.addAttribute("pdfUrl", url);
            }
        }
        return PDF_FILE_PREVIEW_PAGE;
    }
}
