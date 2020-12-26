package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FilePreviewCommonService;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kl on 2018/1/17.
 * Content :图片文件处理
 */
@Service
public class PictureFilePreviewImpl implements FilePreview {

    private final FilePreviewCommonService filePreviewCommonService;

    private final DownloadUtils downloadUtils;

    public PictureFilePreviewImpl(FilePreviewCommonService filePreviewCommonService,
                                  DownloadUtils downloadUtils) {
        this.filePreviewCommonService = filePreviewCommonService;
        this.downloadUtils = downloadUtils;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        List<String> imgUrls = new ArrayList<>();
        imgUrls.add(url);
        String fileKey = fileAttribute.getFileKey();
        List<String> zipImgUrls = filePreviewCommonService.getImgCache(fileKey);
        if (!CollectionUtils.isEmpty(zipImgUrls)) {
            imgUrls.addAll(zipImgUrls);
        }
        // 不是http开头，浏览器不能直接访问，需下载到本地
        if (url != null && !url.toLowerCase().startsWith("http")) {
            ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, null);
            if (0 != response.getCode()) {
                model.addAttribute("fileType", fileAttribute.getSuffix());
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            } else {
                String file = filePreviewCommonService.getRelativePath(response.getContent());
                imgUrls.clear();
                imgUrls.add(file);
                model.addAttribute("imgurls", imgUrls);
                model.addAttribute("currentUrl", file);
            }
        } else {
            model.addAttribute("imgurls", imgUrls);
            model.addAttribute("currentUrl", url);
        }
        return "picture";
    }
}
