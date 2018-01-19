package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileUtils;
import cn.keking.utils.ZipReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

/**
 * Created by kl on 2018/1/17.
 * Content :处理压缩包文件
 */
@Service
public class CompressFilePreviewImpl implements FilePreview{

    @Autowired
    FileUtils fileUtils;

    @Autowired
    DownloadUtils downloadUtils;

    @Autowired
    ZipReader zipReader;

    @Override
    public String filePreviewHandle(String url, Model model) {
        FileAttribute fileAttribute=fileUtils.getFileAttribute(url);
        String fileName=fileAttribute.getName();
        String decodedUrl=fileAttribute.getDecodedUrl();
        String suffix=fileAttribute.getSuffix();
        String fileTree = null;
        // 判断文件名是否存在(redis缓存读取)
        if (!StringUtils.hasText(fileUtils.getConvertedFile(fileName))) {
            ReturnResponse<String> response = downloadUtils.downLoad(decodedUrl, suffix, fileName);
            if (0 != response.getCode()) {
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            }
            String filePath = response.getContent();
            if ("zip".equalsIgnoreCase(suffix) || "jar".equalsIgnoreCase(suffix) || "gzip".equalsIgnoreCase(suffix)) {
                fileTree = zipReader.readZipFile(filePath, fileName);
            } else if ("rar".equalsIgnoreCase(suffix)) {
                fileTree = zipReader.unRar(filePath, fileName);
            }
            fileUtils.addConvertedFile(fileName, fileTree);
        } else {
            fileTree = fileUtils.getConvertedFile(fileName);
        }
        if (null != fileTree) {
            model.addAttribute("fileTree", fileTree);
            return "compress";
        } else {
            model.addAttribute("msg", "压缩文件类型不受支持，尝试在压缩的时候选择RAR4格式");
            return "fileNotSupported";
        }
    }
}
