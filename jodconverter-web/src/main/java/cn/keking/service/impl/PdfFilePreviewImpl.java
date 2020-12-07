package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileUtils;
import cn.keking.utils.PdfUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :处理pdf文件
 */
@Service
public class PdfFilePreviewImpl implements FilePreview {

    private final Logger logger = LoggerFactory.getLogger(PdfFilePreviewImpl.class);

    private final FileUtils fileUtils;

    private final PdfUtils pdfUtils;

    private final DownloadUtils downloadUtils;

    private static final String FILE_DIR = ConfigConstants.getFileDir();

    public PdfFilePreviewImpl(FileUtils fileUtils,
                              PdfUtils pdfUtils,
                              DownloadUtils downloadUtils) {
        this.fileUtils = fileUtils;
        this.pdfUtils = pdfUtils;
        this.downloadUtils = downloadUtils;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String suffix=fileAttribute.getSuffix();
        String fileName=fileAttribute.getName();
        String officePreviewType = model.asMap().get("officePreviewType") == null ? ConfigConstants.getOfficePreviewType() : model.asMap().get("officePreviewType").toString();
        //是pdf地址是否允许跨域
        String disabledCors = model.asMap().get("cors") == null ? "": model.asMap().get("cors").toString();
        Boolean isDisabledCors = disabledCors.equals("disabled") ? true:false;
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + "pdf";
        String outFilePath = FILE_DIR + pdfName;
        if (OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType) || isDisabledCors) {
            //当文件不存在时，就去下载
            if (!fileUtils.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, fileName);
                if (0 != response.getCode()) {
                    model.addAttribute("fileType", suffix);
                    model.addAttribute("msg", response.getMsg());
                    return "fileNotSupported";
                }
                outFilePath = response.getContent();
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileUtils.addConvertedFile(pdfName, fileUtils.getRelativePath(outFilePath));
                }
            }

            //pdf预览会存在跨域问题，如果禁止跨域，下载后返回pdf
            if (isDisabledCors && OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_PDF.equals(officePreviewType)) {
                model.addAttribute("pdfUrl", pdfName);
                return "pdf";
            }

            List<String> imageUrls = pdfUtils.pdf2jpg(outFilePath, pdfName, baseUrl);
            if (imageUrls == null || imageUrls.size() < 1) {
                model.addAttribute("msg", "pdf转图片异常，请联系管理员");
                model.addAttribute("fileType",fileAttribute.getSuffix());
                return "fileNotSupported";
            }
            model.addAttribute("imgurls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.get(0));
            if (OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
                return "officePicture";
            } else {
                return "picture";
            }
        } else {
            // 不是http开头，浏览器不能直接访问，需下载到本地
            if (url != null && !url.toLowerCase().startsWith("http")) {
                if (!fileUtils.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                    ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, pdfName);
                    if (0 != response.getCode()) {
                        model.addAttribute("fileType", suffix);
                        model.addAttribute("msg", response.getMsg());
                        return "fileNotSupported";
                    }
                    model.addAttribute("pdfUrl", fileUtils.getRelativePath(response.getContent()));
                    if (ConfigConstants.isCacheEnabled()) {
                        // 加入缓存
                        fileUtils.addConvertedFile(pdfName, fileUtils.getRelativePath(outFilePath));
                    }
                } else {
                    model.addAttribute("pdfUrl", pdfName);
                }
            } else {
                model.addAttribute("pdfUrl", url);
            }
        }
        return "pdf";
    }
}
