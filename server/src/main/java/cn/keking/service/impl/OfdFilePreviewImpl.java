package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * ofd 图片文件处理
 * @author kl (http://kailing.pub)
 * @since 2021/2/8
 */
@Service
public class OfdFilePreviewImpl implements FilePreview {

    private final PictureFilePreviewImpl pictureFilePreview;

    public OfdFilePreviewImpl(PictureFilePreviewImpl pictureFilePreview) {
        this.pictureFilePreview = pictureFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        pictureFilePreview.filePreviewHandle(url,model,fileAttribute);
        return OFD_FILE_PREVIEW_PAGE;
    }
}
