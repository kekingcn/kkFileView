package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.ConvertPicUtil;
import cn.keking.utils.DownloadUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

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

    private final String fileDir = ConfigConstants.getFileDir();

    public TiffFilePreviewImpl(PictureFilePreviewImpl pictureFilePreview) {
        this.pictureFilePreview = pictureFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
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
            fileTiff.delete();

            String baseUrl = BaseUrlFilter.getBaseUrl();
            if("pdf".equalsIgnoreCase(fileAttribute.getOfficePreviewType())){
                File filePdf = ConvertPicUtil.convertJpg2Pdf(fileDir + uuid + ".jpg", fileDir + uuid + ".pdf");
                if(filePdf.exists()){
                    // 转换后的jpg没用了，可以删掉了
                    fileJpg.delete();

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
}
