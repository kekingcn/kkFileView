package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;

/**
 * MSG 文件预览 impl
 *
 * @author albert.chen
 * @date 2024/03/11
 */
@Component
public class MsgFilePreviewImpl implements FilePreview {

    private final OtherFilePreviewImpl otherFilePreview;


    public MsgFilePreviewImpl(OtherFilePreviewImpl otherFilePreview) {
        this.otherFilePreview = otherFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        return null;
    }
}
