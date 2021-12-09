package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.ConvertPicUtil;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.WebUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * tiff 图片文件处理
 * @author kl (http://kailing.pub)
 * @since 2021/2/8
 */
@Service
public class TiffFilePreviewImpl implements FilePreview {

    private final PictureFilePreviewImpl pictureFilePreview;
    private static final String INITIALIZE_MEMORY_SIZE = "initializeMemorySize";
    //默认初始化 50MB 内存
    private static final long INITIALIZE_MEMORY_SIZE_VALUE_DEFAULT = 1024L * 1024 * 50;

    private final String fileDir = ConfigConstants.getFileDir();

    public TiffFilePreviewImpl(PictureFilePreviewImpl pictureFilePreview) {
        this.pictureFilePreview = pictureFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String tifPreviewType = ConfigConstants.getTifPreviewType();
        String previewType = fileAttribute.getPreviewType();
        if (StringUtils.hasText(previewType)) {
            tifPreviewType = previewType;
        }

        if("tif".equalsIgnoreCase(tifPreviewType)){

            pictureFilePreview.filePreviewHandle(url,model,fileAttribute);
            String fileSize = WebUtils.getUrlParameterReg(url,INITIALIZE_MEMORY_SIZE);
            if(StringUtils.hasText(fileSize)){
                model.addAttribute(INITIALIZE_MEMORY_SIZE,fileSize);
            }else {
                model.addAttribute(INITIALIZE_MEMORY_SIZE,Long.toString(INITIALIZE_MEMORY_SIZE_VALUE_DEFAULT));
            }
            return TIFF_FILE_PREVIEW_PAGE;

        }else if("jpg".equalsIgnoreCase(tifPreviewType) || "pdf".equalsIgnoreCase(tifPreviewType)){
            String inputFileName = url.substring(url.lastIndexOf("/") + 1);
            String inputFileExt = inputFileName.substring(inputFileName.lastIndexOf(".") + 1);
            String uuid = UUID.randomUUID().toString().replaceAll("-","");
            String tiffFileName = uuid + "." + inputFileExt;

            ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, tiffFileName);
            if (response.isFailure()) {
                return NOT_SUPPORTED_FILE_PAGE;
            }
            String strTiffPath = response.getContent();

            File fileTiff = new File(strTiffPath);

            File fileJpg = ConvertPicUtil.convertPic2Jpg(strTiffPath, fileDir + uuid + ".jpg");

            if(fileJpg.exists()){
                // 转换后的tif没用了，可以删掉了
                if(fileTiff.exists()){
                    fileTiff.delete();
                }

                String baseUrl = BaseUrlFilter.getBaseUrl();
                if("pdf".equalsIgnoreCase(tifPreviewType)){
                    File filePdf = ConvertPicUtil.convertJpg2Pdf(fileDir + uuid + ".jpg", fileDir + uuid + ".pdf");
                    if(filePdf.exists()){
                        String pdfUrl = baseUrl + uuid + ".pdf";
                        model.addAttribute("pdfUrl", pdfUrl);

                        return PDF_FILE_PREVIEW_PAGE;
                    }
                }else{
                    String jpgUrl = baseUrl + uuid + ".jpg";

                    fileAttribute.setName(uuid + ".jpg");
                    fileAttribute.setType(FileType.PICTURE);
                    fileAttribute.setSuffix("jpg");
                    fileAttribute.setUrl(jpgUrl);

                    List<String> imgUrls = new ArrayList<>();
                    imgUrls.add(jpgUrl);

                    model.addAttribute("imgUrls", imgUrls);
                    model.addAttribute("currentUrl", jpgUrl);
                }

            }

            return PICTURE_FILE_PREVIEW_PAGE;
        }

        return NOT_SUPPORTED_FILE_PAGE;
    }
}
