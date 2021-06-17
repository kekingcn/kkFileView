package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * @author kl (http://kailing.pub)
 * @since 2021/6/17
 */
@Service
public class PptFilePreviewImpl implements FilePreview {

    private final OfficeFilePreviewImpl officeFilePreview;

    public PptFilePreviewImpl(OfficeFilePreviewImpl officeFilePreview) {
        this.officeFilePreview = officeFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        officeFilePreview.filePreviewHandle(url,model,fileAttribute);
        return PPT_FILE_PREVIEW_PAGE;
    }
}
