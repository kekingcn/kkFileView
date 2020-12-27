package cn.keking.web.controller;

import cn.keking.model.FileAttribute;
import cn.keking.service.FilePreview;
import cn.keking.service.FilePreviewFactory;

import cn.keking.service.cache.CacheService;
import cn.keking.utils.DownloadUtils;
import cn.keking.service.FileHandlerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.Base64Utils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.Arrays;
import java.util.List;

import static cn.keking.service.FilePreview.PICTURE_FILE_PREVIEW_PAGE;

/**
 * @author yudian-it
 */
@Controller
public class OnlinePreviewController {

    private final Logger logger = LoggerFactory.getLogger(OnlinePreviewController.class);

    private final FilePreviewFactory previewFactory;
    private final CacheService cacheService;
    private final FileHandlerService fileHandlerService;

    public OnlinePreviewController(FilePreviewFactory filePreviewFactory, FileHandlerService fileHandlerService, CacheService cacheService) {
        this.previewFactory = filePreviewFactory;
        this.fileHandlerService = fileHandlerService;
        this.cacheService = cacheService;
    }

    @RequestMapping(value = "/onlinePreview")
    public String onlinePreview(String url, Model model, HttpServletRequest req) {
        String fileUrl = new String(Base64Utils.decodeFromString(url));
        FileAttribute fileAttribute = fileHandlerService.getFileAttribute(fileUrl, req);
        FilePreview filePreview = previewFactory.get(fileAttribute);
        logger.info("预览文件url：{}，previewType：{}", fileUrl, fileAttribute.getType());
        return filePreview.filePreviewHandle(fileUrl, model, fileAttribute);
    }

    @RequestMapping(value = "/picturesPreview")
    public String picturesPreview(String urls, Model model, HttpServletRequest req) throws UnsupportedEncodingException {
        String fileUrls = new String(Base64Utils.decodeFromString(urls));
        logger.info("预览文件url：{}，urls：{}", fileUrls, urls);
        // 抽取文件并返回文件列表
        String[] imgs = fileUrls.split("\\|");
        List<String> imgUrls = Arrays.asList(imgs);
        model.addAttribute("imgUrls", imgUrls);

        String currentUrl = req.getParameter("currentUrl");
        if(StringUtils.hasText(currentUrl)){
            String decodedCurrentUrl = new String(Base64Utils.decodeFromString(currentUrl));
            model.addAttribute("currentUrl", decodedCurrentUrl);
        }
        return PICTURE_FILE_PREVIEW_PAGE;
    }

    /**
     * 根据url获取文件内容
     * 当pdfjs读取存在跨域问题的文件时将通过此接口读取
     *
     * @param urlPath  url
     * @param response response
     */
    @RequestMapping(value = "/getCorsFile", method = RequestMethod.GET)
    public void getCorsFile(String urlPath, HttpServletResponse response) {
        logger.info("下载跨域pdf文件url：{}", urlPath);
        try {
            byte[] bytes = DownloadUtils.getBytesFromUrl(urlPath);
            DownloadUtils.saveBytesToOutStream(bytes, response.getOutputStream());
        } catch (IOException e) {
            logger.error("下载跨域pdf文件异常，url：{}", urlPath, e);
        }
    }

    /**
     * 通过api接口入队
     *
     * @param url 请编码后在入队
     */
    @RequestMapping("/addTask")
    @ResponseBody
    public String addQueueTask(String url) {
        logger.info("添加转码队列url：{}", url);
        cacheService.addQueueTask(url);
        return "success";
    }

}
