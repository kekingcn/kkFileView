package cn.keking.service.impl;

import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FilePreview;
import cn.keking.utils.EncodingDetects;
import org.apache.commons.codec.binary.Base64;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.util.HtmlUtils;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Created by kl on 2018/1/17.
 * Content :处理文本文件
 */
@Service
public class SimTextFilePreviewImpl implements FilePreview {

    private final OtherFilePreviewImpl otherFilePreview;
    private final DownloadService downloadService;

    public SimTextFilePreviewImpl(
        OtherFilePreviewImpl otherFilePreview, DownloadService downloadService
    ) {
        this.otherFilePreview = otherFilePreview;
        this.downloadService = downloadService;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        ReturnResponse<DownloadResult> response = downloadService.downloadFile(fileAttribute);
        if (response.isFailure()) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
        }
        try {
            String fileData = HtmlUtils.htmlEscape(textData(response.getContent().getSavePath()));
            model.addAttribute("textData", Base64.encodeBase64String(fileData.getBytes()));
        } catch (IOException e) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, e.getLocalizedMessage());
        }
        return TXT_FILE_PREVIEW_PAGE;
    }

    // 读取文本文件，如果文件不存在则返回空字符串
    @NonNull
    static String textData(String filePath) throws IOException {
        Path path = Paths.get(filePath);

        if (!Files.exists(path) || Files.size(path) == 0) {
            return "";
        }

        String charset = EncodingDetects.getJavaEncode(filePath);
        String lineSeparator = "\r\n";
        return String.join(lineSeparator, Files.readAllLines(path, Charset.forName(charset)));
    }

}
