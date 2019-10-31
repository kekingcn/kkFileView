package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileUtils;
import cn.keking.utils.OfficeToPdf;
import cn.keking.utils.PdfUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :处理office文件
 */
@Service
public class OfficeFilePreviewImpl implements FilePreview {

    @Autowired
    FileUtils fileUtils;

    @Autowired
    PdfUtils pdfUtils;

    @Autowired
    DownloadUtils downloadUtils;

    @Autowired
    private OfficeToPdf officeToPdf;

    String fileDir = ConfigConstants.getFileDir();

    public static final String OFFICE_PREVIEW_TYPE_PDF = "pdf";
    public static final String OFFICE_PREVIEW_TYPE_IMAGE = "image";
    public static final String OFFICE_PREVIEW_TYPE_ALLIMAGES = "allImages";

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        // 预览Type，参数传了就取参数的，没传取系统默认
        String officePreviewType = model.asMap().get("officePreviewType") == null ? ConfigConstants.getOfficePreviewType() : model.asMap().get("officePreviewType").toString();
        String baseUrl = (String) RequestContextHolder.currentRequestAttributes().getAttribute("baseUrl",0);
        String suffix=fileAttribute.getSuffix();
        String fileName=fileAttribute.getName();
        boolean isHtml = suffix.equalsIgnoreCase("xls") || suffix.equalsIgnoreCase("xlsx");
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + (isHtml ? "html" : "pdf");
        String outFilePath = fileDir + pdfName;
        // 判断之前是否已转换过，如果转换过，直接返回，否则执行转换
        if (!fileUtils.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
            String filePath = fileDir + fileName;
            ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, null);
            if (0 != response.getCode()) {
                model.addAttribute("fileType", suffix);
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            }
            filePath = response.getContent();
            if (StringUtils.hasText(outFilePath)) {
                officeToPdf.openOfficeToPDF(filePath, outFilePath);
                if (isHtml) {
                    // 对转换后的文件进行操作(改变编码方式)
                    fileUtils.doActionConvertedFile(outFilePath);
                }
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileUtils.addConvertedFile(pdfName, fileUtils.getRelativePath(outFilePath));
                }
            }
        }
        if (!isHtml && baseUrl != null && (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OFFICE_PREVIEW_TYPE_ALLIMAGES.equals(officePreviewType))) {
            List<String> imageUrls = pdfUtils.pdf2jpg(outFilePath, pdfName, baseUrl);
            if (imageUrls == null || imageUrls.size() < 1) {
                model.addAttribute("msg", "office转图片异常，请联系管理员");
                model.addAttribute("fileType",fileAttribute.getSuffix());
                return "fileNotSupported";
            }
            model.addAttribute("imgurls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.get(0));
            if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
                return "officePicture";
            } else {
                return "picture";
            }
        }
        model.addAttribute("pdfUrl", pdfName);
        return isHtml ? "html" : "pdf";
    }
}
