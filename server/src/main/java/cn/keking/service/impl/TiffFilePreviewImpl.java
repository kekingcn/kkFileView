package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
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
        String tifOnLinePreviewType = fileAttribute.getTifPreviewType();
        if (StringUtils.hasText(tifOnLinePreviewType)) {
            tifPreviewType = tifOnLinePreviewType;
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
            String inputFileNamePrefix = inputFileName.substring(0, inputFileName.lastIndexOf("."));

            String strLocalTif = fileDir + inputFileName;
            File fileTiff = new File(strLocalTif);
            // 如果本地不存在这个tif文件，则下载
            if(!fileTiff.exists()){
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, inputFileName);
                if (response.isFailure()) {
                    return NOT_SUPPORTED_FILE_PAGE;
                }
            }

            String baseUrl = BaseUrlFilter.getBaseUrl();
            if("pdf".equalsIgnoreCase(tifPreviewType)){
                // 以PDF模式预览的过程
                File filePdf = new File(fileDir + inputFileNamePrefix + ".pdf");
                // 如果本地不存在对应的pdf，则调用转换过程。否则直接用现有的pdf文件
                if(!filePdf.exists()){
                    filePdf = ConvertPicUtil.convertTif2Pdf(strLocalTif, fileDir + inputFileNamePrefix + ".pdf");
                }

                // 如果pdf已经存在，则将url路径加入到对象中，返回给页面
                if(filePdf.exists()){
                    String pdfUrl = baseUrl + inputFileNamePrefix + ".pdf";
                    model.addAttribute("pdfUrl", pdfUrl);

                    return PDF_FILE_PREVIEW_PAGE;
                }
            }else{
                // 以JPG模式预览的过程
                String strJpgFilePathName = fileDir + inputFileNamePrefix + ".jpg";
                // 将tif转换为jpg，返回转换后的文件路径、文件名的list
                List<String> listPic2Jpg = ConvertPicUtil.convertTif2Jpg(strLocalTif, strJpgFilePathName);
                // 将返回页面的图片url的list对象
                List<String> listImageUrls = new ArrayList<>();
                // 循环，拼装url的list对象
                for(String strJpg : listPic2Jpg){
                    listImageUrls.add(baseUrl + strJpg);
                }

                model.addAttribute("imgUrls", listImageUrls);
                model.addAttribute("currentUrl", listImageUrls.get(0));
            }

            // 转换后的tif没用了，可以删掉了
            if(fileTiff.exists()){
                fileTiff.delete();
            }

            return PICTURE_FILE_PREVIEW_PAGE;
        }

        return NOT_SUPPORTED_FILE_PAGE;
    }
}
