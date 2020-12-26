package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FileHandlerService;
import cn.keking.service.CompressFileReader;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;

/**
 * Created by kl on 2018/1/17.
 * Content :处理压缩包文件
 */
@Service
public class CompressFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final CompressFileReader compressFileReader;

    public CompressFilePreviewImpl(FileHandlerService fileHandlerService, CompressFileReader compressFileReader) {
        this.fileHandlerService = fileHandlerService;
        this.compressFileReader = compressFileReader;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName=fileAttribute.getName();
        String suffix=fileAttribute.getSuffix();
        String fileTree = null;
        // 判断文件名是否存在(redis缓存读取)
        if (!StringUtils.hasText(fileHandlerService.getConvertedFile(fileName))  || !ConfigConstants.isCacheEnabled()) {
            ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
            if (0 != response.getCode()) {
                model.addAttribute("fileType", suffix);
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            }
            String filePath = response.getContent();
            if ("zip".equalsIgnoreCase(suffix) || "jar".equalsIgnoreCase(suffix) || "gzip".equalsIgnoreCase(suffix)) {
                fileTree = compressFileReader.readZipFile(filePath, fileName);
            } else if ("rar".equalsIgnoreCase(suffix)) {
                fileTree = compressFileReader.unRar(filePath, fileName);
            } else if ("7z".equalsIgnoreCase(suffix)) {
                fileTree = compressFileReader.read7zFile(filePath, fileName);
            }
            if (fileTree != null && !"null".equals(fileTree) && ConfigConstants.isCacheEnabled()) {
                fileHandlerService.addConvertedFile(fileName, fileTree);
            }
        } else {
            fileTree = fileHandlerService.getConvertedFile(fileName);
        }
        if (fileTree != null && !"null".equals(fileTree)) {
            model.addAttribute("fileTree", fileTree);
            return "compress";
        } else {
            model.addAttribute("fileType", suffix);
            model.addAttribute("msg", "压缩文件类型不受支持，尝试在压缩的时候选择RAR4格式");
            return "fileNotSupported";
        }
    }
}
