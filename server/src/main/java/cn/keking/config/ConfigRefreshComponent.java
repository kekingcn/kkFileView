package cn.keking.config;

import cn.keking.utils.ConfigUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.*;
import java.util.Properties;
import java.util.concurrent.*;

@Component
public class ConfigRefreshComponent {
    private static final Logger LOGGER = LoggerFactory.getLogger(ConfigRefreshComponent.class);
    private static final long DEBOUNCE_DELAY_SECONDS = 5;

    private final ScheduledExecutorService scheduler = Executors.newSingleThreadScheduledExecutor();
    private final ExecutorService watchServiceExecutor = Executors.newSingleThreadExecutor();
    private final Object lock = new Object();

    private ScheduledFuture<?> scheduledReloadTask;
    private WatchService watchService;
    private volatile boolean running = true;

    @PostConstruct
    void init() {
        loadConfig();
        watchServiceExecutor.submit(this::watchConfigFile);
    }

    @PreDestroy
    void destroy() {
        running = false;
        watchServiceExecutor.shutdownNow();
        scheduler.shutdownNow();
        if (watchService != null) {
            try {
                watchService.close();
            } catch (IOException e) {
                LOGGER.warn("关闭 WatchService 时发生异常", e);
            }
        }
    }

    private void watchConfigFile() {
        try {
            String configFilePath = ConfigUtils.getCustomizedConfigPath();
            Path configPath = Paths.get(configFilePath);
            Path configDir = configPath.getParent();
            if (configDir == null) {
                LOGGER.error("配置文件路径无效: {}", configFilePath);
                return;
            }

            watchService = FileSystems.getDefault().newWatchService();
            configDir.register(watchService,
                    StandardWatchEventKinds.ENTRY_MODIFY,
                    StandardWatchEventKinds.ENTRY_CREATE,
                    StandardWatchEventKinds.ENTRY_DELETE);
            LOGGER.info("开始监听配置文件: {}", configFilePath);

            while (running && !Thread.currentThread().isInterrupted()) {
                try {
                    WatchKey key = watchService.take();
                    for (WatchEvent<?> event : key.pollEvents()) {
                        WatchEvent.Kind<?> kind = event.kind();
                        Path changedPath = (Path) event.context();
                        if (changedPath.equals(configPath.getFileName())) {
                            handleConfigChange(kind);
                        }
                    }
                    if (!key.reset()) {
                        LOGGER.warn("WatchKey 无法重置");
                        break;
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        } catch (IOException e) {
            LOGGER.error("初始化配置文件监听失败", e);
        }
    }

    private void handleConfigChange(WatchEvent.Kind<?> kind) {
        if (kind == StandardWatchEventKinds.ENTRY_DELETE) {
            running = false;
            return;
        }

        if (kind == StandardWatchEventKinds.ENTRY_MODIFY ||
                kind == StandardWatchEventKinds.ENTRY_CREATE) {
            synchronized (lock) {
                if (scheduledReloadTask != null && !scheduledReloadTask.isDone()) {
                    scheduledReloadTask.cancel(false);
                }
                scheduledReloadTask = scheduler.schedule(() -> {
                    try {
                        loadConfig();
                        LOGGER.info("配置文件已重新加载");
                    } catch (Exception e) {
                        LOGGER.error("重新加载配置失败", e);
                    }
                }, DEBOUNCE_DELAY_SECONDS, TimeUnit.SECONDS);
            }
        }
    }

    private void loadConfig() {
        synchronized (lock) {
            try {
                Properties properties = new Properties();
                String configFilePath = ConfigUtils.getCustomizedConfigPath();
                Path configPath = Paths.get(configFilePath);
                if (!Files.exists(configPath)) {
                    LOGGER.warn("配置文件不存在: {}", configFilePath);
                    return;
                }

                try (BufferedReader bufferedReader = new BufferedReader(new FileReader(configFilePath))) {
                    properties.load(bufferedReader);
                    ConfigUtils.restorePropertiesFromEnvFormat(properties);
                    updateConfigConstants(properties);
                    setWatermarkConfig(properties);
                    LOGGER.info("配置文件重新加载完成");
                }
            } catch (IOException e) {
                LOGGER.error("读取配置文件异常", e);
            }
        }
    }

    private void updateConfigConstants(Properties properties) {
        // 1. 缓存配置
        boolean cacheEnabled = Boolean.parseBoolean(getProperty(properties, "cache.enabled", ConfigConstants.DEFAULT_CACHE_ENABLED));
        ConfigConstants.setCacheEnabledValueValue(cacheEnabled);

        // 2. 文件类型配置
        ConfigConstants.setSimTextValue(getProperty(properties, "simText", ConfigConstants.DEFAULT_TXT_TYPE).split(","));
        ConfigConstants.setMediaValue(getProperty(properties, "media", ConfigConstants.DEFAULT_MEDIA_TYPE).split(","));
        ConfigConstants.setConvertMediaValue(getProperty(properties, "convertMedias", "avi,mov,wmv,mkv,3gp,rm").split(","));
        ConfigConstants.setProhibitValue(getProperty(properties, "prohibit", ConfigConstants.DEFAULT_PROHIBIT).split(","));
        ConfigConstants.setMediaConvertDisableValue(getProperty(properties, "media.convert.disable", "true"));
        ConfigConstants.setTifPreviewTypeValue(getProperty(properties, "tif.preview.type", ConfigConstants.DEFAULT_TIF_PREVIEW_TYPE));
        ConfigConstants.setCadPreviewTypeValue(getProperty(properties, "cad.preview.type", ConfigConstants.DEFAULT_CAD_PREVIEW_TYPE));

        // 3. Office配置
        ConfigConstants.setOfficePreviewTypeValue(getProperty(properties, "office.preview.type", ConfigConstants.DEFAULT_OFFICE_PREVIEW_TYPE));
        ConfigConstants.setOfficePreviewSwitchDisabledValue(getProperty(properties, "office.preview.switch.disabled", ConfigConstants.DEFAULT_OFFICE_PREVIEW_SWITCH_DISABLED));
        ConfigConstants.setOfficeTypeWebValue(getProperty(properties, "office.type.web", ConfigConstants.DEFAULT_OFFICE_TYPE_WEB));
        ConfigConstants.setOfficePageRangeValue(getProperty(properties, "office.pagerange", ConfigConstants.DEFAULT_OFFICE_PAQERANQE));
        ConfigConstants.setOfficeWatermarkValue(getProperty(properties, "office.watermark", ConfigConstants.DEFAULT_OFFICE_WATERMARK));
        ConfigConstants.setOfficeQualityValue(getProperty(properties, "office.quality", ConfigConstants.DEFAULT_OFFICE_QUALITY));
        ConfigConstants.setOfficeMaxImageResolutionValue(getProperty(properties, "office.maximageresolution", ConfigConstants.DEFAULT_OFFICE_MAXIMAQERESOLUTION));
        ConfigConstants.setOfficeExportBookmarksValue(Boolean.parseBoolean(getProperty(properties, "office.exportbookmarks", ConfigConstants.DEFAULT_OFFICE_EXPORTBOOKMARKS)));
        ConfigConstants.setOfficeExportNotesValue(Boolean.parseBoolean(getProperty(properties, "office.exportnotes", ConfigConstants.DEFAULT_OFFICE_EXPORTNOTES)));
        ConfigConstants.setOfficeDocumentOpenPasswordsValue(Boolean.parseBoolean(getProperty(properties, "office.documentopenpasswords", ConfigConstants.DEFAULT_OFFICE_EOCUMENTOPENPASSWORDS)));

        // 4. FTP配置
        ConfigConstants.setFtpUsernameValue(getProperty(properties, "ftp.username", ConfigConstants.DEFAULT_FTP_USERNAME));

        // 5. 路径配置
        ConfigConstants.setBaseUrlValue(getProperty(properties, "base.url", ConfigConstants.DEFAULT_VALUE));
        ConfigConstants.setFileDirValue(getProperty(properties, "file.dir", ConfigConstants.DEFAULT_VALUE));
        ConfigConstants.setLocalPreviewDirValue(getProperty(properties, "local.preview.dir", ConfigConstants.DEFAULT_VALUE));

        // 6. 安全配置
        ConfigConstants.setTrustHostValue(getProperty(properties, "trust.host", ConfigConstants.DEFAULT_VALUE));
        ConfigConstants.setNotTrustHostValue(getProperty(properties, "not.trust.host", ConfigConstants.DEFAULT_VALUE));

        // 7. PDF配置
        ConfigConstants.setPdfPresentationModeDisableValue(getProperty(properties, "pdf.presentationMode.disable", ConfigConstants.DEFAULT_PDF_PRESENTATION_MODE_DISABLE));
        ConfigConstants.setPdfOpenFileDisableValue(getProperty(properties, "pdf.openFile.disable", ConfigConstants.DEFAULT_PDF_OPEN_FILE_DISABLE));
        ConfigConstants.setPdfPrintDisableValue(getProperty(properties, "pdf.print.disable", ConfigConstants.DEFAULT_PDF_PRINT_DISABLE));
        ConfigConstants.setPdfDownloadDisableValue(getProperty(properties, "pdf.download.disable", ConfigConstants.DEFAULT_PDF_DOWNLOAD_DISABLE));
        ConfigConstants.setPdfBookmarkDisableValue(getProperty(properties, "pdf.bookmark.disable", ConfigConstants.DEFAULT_PDF_BOOKMARK_DISABLE));
        ConfigConstants.setPdfDisableEditingValue(getProperty(properties, "pdf.disable.editing", ConfigConstants.DEFAULT_PDF_DISABLE_EDITING));
        ConfigConstants.setPdfSidebarOpenValue(getProperty(properties, "pdf.sidebar.open", ConfigConstants.DEFAULT_PDF_SIDEBAR_OPEN));
        ConfigConstants.setPdf2JpgDpiValue(Integer.parseInt(getProperty(properties, "pdf2jpg.dpi", ConfigConstants.DEFAULT_PDF2_JPG_DPI)));

        // 8. CAD配置
        ConfigConstants.setCadTimeoutValue(getProperty(properties, "cad.timeout", ConfigConstants.DEFAULT_CAD_TIMEOUT));
        ConfigConstants.setCadThreadValue(Integer.parseInt(getProperty(properties, "cad.thread", ConfigConstants.DEFAULT_CAD_THREAD)));
        ConfigConstants.setCadConverterPathValue(getProperty(properties, "cad.cadconverterpath", ConfigConstants.DEFAULT_CAD_CONVERT));
        ConfigConstants.setconversionModuleValue(Integer.parseInt(getProperty(properties, "cad.conversionmodule", ConfigConstants.DEFAULT_CAD_VERSION)));

        // 9. TIF配置
        ConfigConstants.setTifTimeoutValue(getProperty(properties, "tif.timeout", ConfigConstants.DEFAULT_TIF_TIMEOUT));
        ConfigConstants.setTifThreadValue(Integer.parseInt(getProperty(properties, "tif.thread", ConfigConstants.DEFAULT_TIF_THREAD)));

        // 10. 文件操作配置
        ConfigConstants.setFileUploadDisableValue(Boolean.parseBoolean(getProperty(properties, "file.upload.disable", ConfigConstants.DEFAULT_FILE_UPLOAD_DISABLE)));
        ConfigConstants.setSizeValue(getProperty(properties, "spring.servlet.multipart.max-file-size", ConfigConstants.DEFAULT_SIZE));
        ConfigConstants.setPasswordValue(getProperty(properties, "delete.password", ConfigConstants.DEFAULT_PASSWORD));
        ConfigConstants.setDeleteSourceFileValue(Boolean.parseBoolean(getProperty(properties, "delete.source.file", ConfigConstants.DEFAULT_DELETE_SOURCE_FILE)));
        ConfigConstants.setDeleteCaptchaValue(Boolean.parseBoolean(getProperty(properties, "delete.captcha", ConfigConstants.DEFAULT_DELETE_CAPTCHA)));

        // 11. 首页配置
        ConfigConstants.setBeianValue(getProperty(properties, "beian", ConfigConstants.DEFAULT_BEIAN));
        ConfigConstants.setHomePageNumberValue(getProperty(properties, "home.pagenumber", ConfigConstants.DEFAULT_HOME_PAGENUMBER));
        ConfigConstants.setHomePaginationValue(getProperty(properties, "home.pagination", ConfigConstants.DEFAULT_HOME_PAGINATION));
        ConfigConstants.setHomePageSizeValue(getProperty(properties, "home.pagesize", ConfigConstants.DEFAULT_HOME_PAGSIZE));
        ConfigConstants.setHomeSearchValue(getProperty(properties, "home.search", ConfigConstants.DEFAULT_HOME_SEARCH));

        // 12. 权限配置
        ConfigConstants.setKeyValue(getProperty(properties, "kk.key", ConfigConstants.DEFAULT_KEY));
        ConfigConstants.setPicturesPreviewValue(Boolean.parseBoolean(getProperty(properties, "kk.Picturespreview", ConfigConstants.DEFAULT_PICTURES_PREVIEW)));
        ConfigConstants.setGetCorsFileValue(Boolean.parseBoolean(getProperty(properties, "kk.Getcorsfile", ConfigConstants.DEFAULT_GET_CORS_FILE)));
        ConfigConstants.setAddTaskValue(Boolean.parseBoolean(getProperty(properties, "kk.addTask", ConfigConstants.DEFAULT_ADD_TASK)));
        ConfigConstants.setaesKeyValue(getProperty(properties, "aes.key", ConfigConstants.DEFAULT_AES_KEY));

        // 13. UserAgent配置
        ConfigConstants.setUserAgentValue(getProperty(properties, "useragent", ConfigConstants.DEFAULT_USER_AGENT));

        // 14. Basic认证配置
        ConfigConstants.setBasicNameValue(getProperty(properties, "basic.name", ConfigConstants.DEFAULT_BASIC_NAME));

        // 15. 视频转换配置
        ConfigConstants.setMediaConvertMaxSizeValue(Integer.parseInt(getProperty(properties, "media.convert.max.size", ConfigConstants.DEFAULT_MEDIA_CONVERT_MAX_SIZE)));
        ConfigConstants.setMediaTimeoutEnabledValue(Boolean.parseBoolean(getProperty(properties, "media.timeout.enabled", ConfigConstants.DEFAULT_MEDIA_TIMEOUT_ENABLED)));
        ConfigConstants.setMediaSmallFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.small.file.timeout", ConfigConstants.DEFAULT_MEDIA_SMALL_FILE_TIMEOUT)));
        ConfigConstants.setMediaMediumFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.medium.file.timeout", ConfigConstants.DEFAULT_MEDIA_MEDIUM_FILE_TIMEOUT)));
        ConfigConstants.setMediaLargeFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.large.file.timeout", ConfigConstants.DEFAULT_MEDIA_LARGE_FILE_TIMEOUT)));
        ConfigConstants.setMediaXLFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.xl.file.timeout", ConfigConstants.DEFAULT_MEDIA_XL_FILE_TIMEOUT)));
        ConfigConstants.setMediaXXLFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.xxl.file.timeout", ConfigConstants.DEFAULT_MEDIA_XXL_FILE_TIMEOUT)));
        ConfigConstants.setMediaXXXLFileTimeoutValue(Integer.parseInt(getProperty(properties, "media.xxxl.file.timeout", ConfigConstants.DEFAULT_MEDIA_XXXL_FILE_TIMEOUT)));

        // 16. PDF DPI配置
        ConfigConstants.setPdfDpiEnabledValue(Boolean.parseBoolean(getProperty(properties, "pdf.dpi.enabled", ConfigConstants.DEFAULT_PDF_DPI_ENABLED)));
        ConfigConstants.setPdfSmallDpiValue(Integer.parseInt(getProperty(properties, "pdf.dpi.small", ConfigConstants.DEFAULT_PDF_SMALL_DTI)));
        ConfigConstants.setPdfMediumDpiValue(Integer.parseInt(getProperty(properties, "pdf.dpi.medium", ConfigConstants.DEFAULT_PDF_MEDIUM_DPI)));
        ConfigConstants.setPdfLargeDpiValue(Integer.parseInt(getProperty(properties, "pdf.dpi.large", ConfigConstants.DEFAULT_PDF_LARGE_DPI)));
        ConfigConstants.setPdfXLargeDpiValue(Integer.parseInt(getProperty(properties, "pdf.dpi.xlarge", ConfigConstants.DEFAULT_PDF_XLARGE_DPI)));
        ConfigConstants.setPdfXXLargeDpiValue(Integer.parseInt(getProperty(properties, "pdf.dpi.xxlarge", ConfigConstants.DEFAULT_PDF_XXLARGE_DPI)));

        // 17. PDF超时配置（新）
        ConfigConstants.setPdfTimeoutSmallValue(Integer.parseInt(getProperty(properties, "pdf.timeout.small", ConfigConstants.DEFAULT_PDF_TIMEOUT_SMALL)));
        ConfigConstants.setPdfTimeoutMediumValue(Integer.parseInt(getProperty(properties, "pdf.timeout.medium", ConfigConstants.DEFAULT_PDF_TIMEOUT_MEDIUM)));
        ConfigConstants.setPdfTimeoutLargeValue(Integer.parseInt(getProperty(properties, "pdf.timeout.large", ConfigConstants.DEFAULT_PDF_TIMEOUT_LARGE)));
        ConfigConstants.setPdfTimeoutXLargeValue(Integer.parseInt(getProperty(properties, "pdf.timeout.xlarge", ConfigConstants.DEFAULT_PDF_TIMEOUT_XLARGE)));

        // 18. PDF线程配置
        ConfigConstants.setPdfMaxThreadsValue(Integer.parseInt(getProperty(properties, "pdf.max.threads", ConfigConstants.DEFAULT_PDF_MAX_THREADS)));

        // 19. CAD水印配置
        ConfigConstants.setCadwatermarkValue(Boolean.parseBoolean(getProperty(properties, "cad.watermark", ConfigConstants.DEFAULT_CAD_WATERMARK)));

        // 20. SSL忽略配置
        ConfigConstants.setIgnoreSSLValue(Boolean.parseBoolean(getProperty(properties, "kk.ignore.ssl", ConfigConstants.DEFAULT_IGNORE_SSL)));

        // 21. 重定向启用配置
        ConfigConstants.setEnableRedirectValue(Boolean.parseBoolean(getProperty(properties, "kk.enable.redirect", ConfigConstants.DEFAULT_ENABLE_REDIRECT)));

        // 22. 异步定时刷新
        ConfigConstants.setRefreshScheduleValue(Integer.parseInt(getProperty(properties, "kk.refreshschedule", ConfigConstants.DEFAULT_ENABLE_REFRECSHSCHEDULE)));

        // 23. 其他配置
        ConfigConstants.setIsShowaesKeyValue(Boolean.parseBoolean(getProperty(properties, "kk.isshowaeskey", ConfigConstants.DEFAULT_SHOW_AES_KEY)));
        ConfigConstants.setIsJavaScriptValue(Boolean.parseBoolean(getProperty(properties, "kk.isjavascript", ConfigConstants.DEFAULT_IS_JAVASCRIPT)));
        ConfigConstants.setXlsxAllowEditValue(Boolean.parseBoolean(getProperty(properties, "kk.xlsxallowedit", ConfigConstants.DEFAULT_XLSX_ALLOW_EDIT)));
        ConfigConstants.setXlsxShowtoolbarValue(Boolean.parseBoolean(getProperty(properties, "kk.xlsxshowtoolbar", ConfigConstants.DEFAULT_XLSX_SHOW_TOOLBAR)));
        ConfigConstants.setisShowKeyValue(Boolean.parseBoolean(getProperty(properties, "kk.isshowkey", ConfigConstants.DEFAULT_IS_SHOW_KEY)));
        ConfigConstants.setscriptJsValue(Boolean.parseBoolean(getProperty(properties, "kk.scriptjs", ConfigConstants.DEFAULT_SCRIPT_JS)));
    }

    private String getProperty(Properties properties, String key, String defaultValue) {
        return properties.getProperty(key, defaultValue).trim();
    }

    private void setWatermarkConfig(Properties properties) {
        WatermarkConfigConstants.setWatermarkTxtValue(getProperty(properties, "watermark.txt", WatermarkConfigConstants.DEFAULT_WATERMARK_TXT));
        WatermarkConfigConstants.setWatermarkXSpaceValue(getProperty(properties, "watermark.x.space", WatermarkConfigConstants.DEFAULT_WATERMARK_X_SPACE));
        WatermarkConfigConstants.setWatermarkYSpaceValue(getProperty(properties, "watermark.y.space", WatermarkConfigConstants.DEFAULT_WATERMARK_Y_SPACE));
        WatermarkConfigConstants.setWatermarkFontValue(getProperty(properties, "watermark.font", WatermarkConfigConstants.DEFAULT_WATERMARK_FONT));
        WatermarkConfigConstants.setWatermarkFontsizeValue(getProperty(properties, "watermark.fontsize", WatermarkConfigConstants.DEFAULT_WATERMARK_FONTSIZE));
        WatermarkConfigConstants.setWatermarkColorValue(getProperty(properties, "watermark.color", WatermarkConfigConstants.DEFAULT_WATERMARK_COLOR));
        WatermarkConfigConstants.setWatermarkAlphaValue(getProperty(properties, "watermark.alpha", WatermarkConfigConstants.DEFAULT_WATERMARK_ALPHA));
        WatermarkConfigConstants.setWatermarkWidthValue(getProperty(properties, "watermark.width", WatermarkConfigConstants.DEFAULT_WATERMARK_WIDTH));
        WatermarkConfigConstants.setWatermarkHeightValue(getProperty(properties, "watermark.height", WatermarkConfigConstants.DEFAULT_WATERMARK_HEIGHT));
        WatermarkConfigConstants.setWatermarkAngleValue(getProperty(properties, "watermark.angle", WatermarkConfigConstants.DEFAULT_WATERMARK_ANGLE));
    }
}
