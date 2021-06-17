package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
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

    public SimTextFilePreviewImpl(OtherFilePreviewImpl otherFilePreview) {
        this.otherFilePreview = otherFilePreview;
    }
    private static final String FILE_DIR = ConfigConstants.getFileDir();
    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {

        String fileName = fileAttribute.getName();
        String baseUrll = FILE_DIR + fileName;
        //  String suffix = fileAttribute.getSuffix();
        ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
        if (response.isFailure()) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
        }
        try {
            String   fileData = HtmlUtils.htmlEscape(textData(baseUrll));
            model.addAttribute("textData", Base64.encodeBase64String(fileData.getBytes()));
        } catch (IOException e) {
            return otherFilePreview.notSupportedFile(model, fileAttribute, e.getLocalizedMessage());
        }
        return TXT_FILE_PREVIEW_PAGE;
    }

    private String textData(String baseUrll) throws IOException {
        File file = new File(baseUrll);
        if(!file.exists() || file.length() == 0) {
            String line="";
            return line;
        }else {
            String charset = EncodingDetects.getJavaEncode(baseUrll);
            System.out.println(charset);
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(baseUrll), charset));
            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line).append("\r\n");
            }
            return result.toString();
        }
    }


}
