package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * @author kl (http://kailing.pub)
 * @since 2020/12/25
 */
@Service
public class MarkdownFilePreviewImpl implements FilePreview {

    private final SimTextFilePreviewImpl simTextFilePreview;

    public MarkdownFilePreviewImpl(SimTextFilePreviewImpl simTextFilePreview) {
        this.simTextFilePreview = simTextFilePreview;
    }


    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
         simTextFilePreview.filePreviewHandle(url, model, fileAttribute);
         return MARKDOWN_FILE_PREVIEW_PAGE;
    }
}
