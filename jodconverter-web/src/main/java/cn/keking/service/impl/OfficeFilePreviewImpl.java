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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import java.io.File;
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

    @Override
    public String filePreviewHandle(String url, Model model) {
        // 预览Type，参数传了就取参数的，没传取系统默认
        String officePreviewType = model.asMap().get("officePreviewType") == null ? ConfigConstants.getOfficePreviewType() : model.asMap().get("officePreviewType").toString();
        FileAttribute fileAttribute=fileUtils.getFileAttribute(url);
        String suffix=fileAttribute.getSuffix();
        String fileName=fileAttribute.getName();
        String decodedUrl=fileAttribute.getDecodedUrl();
        boolean isHtml = suffix.equalsIgnoreCase("xls") || suffix.equalsIgnoreCase("xlsx");
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + (isHtml ? "html" : "pdf");
        String outFilePath = fileDir + pdfName;
        // 判断之前是否已转换过，如果转换过，直接返回，否则执行转换
        if (!fileUtils.listConvertedFiles().containsKey(pdfName)) {
            String filePath = fileDir + fileName;
            if (!new File(filePath).exists()) {
                ReturnResponse<String> response = downloadUtils.downLoad(decodedUrl, suffix, null);
                if (0 != response.getCode()) {
                    model.addAttribute("msg", response.getMsg());
                    return "fileNotSupported";
                }
                filePath = response.getContent();
            }
            if (StringUtils.hasText(outFilePath)) {
                officeToPdf.openOfficeToPDF(filePath, outFilePath);
                File f = new File(filePath);
                if (f.exists()) {
                    f.delete();
                }
                if (isHtml) {
                    // 对转换后的文件进行操作(改变编码方式)
                    fileUtils.doActionConvertedFile(outFilePath);
                }
                // 加入缓存
                fileUtils.addConvertedFile(pdfName, fileUtils.getRelativePath(outFilePath));
            }
        }
        if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
            List<String> imageUrls = pdfUtils.pdf2jpg(outFilePath, pdfName, url);
            if (imageUrls == null || imageUrls.size() < 1) {
                model.addAttribute("msg", "office转图片异常，请联系管理员");
                model.addAttribute("fileType",fileAttribute.getSuffix());
                return "fileNotSupported";
            }
            model.addAttribute("imgurls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.get(0));
            return "officePicture";
        }
        model.addAttribute("pdfUrl", pdfName);
        return isHtml ? "html" : "pdf";
    }
}
