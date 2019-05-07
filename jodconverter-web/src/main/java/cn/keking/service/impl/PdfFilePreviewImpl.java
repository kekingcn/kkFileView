package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileUtils;
import cn.keking.utils.PdfUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.io.File;
import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :处理pdf文件
 */
@Service
public class PdfFilePreviewImpl implements FilePreview{


    @Autowired
    FileUtils fileUtils;

    @Autowired
    PdfUtils pdfUtils;

    @Autowired
    DownloadUtils downloadUtils;

    String fileDir = ConfigConstants.getFileDir();

    @Override
    public String filePreviewHandle(String url, Model model) {
        FileAttribute fileAttribute=fileUtils.getFileAttribute(url);
        String decodedUrl=fileAttribute.getDecodedUrl();
        String suffix=fileAttribute.getSuffix();
        String fileName=fileAttribute.getName();
        String officePreviewType = model.asMap().get("officePreviewType") == null ? "" : model.asMap().get("officePreviewType").toString();
        String originUrl = model.asMap().get("originUrl").toString();
        model.addAttribute("pdfUrl", url);
        String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + "pdf";
        String outFilePath = fileDir + pdfName;
        if (OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_ALLIMAGES.equals(officePreviewType)) {
            //当文件不存在时，就去下载
            if (!new File(outFilePath).exists()) {
                ReturnResponse<String> response = downloadUtils.downLoad(decodedUrl, suffix, fileName);
                if (0 != response.getCode()) {
                    model.addAttribute("fileType", suffix);
                    model.addAttribute("msg", response.getMsg());
                    return "fileNotSupported";
                }
                outFilePath = response.getContent();
            }
            List<String> imageUrls = pdfUtils.pdf2jpg(outFilePath, pdfName, originUrl);
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
        }
        return "pdf";
    }
}
