package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.service.OfficeToPdfService;
import cn.keking.service.PdfToJpgService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.ui.ExtendedModelMap;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.nio.file.Path;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.timeout;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * kkFileView #754 回归测试：Office 文件先用 PDF 方式预览，再切换为图片方式预览，不应提示
 * 「Office转换缓存异常，请联系管理员」。
 *
 * 根因：PDF 方式与图片方式共用同一个 cacheName（转换出的 PDF 文件名）。PDF 方式转换完成后会把
 * cacheName 记入已转换文件缓存，此时图片还没有生成；图片方式只判断 cacheName 是否已在缓存中，
 * 命中后直接读取图片缓存，读到空列表就报缓存异常。修复后图片缓存不存在时按未转换处理。
 */
class OfficeImagePreviewAfterPdfTests {

    private static final String FILE_NAME = "issue-754-sample.docx";
    private static final String CACHE_NAME = "issue-754-sampledocx.pdf";

    @TempDir
    Path temp;
    private String previousDir;
    private Boolean previousCache;
    private String previousOfficeTypeWeb;
    private String outFilePath;
    private FileHandlerService fileHandlerService;
    private OfficeToPdfService officeToPdfService;
    private PdfToJpgService pdfToJpgService;
    private OfficeFilePreviewImpl officeFilePreview;

    @BeforeEach
    void setUp() {
        previousDir = ConfigConstants.getFileDir();
        previousCache = ConfigConstants.isCacheEnabled();
        previousOfficeTypeWeb = ConfigConstants.getOfficeTypeWeb();
        ConfigConstants.setFileDirValue(temp.toString());
        ConfigConstants.setCacheEnabledValueValue(true);
        ConfigConstants.setOfficeTypeWebValue("web");
        outFilePath = ConfigConstants.getFileDir() + CACHE_NAME;

        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setAttribute("baseUrl", "http://127.0.0.1:8012/");
        RequestContextHolder.setRequestAttributes(new ServletRequestAttributes(request));

        fileHandlerService = mock(FileHandlerService.class);
        officeToPdfService = mock(OfficeToPdfService.class);
        pdfToJpgService = mock(PdfToJpgService.class);
        // PDF 方式已经预览过：转换出的 PDF 已记入已转换文件缓存
        when(fileHandlerService.listConvertedFiles()).thenReturn(Map.of(CACHE_NAME, CACHE_NAME));
        officeFilePreview = new OfficeFilePreviewImpl(fileHandlerService, officeToPdfService,
                new OtherFilePreviewImpl(), pdfToJpgService);
    }

    @AfterEach
    void tearDown() {
        RequestContextHolder.resetRequestAttributes();
        ConfigConstants.setFileDirValue(previousDir);
        ConfigConstants.setCacheEnabledValueValue(previousCache);
        ConfigConstants.setOfficeTypeWebValue(previousOfficeTypeWeb);
    }

    @Test
    void shouldConvertToImagesWhenOnlyThePdfIsCached() throws Exception {
        when(fileHandlerService.loadPdf2jpgCache(outFilePath)).thenReturn(List.of());
        FileAttribute fileAttribute = imagePreviewOf();
        ExtendedModelMap model = new ExtendedModelMap();

        String page = officeFilePreview.filePreviewHandle(fileAttribute.getUrl(), model, fileAttribute);

        // 修复前这里返回 fileNotSupported，msg 为「Office转换缓存异常，请联系管理员」
        assertEquals(FilePreview.WAITING_FILE_PREVIEW_PAGE, page,
                () -> "image preview after a PDF preview must start the image conversion (see #754), msg: "
                        + model.get("msg"));
        verify(pdfToJpgService, timeout(10_000)).pdf2jpg(outFilePath, outFilePath, fileAttribute);
        verify(fileHandlerService, timeout(10_000)).addConvertedFile(any(), any());
    }

    /**
     * 对照：图片缓存已存在时直接渲染图片预览页，不重新转换。
     */
    @Test
    void shouldRenderCachedImagesWithoutConvertingAgain() throws Exception {
        when(fileHandlerService.loadPdf2jpgCache(outFilePath))
                .thenReturn(List.of("http://127.0.0.1:8012/issue-754-sampledocx/0.jpg"));
        FileAttribute fileAttribute = imagePreviewOf();
        ExtendedModelMap model = new ExtendedModelMap();

        String page = officeFilePreview.filePreviewHandle(fileAttribute.getUrl(), model, fileAttribute);

        assertEquals(FilePreview.OFFICE_PICTURE_FILE_PREVIEW_PAGE, page);
        verify(officeToPdfService, never()).openOfficeToPDF(anyString(), anyString(), any());
        verify(pdfToJpgService, never()).pdf2jpg(anyString(), anyString(), any());
    }

    /**
     * 对照：加密文档的图片保存在单独的缓存里，该缓存存在时同样直接渲染，不重新转换。
     */
    @Test
    void shouldRenderEncryptedImageCacheWithoutConvertingAgain() throws Exception {
        when(fileHandlerService.loadPdf2jpgCache(outFilePath)).thenReturn(List.of());
        when(pdfToJpgService.hasEncryptedPdfCacheSimple(outFilePath)).thenReturn(true);
        when(pdfToJpgService.getEncryptedPdfCache(outFilePath))
                .thenReturn(List.of("http://127.0.0.1:8012/issue-754-sampledocx/0.jpg"));
        FileAttribute fileAttribute = imagePreviewOf();
        ExtendedModelMap model = new ExtendedModelMap();

        String page = officeFilePreview.filePreviewHandle(fileAttribute.getUrl(), model, fileAttribute);

        assertEquals(FilePreview.OFFICE_PICTURE_FILE_PREVIEW_PAGE, page);
        verify(officeToPdfService, never()).openOfficeToPDF(anyString(), anyString(), any());
        verify(pdfToJpgService, never()).pdf2jpg(anyString(), anyString(), any());
    }

    private FileAttribute imagePreviewOf() {
        FileAttribute fileAttribute = new FileAttribute(FileType.OFFICE, "docx", FILE_NAME,
                "http://127.0.0.1:8012/demo/" + FILE_NAME, OfficeFilePreviewImpl.OFFICE_PREVIEW_TYPE_IMAGE);
        fileAttribute.setCacheName(CACHE_NAME);
        fileAttribute.setOutFilePath(outFilePath);
        // 源文件的获取不在本测试范围内
        fileAttribute.setSkipDownLoad(true);
        return fileAttribute;
    }
}
