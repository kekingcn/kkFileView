package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FilePreviewCommonService;
import cn.keking.service.OfficeToPdfService;
import cn.keking.utils.PdfUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :处理office文件
 */
@Service
public class OfficeFilePreviewImpl implements FilePreview {

    private final FilePreviewCommonService filePreviewCommonService;
    private final PdfUtils pdfUtils;
    private final DownloadUtils downloadUtils;
    private final OfficeToPdfService officeToPdfService;

    public OfficeFilePreviewImpl(FilePreviewCommonService filePreviewCommonService, PdfUtils pdfUtils, DownloadUtils downloadUtils, OfficeToPdfService officeToPdfService) {
        this.filePreviewCommonService = filePreviewCommonService;
        this.pdfUtils = pdfUtils;
        this.downloadUtils = downloadUtils;
        this.officeToPdfService = officeToPdfService;
    }

    public static final String OFFICE_PREVIEW_TYPE_IMAGE = "image";
    public static final String OFFICE_PREVIEW_TYPE_ALL_IMAGES = "allImages";
    private static final String FILE_DIR = ConfigConstants.getFileDir();

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        // 预览Type，参数传了就取参数的，没传取系统默认
        String officePreviewType = fileAttribute.getOfficePreviewType();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String suffix=fileAttribute.getSuffix();
        String fileName=fileAttribute.getName();
        boolean isHtml = suffix.equalsIgnoreCase("xls") || suffix.equalsIgnoreCase("xlsx");
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + (isHtml ? "html" : "pdf");
        String outFilePath = FILE_DIR + pdfName;
        // 判断之前是否已转换过，如果转换过，直接返回，否则执行转换
        if (!filePreviewCommonService.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
            String filePath;
            ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, null);
            if (0 != response.getCode()) {
                model.addAttribute("fileType", suffix);
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            }
            filePath = response.getContent();
            if (StringUtils.hasText(outFilePath)) {
                officeToPdfService.openOfficeToPDF(filePath, outFilePath);
                if (isHtml) {
                    // 对转换后的文件进行操作(改变编码方式)
                    filePreviewCommonService.doActionConvertedFile(outFilePath);
                }
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    filePreviewCommonService.addConvertedFile(pdfName, filePreviewCommonService.getRelativePath(outFilePath));
                }
            }
        }
        if (!isHtml && baseUrl != null && (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType))) {
            return getPreviewType(model, fileAttribute, officePreviewType, baseUrl, pdfName, outFilePath, pdfUtils, OFFICE_PREVIEW_TYPE_IMAGE);
        }
        model.addAttribute("pdfUrl", pdfName);
        return isHtml ? "html" : "pdf";
    }

    static String getPreviewType(Model model, FileAttribute fileAttribute, String officePreviewType, String baseUrl, String pdfName, String outFilePath, PdfUtils pdfUtils, String officePreviewTypeImage) {
        List<String> imageUrls = pdfUtils.pdf2jpg(outFilePath, pdfName, baseUrl);
        if (imageUrls == null || imageUrls.size() < 1) {
            model.addAttribute("msg", "office转图片异常，请联系管理员");
            model.addAttribute("fileType",fileAttribute.getSuffix());
            return "fileNotSupported";
        }
        model.addAttribute("imgurls", imageUrls);
        model.addAttribute("currentUrl", imageUrls.get(0));
        if (officePreviewTypeImage.equals(officePreviewType)) {
            return "officePicture";
        } else {
            return "picture";
        }
    }
}
