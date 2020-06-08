package cn.keking.service.impl;

import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileUtils;
import com.google.common.collect.Lists;
import org.owasp.esapi.ESAPI;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by kl on 2018/1/17.
 * Content :图片文件处理
 */
@Service
public class PictureFilePreviewImpl implements FilePreview {

    private final FileUtils fileUtils;

    private final DownloadUtils downloadUtils;

    public PictureFilePreviewImpl(FileUtils fileUtils,
                                  DownloadUtils downloadUtils) {
        this.fileUtils = fileUtils;
        this.downloadUtils = downloadUtils;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileKey = (String) RequestContextHolder.currentRequestAttributes().getAttribute("fileKey", 0);
        List<String> imgUrls = Lists.newArrayList(url);
        try {
            imgUrls.clear();
            imgUrls.addAll(fileUtils.getImgCache(fileKey));
        } catch (Exception e) {
            imgUrls = Lists.newArrayList(url);
        }
        // 不是http开头，浏览器不能直接访问，需下载到本地
        if (url != null && !url.toLowerCase().startsWith("http")) {
            ReturnResponse<String> response = downloadUtils.downLoad(fileAttribute, null);
            if (0 != response.getCode()) {
                model.addAttribute("fileType", ESAPI.encoder().encodeForHTML(fileAttribute.getSuffix()));
                model.addAttribute("msg", ESAPI.encoder().encodeForHTML(response.getMsg()));
                return "fileNotSupported";
            } else {
                String file = fileUtils.getRelativePath(response.getContent());
                model.addAttribute("imgurls", Lists.newArrayList(file).stream().map(orig -> ESAPI.encoder().encodeForHTML(orig)).collect(Collectors.toList()));
                model.addAttribute("currentUrl", ESAPI.encoder().encodeForHTML(file));
            }
        } else {
            model.addAttribute("imgurls", imgUrls.stream().map(orig -> ESAPI.encoder().encodeForHTML(orig)).collect(Collectors.toList()));
            model.addAttribute("currentUrl", ESAPI.encoder().encodeForHTML(url));
        }
        return "picture";
    }
}
