package cn.keking.service.impl;

import cn.keking.model.DownloadResult;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.DownloadService;
import cn.keking.service.FilePreview;
import cn.keking.utils.EncodingDetects;
import org.apache.commons.codec.binary.Base64;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.util.HtmlUtils;

import java.io.*;

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

    private String textData(String filePath) throws IOException {
        File file = new File(filePath);
        if (!file.exists() || file.length() == 0) {
            return "";
        } else {
            String charset = EncodingDetects.getJavaEncode(filePath);
            System.out.println(charset);
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(filePath), charset));
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line).append("\r\n");
            }
            return result.toString();
        }
    }


}
