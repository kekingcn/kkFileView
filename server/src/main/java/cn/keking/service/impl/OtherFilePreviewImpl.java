package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import cn.keking.utils.KkFileUtils;
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
        return this.notSupportedFile(model, fileAttribute, "系统还不支持该格式文件的在线预览");
    }

    /**
     * 通用的预览失败，导向到不支持的文件响应页面
     *
     * @return 页面
     */
    public String notSupportedFile(Model model, FileAttribute fileAttribute, String errMsg) {
        return this.notSupportedFile(model, fileAttribute.getSuffix(), errMsg);
    }

    /**
     * 通用的预览失败，导向到不支持的文件响应页面
     *
     * @return 页面
     */
    public String notSupportedFile(Model model, String errMsg) {
        return this.notSupportedFile(model, "未知", errMsg);
    }

    /**
     * 通用的预览失败，导向到不支持的文件响应页面
     *
     * @return 页面
     */
    public String notSupportedFile(Model model, String fileType, String errMsg) {
        model.addAttribute("fileType",  KkFileUtils.htmlEscape(fileType));
        model.addAttribute("msg", KkFileUtils.htmlEscape(errMsg));
        return NOT_SUPPORTED_FILE_PAGE;
    }


}
