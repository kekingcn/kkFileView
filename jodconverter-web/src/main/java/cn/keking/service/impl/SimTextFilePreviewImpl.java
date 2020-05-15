package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

/**
 * Created by kl on 2018/1/17.
 * Content :处理文本文件
 */
@Service
public class SimTextFilePreviewImpl implements FilePreview {

    private final DownloadUtils downloadUtils;

    public SimTextFilePreviewImpl(DownloadUtils downloadUtils) {
        this.downloadUtils = downloadUtils;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute){
        String fileName = fileAttribute.getName();
        ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, fileName);
        if (0 != response.getCode()) {
            model.addAttribute("msg", response.getMsg());
            model.addAttribute("fileType",fileAttribute.getSuffix());
            return "fileNotSupported";
        }
        try {
            File originFile = new File(response.getContent());
            File previewFile = new File(response.getContent() + ".txt");
            if (previewFile.exists()) {
                previewFile.delete();
            }
            Files.copy(originFile.toPath(), previewFile.toPath());
        } catch (IOException e) {
            model.addAttribute("msg", e.getLocalizedMessage());
            model.addAttribute("fileType",fileAttribute.getSuffix());
            return "fileNotSupported";
        }
        model.addAttribute("ordinaryUrl", response.getMsg());
        return "txt";
    }

}
