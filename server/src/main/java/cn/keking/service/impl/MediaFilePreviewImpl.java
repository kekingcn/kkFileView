package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FilePreviewCommonService;
import cn.keking.web.filter.BaseUrlFilter;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
/**
 * @author : kl
 * @authorboke : kailing.pub
 * @create : 2018-03-25 上午11:58
 * @description:
 **/
@Service
public class MediaFilePreviewImpl implements FilePreview {

    private final DownloadUtils downloadUtils;

    private final FilePreviewCommonService filePreviewCommonService;

    public MediaFilePreviewImpl(DownloadUtils downloadUtils,
                                FilePreviewCommonService filePreviewCommonService) {
        this.downloadUtils = downloadUtils;
        this.filePreviewCommonService = filePreviewCommonService;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        // 不是http开头，浏览器不能直接访问，需下载到本地
        if (url != null && !url.toLowerCase().startsWith("http")) {
            ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, fileAttribute.getName());
            if (0 != response.getCode()) {
                model.addAttribute("fileType", fileAttribute.getSuffix());
                model.addAttribute("msg", response.getMsg());
                return "fileNotSupported";
            } else {
                model.addAttribute("mediaUrl", BaseUrlFilter.getBaseUrl() + filePreviewCommonService.getRelativePath(response.getContent()));
            }
        } else {
            model.addAttribute("mediaUrl", url);
        }
        model.addAttribute("mediaUrl", url);
        String suffix=fileAttribute.getSuffix();
        if ("flv".equalsIgnoreCase(suffix)) {
            return "flv";
        }
        return "media";
    }


}
