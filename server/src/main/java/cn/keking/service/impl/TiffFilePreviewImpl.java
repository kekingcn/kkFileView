package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import cn.keking.utils.WebUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

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

    public TiffFilePreviewImpl(PictureFilePreviewImpl pictureFilePreview) {
        this.pictureFilePreview = pictureFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        pictureFilePreview.filePreviewHandle(url,model,fileAttribute);
       String fileSize = WebUtils.getUrlParameterReg(url,INITIALIZE_MEMORY_SIZE);
       if(StringUtils.hasText(fileSize)){
           model.addAttribute(INITIALIZE_MEMORY_SIZE,fileSize);
       }else {
           model.addAttribute(INITIALIZE_MEMORY_SIZE,Long.toString(INITIALIZE_MEMORY_SIZE_VALUE_DEFAULT));
       }
        return TIFF_FILE_PREVIEW_PAGE;
    }
}
