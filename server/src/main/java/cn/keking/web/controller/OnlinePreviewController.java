package cn.keking.web.controller;

import cn.keking.model.FileAttribute;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.FilePreviewFactory;
import cn.keking.service.cache.CacheService;
import cn.keking.service.impl.OtherFilePreviewImpl;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.WebUtils;
import fr.opensagres.xdocreport.core.io.IOUtils;
import io.mola.galimatias.GalimatiasParseException;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;

import static cn.keking.service.FilePreview.PICTURE_FILE_PREVIEW_PAGE;

/**
 * @author yudian-it
 */
@Controller
public class OnlinePreviewController {

    public static final String BASE64_DECODE_ERROR_MSG = "Base64解码失败，请检查你的 %s 是否采用 Base64 + urlEncode 双重编码了！";
    private final Logger logger = LoggerFactory.getLogger(OnlinePreviewController.class);

    private final FilePreviewFactory previewFactory;
    private final CacheService cacheService;
    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;

    public OnlinePreviewController(FilePreviewFactory filePreviewFactory, FileHandlerService fileHandlerService, CacheService cacheService, OtherFilePreviewImpl otherFilePreview) {
        this.previewFactory = filePreviewFactory;
        this.fileHandlerService = fileHandlerService;
        this.cacheService = cacheService;
        this.otherFilePreview = otherFilePreview;
    }

    @GetMapping( "/onlinePreview")
    public String onlinePreview(String url, Model model, HttpServletRequest req) {
        String fileUrl;
        try {
            fileUrl = WebUtils.decodeUrl(url);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "url");
            return otherFilePreview.notSupportedFile(model, errorMsg);
        }
        FileAttribute fileAttribute = fileHandlerService.getFileAttribute(fileUrl, req);
        model.addAttribute("file", fileAttribute);
        FilePreview filePreview = previewFactory.get(fileAttribute);
        logger.info("预览文件url：{}，previewType：{}", fileUrl, fileAttribute.getType());
        return filePreview.filePreviewHandle(fileUrl, model, fileAttribute);
    }

    @GetMapping( "/picturesPreview")
    public String picturesPreview(String urls, Model model, HttpServletRequest req) {
        String fileUrls;
        try {
            fileUrls = WebUtils.decodeUrl(urls);
            // 防止XSS攻击
            fileUrls = KkFileUtils.htmlEscape(fileUrls);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "urls");
            return otherFilePreview.notSupportedFile(model, errorMsg);
        }
        logger.info("预览文件url：{}，urls：{}", fileUrls, urls);
        // 抽取文件并返回文件列表
        String[] images = fileUrls.split("\\|");
        List<String> imgUrls = Arrays.asList(images);
        model.addAttribute("imgUrls", imgUrls);
        String currentUrl = req.getParameter("currentUrl");
        if (StringUtils.hasText(currentUrl)) {
            String decodedCurrentUrl = new String(Base64.decodeBase64(currentUrl));
                   decodedCurrentUrl = KkFileUtils.htmlEscape(decodedCurrentUrl);   // 防止XSS攻击
            model.addAttribute("currentUrl", decodedCurrentUrl);
        } else {
            model.addAttribute("currentUrl", imgUrls.get(0));
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
    @GetMapping("/getCorsFile")
    public void getCorsFile(String urlPath, HttpServletResponse response) throws IOException {
        try {
            urlPath = WebUtils.decodeUrl(urlPath);
        } catch (Exception ex) {
            logger.error(String.format(BASE64_DECODE_ERROR_MSG, urlPath),ex);
            return;
        }
        HttpURLConnection urlcon;
        InputStream inputStream = null;
        if (urlPath.toLowerCase().startsWith("file:") || urlPath.toLowerCase().startsWith("file%3")) {
            logger.info("读取跨域文件异常，可能存在非法访问，urlPath：{}", urlPath);
            return;
        }
        logger.info("下载跨域pdf文件url：{}", urlPath);
        if (!urlPath.toLowerCase().startsWith("ftp:")){
            try {
                URL url = WebUtils.normalizedURL(urlPath);
                urlcon=(HttpURLConnection)url.openConnection();
                urlcon.setConnectTimeout(30000);
                urlcon.setReadTimeout(30000);
                urlcon.setInstanceFollowRedirects(false);
                if (urlcon.getResponseCode() == 302 || urlcon.getResponseCode() == 301) {
                    urlcon.disconnect();
                    url =new URL(urlcon.getHeaderField("Location"));
                    urlcon=(HttpURLConnection)url.openConnection();
                }
                if (urlcon.getResponseCode() == 404 || urlcon.getResponseCode() == 403 || urlcon.getResponseCode() == 500 ) {
                    logger.error("读取跨域文件异常，url：{}", urlPath);
                    return ;
                } else {
                    if(urlPath.contains( ".svg")) {
                        response.setContentType("image/svg+xml");
                    }
                    inputStream=(url).openStream();
                    IOUtils.copy(inputStream, response.getOutputStream());
                    urlcon.disconnect();
                }
            } catch (IOException | GalimatiasParseException e) {
                logger.error("读取跨域文件异常，url：{}", urlPath);
                return ;
            } finally {
                IOUtils.closeQuietly(inputStream);
            }
        } else {
            try {
                URL url = WebUtils.normalizedURL(urlPath);
                if(urlPath.contains(".svg")) {
                    response.setContentType("image/svg+xml");
                }
                inputStream = (url).openStream();
                IOUtils.copy(inputStream, response.getOutputStream());
            } catch (IOException | GalimatiasParseException e) {
                logger.error("读取跨域文件异常，url：{}", urlPath);
                return ;
            } finally {
                IOUtils.closeQuietly(inputStream);
            }
        }
    }

    /**
     * 通过api接口入队
     *
     * @param url 请编码后在入队
     */
    @GetMapping("/addTask")
    @ResponseBody
    public String addQueueTask(String url) {
        logger.info("添加转码队列url：{}", url);
        cacheService.addQueueTask(url);
        return "success";
    }
}
