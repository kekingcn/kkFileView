package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

/**
 * Created by kl on 2018/1/17.
 * Content :其他文件
 */
@Service
public class OtherFilePreviewImpl implements FilePreview {
    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        model.addAttribute("fileType",fileAttribute.getSuffix());
        model.addAttribute("msg", "系统还不支持该格式文件的在线预览");
        return "fileNotSupported";
    }
}
