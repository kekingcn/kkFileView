package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * @author kl (http://kailing.pub)
 * @since 2025/01/11
 * JSON 文件预览处理实现
 */
@Service
public class JsonFilePreviewImpl implements FilePreview {

    private final SimTextFilePreviewImpl simTextFilePreview;

    public JsonFilePreviewImpl(SimTextFilePreviewImpl simTextFilePreview) {
        this.simTextFilePreview = simTextFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        simTextFilePreview.filePreviewHandle(url, model, fileAttribute);
        return JSON_FILE_PREVIEW_PAGE;
    }
}
