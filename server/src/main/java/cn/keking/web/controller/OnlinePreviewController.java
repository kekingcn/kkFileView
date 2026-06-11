package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.FilePreviewFactory;
import cn.keking.service.cache.CacheService;
import cn.keking.service.impl.OtherFilePreviewImpl;
import cn.keking.utils.*;
import cn.keking.web.filter.TrustDirFilter;
import cn.keking.web.filter.TrustHostFilter;
import fr.opensagres.xdocreport.core.io.IOUtils;
import org.apache.commons.codec.binary.Base64;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.Arrays;
import java.util.List;

import static cn.keking.service.FilePreview.PICTURE_FILE_PREVIEW_PAGE;
import static cn.keking.utils.KkFileUtils.isFtpUrl;
import static cn.keking.utils.KkFileUtils.isHttpUrl;

/**
 * @author yudian-it
 */
@Controller
public class OnlinePreviewController {

    private final Logger logger = LoggerFactory.getLogger(OnlinePreviewController.class);
    public static final String BASE64_DECODE_ERROR_MSG = "Base64解码失败，请检查你的 %s 是否采用 Base64 + urlEncode 双重编码了！";
    private static final String ILLEGAL_ACCESS_MSG = "访问不合法：访问密码不正确";
    private static final String INTERFACE_CLOSED_MSG = "接口关闭，禁止访问!";
    private static final String URL_PARAM_FTP_USERNAME = "ftp.username";
    private static final String URL_PARAM_FTP_PASSWORD = "ftp.password";
    private static final String URL_PARAM_FTP_CONTROL_ENCODING = "ftp.control.encoding";
    private static final String URL_PARAM_FTP_PORT = "ftp.control.port";

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
    public String onlinePreview(@RequestParam String url,
                                @RequestParam(required = false) String key,
                                @RequestParam(required = false) String encryption,
                                @RequestParam(defaultValue = "false") String highlightall,
                                @RequestParam(defaultValue = "0") String page,
                                @RequestParam(defaultValue = "false") String kkagent,
                                Model model,
                                HttpServletRequest req) {
        // 验证访问权限
        if (WebUtils.validateKey(key)) {
            return otherFilePreview.notSupportedFile(model, ILLEGAL_ACCESS_MSG);
        }
        String fileUrl;
        try {
            fileUrl = WebUtils.decodeUrl(url, encryption);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "url");
            return otherFilePreview.notSupportedFile(model, errorMsg);
        }
        FileAttribute fileAttribute = fileHandlerService.getFileAttribute(fileUrl, req);

