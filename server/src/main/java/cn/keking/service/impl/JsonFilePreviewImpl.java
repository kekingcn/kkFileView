package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.KkFileUtils;
import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.util.HtmlUtils;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;


/**
 * @author kl (http://kailing.pub)
 * @since 2025/01/11
 * JSON 文件预览处理实现
 */
@Service
public class JsonFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;

    public JsonFilePreviewImpl(FileHandlerService fileHandlerService, OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        String filePath = fileAttribute.getOriginFilePath();

        if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(fileName) || !ConfigConstants.isCacheEnabled()) {
            ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }
            filePath = response.getContent();
            if (ConfigConstants.isCacheEnabled()) {
                fileHandlerService.addConvertedFile(fileName, filePath);
            }
            try {
                String fileData = readJsonFile(filePath, fileName);
                String escapedData = HtmlUtils.htmlEscape(fileData);
                String base64Data = Base64.encodeBase64String(escapedData.getBytes(StandardCharsets.UTF_8));
                model.addAttribute("textData", base64Data);
            } catch (IOException e) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, e.getLocalizedMessage());
            }
            return JSON_FILE_PREVIEW_PAGE;
        }

        String fileData = null;
        try {
            fileData = HtmlUtils.htmlEscape(readJsonFile(filePath, fileName));
        } catch (IOException e) {
            e.printStackTrace();
        }
        String base64Data = Base64.encodeBase64String(fileData.getBytes(StandardCharsets.UTF_8));
        model.addAttribute("textData", base64Data);
        return JSON_FILE_PREVIEW_PAGE;
    }

    /**
     * 读取 JSON 文件，强制使用 UTF-8 编码
     * JSON 标准规定必须使用 UTF-8 编码
     */
    private String readJsonFile(String filePath, String fileName) throws IOException {
        File file = new File(filePath);
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return null;
        }
        if (!file.exists() || file.length() == 0) {
            return "";
        }

        // JSON 标准规定使用 UTF-8 编码，不依赖自动检测
        byte[] bytes = Files.readAllBytes(Paths.get(filePath));
        return new String(bytes, StandardCharsets.UTF_8);
    }
}
