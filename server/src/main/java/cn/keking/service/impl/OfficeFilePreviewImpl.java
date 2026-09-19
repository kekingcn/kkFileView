package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.OfficeToPdfService;
import cn.keking.service.PdfToJpgService;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.FileConvertStatusManager;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.OfficeUtils;
import cn.keking.utils.WebUtils;
import cn.keking.web.filter.BaseUrlFilter;
import org.jodconverter.core.office.OfficeException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Created by kl on 2018/1/17.
 * Content :处理office文件
 */
@Service
public class OfficeFilePreviewImpl implements FilePreview {

    private static final Logger logger = LoggerFactory.getLogger(OfficeFilePreviewImpl.class);
    public static final String OFFICE_PREVIEW_TYPE_IMAGE = "image";
    public static final String OFFICE_PREVIEW_TYPE_ALL_IMAGES = "allImages";

    // 用于处理回调的线程池
    private static final ExecutorService callbackExecutor = Executors.newFixedThreadPool(3);

    private final FileHandlerService fileHandlerService;
    private final OfficeToPdfService officeToPdfService;
    private final OtherFilePreviewImpl otherFilePreview;
    private final PdfToJpgService pdftojpgservice;

    public OfficeFilePreviewImpl(FileHandlerService fileHandlerService, OfficeToPdfService officeToPdfService, OtherFilePreviewImpl otherFilePreview, PdfToJpgService pdftojpgservice) {
        this.fileHandlerService = fileHandlerService;
        this.officeToPdfService = officeToPdfService;
        this.otherFilePreview = otherFilePreview;
        this.pdftojpgservice = pdftojpgservice;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        // 预览Type，参数传了就取参数的，没传取系统默认
        String officePreviewType = fileAttribute.getOfficePreviewType();
        boolean userToken = fileAttribute.getUsePasswordCache();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String suffix = fileAttribute.getSuffix();  //获取文件后缀
        String fileName = fileAttribute.getName(); //获取文件原始名称
        String filePassword = fileAttribute.getFilePassword(); //获取密码
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();  //是否启用强制更新命令
        boolean isHtmlView = fileAttribute.isHtmlView();  //xlsx  转换成html
        String cacheName = fileAttribute.getCacheName();  //转换后的文件名
        String outFilePath = fileAttribute.getOutFilePath();  //转换后生成文件的路径

        // 查询转换状态
        String convertStatusResult = checkAndHandleConvertStatus(model, fileName, cacheName, fileAttribute);
        if (convertStatusResult != null) {
            return convertStatusResult;
        }

        if (shouldUseWebPreview(fileAttribute)) {
            if (suffix.equalsIgnoreCase("xlsx")) {
                model.addAttribute("pdfUrl", KkFileUtils.htmlEscape(url)); //特殊符号处理
                return XLSX_FILE_PREVIEW_PAGE;
            }
            if (suffix.equalsIgnoreCase("csv")) {
                model.addAttribute("csvUrl", KkFileUtils.htmlEscape(url));
                return CSV_FILE_PREVIEW_PAGE;
            }
        }

        // 图片预览模式（异步转换）
        if (!isHtmlView && baseUrl != null && (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) || OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType))) {
            boolean jiami = false;
            if (!ObjectUtils.isEmpty(filePassword)) {
                jiami = pdftojpgservice.hasEncryptedPdfCacheSimple(outFilePath);
            }
            if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(cacheName) || !ConfigConstants.isCacheEnabled()) {
                if (jiami) {
                    return getPreviewType(model, fileAttribute, officePreviewType, cacheName, outFilePath);
                }
                // 下载文件
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }
                String filePath = response.getContent();

                // 检查是否加密文件
                boolean isPwdProtectedOffice = OfficeUtils.isPwdProtected(filePath);
                if (isPwdProtectedOffice && !StringUtils.hasLength(filePassword)) {
                    // 加密文件需要密码
                    model.addAttribute("needFilePassword", true);
                    model.addAttribute("fileName", fileName);
                    model.addAttribute("cacheName", cacheName);
                    return EXEL_FILE_PREVIEW_PAGE;
                }

                try {
                    // 启动异步转换
                    startAsyncOfficeConversion(filePath, outFilePath, cacheName, fileAttribute, officePreviewType);
                    int refreshSchedule = ConfigConstants.getTime();
                    // 返回等待页面
                    model.addAttribute("fileName", fileName);
                    model.addAttribute("time", refreshSchedule);
                    model.addAttribute("message", "文件正在转换中，请稍候...");
                    return WAITING_FILE_PREVIEW_PAGE;
                } catch (Exception e) {
                    logger.error("Failed to start Office conversion: {}", filePath, e);
                    return otherFilePreview.notSupportedFile(model, fileAttribute, "文件转换异常，请联系管理员");
                }
            } else {
                // 如果已有缓存，直接渲染预览
                return getPreviewType(model, fileAttribute, officePreviewType, cacheName, outFilePath);
            }
        }

        // 处理普通Office转PDF预览
        return handleRegularOfficePreview(model, fileAttribute, fileName, forceUpdatedCache, cacheName, outFilePath,
                isHtmlView, userToken, filePassword);
    }

    /**
     * 判断 xlsx 或 csv 文件是否应直接使用前端 Web 预览。
     * 未显式指定预览类型时保留系统原有 Web 预览行为；显式指定时仅文件类型同名模式
     * （{@code xlsx} 或 {@code csv}）使用 Web 预览，避免 {@code pdf} 请求被错误路由。
     *
     * @param fileAttribute 文件属性
     * @return 是否使用 Web 预览
     */
    static boolean shouldUseWebPreview(FileAttribute fileAttribute) {
        if (!ConfigConstants.getOfficeTypeWeb().equalsIgnoreCase("web")) {
            return false;
        }
        String suffix = fileAttribute.getSuffix();
        boolean webPreviewFile = suffix.equalsIgnoreCase("xlsx") || suffix.equalsIgnoreCase("csv");
        if (!webPreviewFile || "html".equalsIgnoreCase(fileAttribute.getOfficePreviewType())) {
            return false;
        }
        if (!fileAttribute.isOfficePreviewTypeSpecified()) {
            return true;
        }
        return suffix.equalsIgnoreCase(fileAttribute.getOfficePreviewType());
    }

    /**
     * 启动异步Office转换
     */
    private void startAsyncOfficeConversion(String filePath, String outFilePath, String cacheName,
                                            FileAttribute fileAttribute,
                                            String officePreviewType) {
        // 启动异步转换
        CompletableFuture<List<String>> conversionFuture = CompletableFuture.supplyAsync(() -> {
            try {
                // 更新状态
                FileConvertStatusManager.startConvert(cacheName);
                FileConvertStatusManager.updateProgress(cacheName, "正在启动Office转换", 20);

                // 转换Office到PDF
                FileConvertStatusManager.updateProgress(cacheName, "正在转换Office到jpg", 60);
                officeToPdfService.openOfficeToPDF(filePath, outFilePath, fileAttribute);


                if (fileAttribute.isHtmlView()) {
                    // 对转换后的文件进行操作(改变编码方式)
                    FileConvertStatusManager.updateProgress(cacheName, "处理HTML编码", 95);
                    fileHandlerService.doActionConvertedFile(outFilePath);
                }

                // 是否需要转换为图片
                List<String> imageUrls = null;
                if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType) ||
                        OFFICE_PREVIEW_TYPE_ALL_IMAGES.equals(officePreviewType)) {
                    FileConvertStatusManager.updateProgress(cacheName, "正在转换PDF为图片", 90);
                    imageUrls = pdftojpgservice.pdf2jpg(outFilePath, outFilePath, fileAttribute);
                }

                // 缓存处理
                boolean isPwdProtectedOffice = OfficeUtils.isPwdProtected(filePath);
                boolean userToken = fileAttribute.getUsePasswordCache();
                String filePassword = fileAttribute.getFilePassword();

                if (ConfigConstants.isCacheEnabled() && (ObjectUtils.isEmpty(filePassword) || userToken || !isPwdProtectedOffice)) {
                    fileHandlerService.addConvertedFile(cacheName, fileHandlerService.getRelativePath(outFilePath));
                }

                FileConvertStatusManager.updateProgress(cacheName, "转换完成", 100);
                FileConvertStatusManager.convertSuccess(cacheName);

                return imageUrls;
            } catch (OfficeException e) {
                boolean isPwdProtectedOffice = OfficeUtils.isPwdProtected(filePath);
                String filePassword = fileAttribute.getFilePassword();
                if (isPwdProtectedOffice && !OfficeUtils.isCompatible(filePath, filePassword)) {
                    FileConvertStatusManager.markError(cacheName, "文件密码错误，请重新输入");
                } else {
                    logger.error("Office转换执行失败: {}", cacheName, e);
                    FileConvertStatusManager.markError(cacheName, "Office转换失败: " + e.getMessage());
                }
                return null;
            } catch (Exception e) {
                logger.error("Office转换执行失败: {}", cacheName, e);

                // 检查是否已经标记为超时
                FileConvertStatusManager.ConvertStatus status = FileConvertStatusManager.getConvertStatus(cacheName);
                if (status == null || status.getStatus() != FileConvertStatusManager.Status.TIMEOUT) {
                    FileConvertStatusManager.markError(cacheName, "转换失败: " + e.getMessage());
                }
                return null;
            }
        });
        // 添加转换完成后的回调
        conversionFuture.thenAcceptAsync(imageUrls -> {
            try {
                // 这里假设imageUrls不为null且不为空表示转换成功
                if (imageUrls != null && !imageUrls.isEmpty()) {
                    // 是否保留源文件（只在转换成功后才删除）
                    if (!fileAttribute.isCompressFile() && ConfigConstants.getDeleteSourceFile()) {
                        KkFileUtils.deleteFileByPath(filePath);
                    }
                }
            } catch (Exception e) {
                logger.error("Office转换后续处理失败: {}", filePath, e);
            }
        }, callbackExecutor);
    }

    /**
     * 获取预览类型（图片预览）
     */
     String getPreviewType(Model model, FileAttribute fileAttribute, String officePreviewType,
                                  String cacheName, String outFilePath) {
        String suffix = fileAttribute.getSuffix();
        boolean isPPT = suffix.equalsIgnoreCase("ppt") || suffix.equalsIgnoreCase("pptx");
        List<String> imageUrls;

        try {
            if (pdftojpgservice.hasEncryptedPdfCacheSimple(outFilePath)) {
                imageUrls = pdftojpgservice.getEncryptedPdfCache(outFilePath);
            } else {
                imageUrls = fileHandlerService.loadPdf2jpgCache(outFilePath);
            }

            if (imageUrls == null || imageUrls.isEmpty()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, "Office转换缓存异常，请联系管理员");
            }

            model.addAttribute("imgUrls", imageUrls);
            model.addAttribute("currentUrl", imageUrls.getFirst());

            if (OFFICE_PREVIEW_TYPE_IMAGE.equals(officePreviewType)) {
                // PPT 图片模式使用专用预览页面
                return (isPPT ? PPT_FILE_PREVIEW_PAGE : OFFICE_PICTURE_FILE_PREVIEW_PAGE);
            } else {
                return PICTURE_FILE_PREVIEW_PAGE;
            }
        } catch (Exception e) {
            logger.error("渲染Office预览页面失败: {}", cacheName, e);
            return otherFilePreview.notSupportedFile(model, fileAttribute, "渲染预览页面异常，请联系管理员");
        }
    }

    /**
     * 处理普通Office预览（转PDF）
     */
    private String handleRegularOfficePreview(Model model, FileAttribute fileAttribute,
                                              String fileName, boolean forceUpdatedCache, String cacheName,
                                              String outFilePath, boolean isHtmlView, boolean userToken,
                                              String filePassword) {

        if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(cacheName) || !ConfigConstants.isCacheEnabled()) {
            // 下载远程文件到本地，如果文件在本地已存在不会重复下载
            ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
            if (response.isFailure()) {
                return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
            }
            String filePath = response.getContent();

            boolean isPwdProtectedOffice = OfficeUtils.isPwdProtected(filePath);    // 判断是否加密文件
            if (isPwdProtectedOffice && !StringUtils.hasLength(filePassword)) {
                // 加密文件需要密码
                model.addAttribute("needFilePassword", true);
                return EXEL_FILE_PREVIEW_PAGE;
            } else {
                if (StringUtils.hasText(outFilePath)) {
                    try {
                        officeToPdfService.openOfficeToPDF(filePath, outFilePath, fileAttribute);
                    } catch (OfficeException e) {
                        if (isPwdProtectedOffice && !OfficeUtils.isCompatible(filePath, filePassword)) {
                            // 加密文件密码错误，提示重新输入
                            model.addAttribute("needFilePassword", true);
                            model.addAttribute("filePasswordError", true);
                            return EXEL_FILE_PREVIEW_PAGE;
                        }
                        return otherFilePreview.notSupportedFile(model, fileAttribute, "抱歉，该文件版本不兼容，文件版本错误。");
                    }
                    if (isHtmlView) {
                        // 对转换后的文件进行操作(改变编码方式)
                        fileHandlerService.doActionConvertedFile(outFilePath);
                    }
                    //是否保留OFFICE源文件
                    if (!fileAttribute.isCompressFile() && ConfigConstants.getDeleteSourceFile()) {
                        KkFileUtils.deleteFileByPath(filePath);
                    }
                    if (userToken || !isPwdProtectedOffice) {
                        // 加入缓存
                        fileHandlerService.addConvertedFile(cacheName, fileHandlerService.getRelativePath(outFilePath));
                    }
                }
            }
        }

        model.addAttribute("pdfUrl", WebUtils.encodeFileName(cacheName));  //输出转义文件名 方便url识别
        return isHtmlView ? EXEL_FILE_PREVIEW_PAGE : PDF_FILE_PREVIEW_PAGE;
    }

    /**
     * 异步方法
     */
    public String checkAndHandleConvertStatus(Model model, String fileName, String cacheName, FileAttribute fileAttribute) {
        FileConvertStatusManager.ConvertStatus status = FileConvertStatusManager.getConvertStatus(cacheName);
        int refreshSchedule = ConfigConstants.getTime();
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();

        if (status != null) {
            if (status.getStatus() == FileConvertStatusManager.Status.CONVERTING) {
                // 正在转换中，返回等待页面
                model.addAttribute("fileName", fileName);
                model.addAttribute("time", refreshSchedule);
                model.addAttribute("message", status.getRealTimeMessage());
                return WAITING_FILE_PREVIEW_PAGE;
            } else if (status.getStatus() == FileConvertStatusManager.Status.TIMEOUT) {
                // 超时状态，检查是否有强制更新命令
                if (forceUpdatedCache) {
                    // 强制更新命令，清除状态，允许重新转换
                    FileConvertStatusManager.convertSuccess(cacheName);
                    logger.info("强制更新命令跳过超时状态，允许重新转换: {}", cacheName);
                    return null; // 返回null表示继续执行
                } else {
                    // 没有强制更新，不允许重新转换
                    return otherFilePreview.notSupportedFile(model, fileAttribute, "文件转换已超时，无法继续转换");
                }
            } else if (status.getStatus() == FileConvertStatusManager.Status.FAILED) {
                // 失败状态，检查是否有强制更新命令
                if (forceUpdatedCache) {
                    // 强制更新命令，清除状态，允许重新转换
                    FileConvertStatusManager.convertSuccess(cacheName);
                    logger.info("强制更新命令跳过失败状态，允许重新转换: {}", cacheName);
                    return null; // 返回null表示继续执行
                } else {
                    // 没有强制更新，不允许重新转换
                    return otherFilePreview.notSupportedFile(model, fileAttribute, "文件转换失败，无法继续转换");
                }
            }
        }
        return null;
    }
}
