package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * @author : kl
 * create : 2020-12-27 2:50 下午
 * flv文件预览处理实现
 **/
@Service
public class FlvFilePreviewImpl implements FilePreview {

    private final MediaFilePreviewImpl mediaFilePreview;

    public FlvFilePreviewImpl(MediaFilePreviewImpl mediaFilePreview) {
        this.mediaFilePreview = mediaFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        mediaFilePreview.filePreviewHandle(url,model,fileAttribute);
        return FLV_FILE_PREVIEW_PAGE;
    }
}
