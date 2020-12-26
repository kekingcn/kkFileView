package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.Base64Utils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

/**
 * Created by kl on 2018/1/17.
 * Content :处理文本文件
 */
@Service
public class SimTextFilePreviewImpl implements FilePreview {

    public static final String TEXT_TYPE = "textType";
    public static final String DEFAULT_TEXT_TYPE = "simText";

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
        if (0 != response.getCode()) {
            model.addAttribute("msg", response.getMsg());
            model.addAttribute("fileType", fileAttribute.getSuffix());
            return "fileNotSupported";
        }
        try {
            File originFile = new File(response.getContent());
            String xmlString = FileUtils.readFileToString(originFile, StandardCharsets.UTF_8);
            model.addAttribute("textData", Base64Utils.encodeToString(xmlString.getBytes()));
        } catch (IOException e) {
            model.addAttribute("msg", e.getLocalizedMessage());
            model.addAttribute("fileType", fileAttribute.getSuffix());
            return "fileNotSupported";
        }
        if (!model.containsAttribute(TEXT_TYPE)) {
            model.addAttribute(TEXT_TYPE, DEFAULT_TEXT_TYPE);
        }
        return "txt";
    }

}