        highlightall= KkFileUtils.htmlEscape(highlightall);
        model.addAttribute("highlightall", highlightall);
        model.addAttribute("page", page);
        model.addAttribute("kkagent", kkagent);
        model.addAttribute("file", fileAttribute);
        FilePreview filePreview = previewFactory.get(fileAttribute);
        logger.info("预览文件url：{}，previewType：{}", fileUrl, fileAttribute.getType());
        fileUrl =WebUtils.urlEncoderencode(fileUrl);
        if (ObjectUtils.isEmpty(fileUrl)) {
            return otherFilePreview.notSupportedFile(model, "非法路径,不允许访问");
        }
        return filePreview.filePreviewHandle(fileUrl, model, fileAttribute);  //统一在这里处理 url
    }

    @GetMapping( "/picturesPreview")
    public String picturesPreview(@RequestParam String urls,
                                  @RequestParam(required = false) String key,
                                  @RequestParam(required = false) String encryption,
                                  Model model,
                                  HttpServletRequest req) {
        // 1. 验证接口是否开启
        if (!ConfigConstants.getPicturesPreview()) {
            return otherFilePreview.notSupportedFile(model, INTERFACE_CLOSED_MSG);
        }
        //2. 验证访问权限
        if (WebUtils.validateKey(key)) {
            return otherFilePreview.notSupportedFile(model, ILLEGAL_ACCESS_MSG);
        }
        String fileUrls;
        try {
            fileUrls = WebUtils.decodeUrl(urls, encryption);
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
    public void getCorsFile(@RequestParam String urlPath,
                            @RequestParam(required = false) String key,
                            HttpServletResponse response,
                            HttpServletRequest req,
                            @RequestParam(required = false) String encryption) throws Exception {

        // 1. 验证接口是否开启
        if (!ConfigConstants.getGetCorsFile()) {
            logger.info("接口关闭，禁止访问!，url：{}", urlPath);
            return;
        }
        //2. 验证访问权限
        if (WebUtils.validateKey(key)) {
            logger.info("访问不合法：访问密码不正确!，url：{}", urlPath);
            return;
        }
        URL url;
        try {
            urlPath = WebUtils.decodeUrl(urlPath, encryption);
            url = WebUtils.normalizedURL(urlPath);
        } catch (Exception ex) {
            logger.error(String.format(BASE64_DECODE_ERROR_MSG, urlPath),ex);
            return;
        }
        assert urlPath != null;
        if (!isHttpUrl(url) && !isFtpUrl(url)) {
            logger.info("读取跨域文件异常，可能存在非法访问，urlPath：{}", urlPath);
            return;
        }
        FileAttribute fileAttribute = fileHandlerService.getFileAttribute(urlPath, req);
        InputStream inputStream = null;
        logger.info("读取跨域文件url：{}", urlPath);
        if (!isFtpUrl(url)) {
            CloseableHttpClient httpClient = HttpRequestUtils.createConfiguredHttpClient();

            HttpRequestUtils.executeHttpRequest(url, httpClient, fileAttribute, responseWrapper -> IOUtils.copy(responseWrapper.getInputStream(), response.getOutputStream()));
        } else {
            try {
                String filename = urlPath.substring(urlPath.lastIndexOf('/') + 1);
                String contentType = WebUtils.getContentTypeByFilename(filename);
                if (contentType != null) {
                    response.setContentType(contentType);
                }
                String ftpUsername = WebUtils.getUrlParameterReg(urlPath, URL_PARAM_FTP_USERNAME);
                String ftpPassword = WebUtils.getUrlParameterReg(urlPath, URL_PARAM_FTP_PASSWORD);
                String ftpControlEncoding = WebUtils.getUrlParameterReg(urlPath, URL_PARAM_FTP_CONTROL_ENCODING);
                String support = WebUtils.getUrlParameterReg(urlPath, URL_PARAM_FTP_PORT);
                inputStream=  FtpUtils.preview(urlPath,support, urlPath, ftpUsername, ftpPassword, ftpControlEncoding);
                IOUtils.copy(inputStream, response.getOutputStream());
            } catch (IOException e) {
                logger.error("读取跨域文件异常，url：{}", urlPath);
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
    public String addQueueTask(@RequestParam String url,
                               @RequestParam(required = false) String key,
                               @RequestParam(required = false) String encryption) {
        // 1. 验证接口是否开启
        if (!ConfigConstants.getAddTask()) {
            String errorMsg = "接口关闭，禁止访问!";
            logger.info("{}，url：{}", errorMsg, url);
            return errorMsg;
        }
        String fileUrls;
        try {
            fileUrls = WebUtils.decodeUrl(url, encryption);
        } catch (Exception ex) {
            String errorMsg = "Url解析错误";
            logger.info("{}，url：{}", errorMsg, url);
            return errorMsg;
        }

        //2. 验证访问权限
        if (WebUtils.validateKey(key)) {
            String errorMsg = "访问不合法：访问密码不正确!";
            logger.info("{}，url：{}", errorMsg, fileUrls);
            return errorMsg;
        }
        if (!TrustHostFilter.isTrustedSourceUrl(fileUrls) || !TrustDirFilter.isTrustedFileUrl(fileUrls)) {
            String errorMsg = "访问不合法：来源地址不受信任!";
            logger.info("{}，url：{}", errorMsg, fileUrls);
            return errorMsg;
        }
        logger.info("添加转码队列url：{}", fileUrls);
        cacheService.addQueueTask(fileUrls);
        return "success";
    }
}