package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.KkFileUtils;
import jodd.io.FileUtil;
import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.io.File;
import java.io.IOException;

/**
 * Created by kl on 2018/1/17.
 * Content :处理文本文件
 */
@Service
public class SimTextFilePreviewImpl implements FilePreview {

    private final OtherFilePreviewImpl otherFilePreview;

    public SimTextFilePreviewImpl(OtherFilePreviewImpl otherFilePreview) {
        this.otherFilePreview = otherFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
        if (response.isFailure()) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
        }
        try {
            File originFile = new File(response.getContent());
            String charset = KkFileUtils.getFileEncode(originFile);
            String fileData = FileUtil.readString(originFile, charset);
            model.addAttribute("textData", Base64.encodeBase64String(fileData.getBytes()));
        } catch (IOException e) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, e.getLocalizedMessage());
        }
        return TXT_FILE_PREVIEW_PAGE;
    }

}
