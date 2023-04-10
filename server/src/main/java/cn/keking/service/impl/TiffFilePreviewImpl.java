package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.utils.ConvertPicUtil;
import cn.keking.utils.DownloadUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * tiff 图片文件处理
 *
 * @author kl (http://kailing.pub)
 * @since 2021/2/8
 */
@Service
public class TiffFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    public TiffFilePreviewImpl(FileHandlerService fileHandlerService,OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
    }
    private final String fileDir = ConfigConstants.getFileDir();
    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String tifPreviewType = ConfigConstants.getTifPreviewType();
        String tifOnLinePreviewType = fileAttribute.getTifPreviewType();
        if (StringUtils.hasText(tifOnLinePreviewType)) {
            tifPreviewType = tifOnLinePreviewType;
        }
        if ("tif".equalsIgnoreCase(tifPreviewType)) {
            model.addAttribute("currentUrl", url);
            return TIFF_FILE_PREVIEW_PAGE;
        } else if ("jpg".equalsIgnoreCase(tifPreviewType) || "pdf".equalsIgnoreCase(tifPreviewType)) {
            String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + "pdf";
            String jpgName = fileName.substring(0, fileName.lastIndexOf(".") + 1) + "jpg";
            String strLocalTif = fileDir + fileName;
            String outFilePath = fileDir + pdfName;
            if ("pdf".equalsIgnoreCase(tifPreviewType)) {
                    //当文件不存在时，就去下载
                    if (!fileHandlerService.listConvertedFiles().containsKey(pdfName) || !ConfigConstants.isCacheEnabled()) {
                        ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                        if (response.isFailure()) {
                            return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                        }
                        String filePath = response.getContent();
                        if (ConfigConstants.isCacheEnabled()) {
                            // 加入缓存
                            fileHandlerService.addConvertedFile(pdfName, fileHandlerService.getRelativePath(outFilePath));
                        }
                        if(ConvertPicUtil.convertJpg2Pdf(filePath, outFilePath)){
                            model.addAttribute("pdfUrl", pdfName);
                            return PDF_FILE_PREVIEW_PAGE;
                        }
                    }
                 else {
                    model.addAttribute("pdfUrl", pdfName);
                    return PDF_FILE_PREVIEW_PAGE;
                }

            } else {
                File fileTiff = new File(strLocalTif);
                // 如果本地不存在这个tif文件，则下载
                if (!fileTiff.exists()) {
                    ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                    if (response.isFailure()) {
                        return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                    }
                    strLocalTif = response.getContent();
                }
                // 以JPG模式预览的过程
                String strJpgFilePathName = fileDir + jpgName;
                // 将tif转换为jpg，返回转换后的文件路径、文件名的list
                List<String> listPic2Jpg = ConvertPicUtil.convertTif2Jpg(strLocalTif, strJpgFilePathName);
                // 将返回页面的图片url的list对象
                List<String> listImageUrls = new ArrayList<>();
                // 循环，拼装url的list对象
                for (String strJpg : listPic2Jpg) {
                    listImageUrls.add(baseUrl + strJpg);
                }
                model.addAttribute("imgUrls", listImageUrls);
                model.addAttribute("currentUrl", listImageUrls.get(0));
            }
            return PICTURE_FILE_PREVIEW_PAGE;
        }
        return NOT_SUPPORTED_FILE_PAGE;
    }
}
