package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import cn.keking.service.cache.NotResourceCache;
import cn.keking.utils.EncodingDetects;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.UrlEncoderUtils;
import cn.keking.utils.WebUtils;
import cn.keking.web.filter.BaseUrlFilter;
import com.aspose.cad.*;
import com.aspose.cad.fileformats.cad.CadDrawTypeMode;
import com.aspose.cad.fileformats.tiff.enums.TiffExpectedFormat;
import com.aspose.cad.imageoptions.*;
import com.aspose.cad.internal.Exceptions.TimeoutException;
import com.itextpdf.text.pdf.PdfReader;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;
import org.apache.poi.EncryptedDocumentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.*;
import java.util.stream.IntStream;

/**
 * @author yudian-it
 * @date 2017/11/13
 */
@Component
@DependsOn(ConfigConstants.BEAN_NAME)
public class FileHandlerService implements InitializingBean {

    private static final String PDF2JPG_IMAGE_FORMAT = ".jpg";
    private static final String PDF_PASSWORD_MSG = "password";
    private final Logger logger = LoggerFactory.getLogger(FileHandlerService.class);
    private final String fileDir = ConfigConstants.getFileDir();
    private final CacheService cacheService;
    @Value("${server.tomcat.uri-encoding:UTF-8}")
    private String uriEncoding;

    public FileHandlerService(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    /**
     * @return 已转换过的文件集合(缓存)
     */
    public Map<String, String> listConvertedFiles() {
        return cacheService.getPDFCache();
    }

    /**
     * @return 已转换过的文件，根据文件名获取
     */
    public String getConvertedFile(String key) {
        return cacheService.getPDFCache(key);
    }

    /**
     * @param key pdf本地路径
     * @return 已将pdf转换成图片的图片本地相对路径
     */
    public Integer getPdf2jpgCache(String key) {
        return cacheService.getPdfImageCache(key);
    }


    /**
     * 从路径中获取文件负
     *
     * @param path 类似这种：C:\Users\yudian-it\Downloads
     * @return 文件名
     */
    public String getFileNameFromPath(String path) {
        return path.substring(path.lastIndexOf(File.separator) + 1);
    }

    /**
     * 获取相对路径
     *
     * @param absolutePath 绝对路径
     * @return 相对路径
     */
    public String getRelativePath(String absolutePath) {
        return absolutePath.substring(fileDir.length());
    }

    /**
     * 添加转换后PDF缓存
     *
     * @param fileName pdf文件名
     * @param value    缓存相对路径
     */
    public void addConvertedFile(String fileName, String value) {
        cacheService.putPDFCache(fileName, value);
    }

    /**
     * 添加转换后图片组缓存
     *
     * @param pdfFilePath pdf文件绝对路径
     * @param num         图片张数
     */
    public void addPdf2jpgCache(String pdfFilePath, int num) {
        cacheService.putPdfImageCache(pdfFilePath, num);
    }

    /**
     * 获取redis中压缩包内图片文件
     *
     * @param compressFileKey compressFileKey
     * @return 图片文件访问url列表
     */
    public List<String> getImgCache(String compressFileKey) {
        return cacheService.getImgCache(compressFileKey);
    }

    /**
     * 设置redis中压缩包内图片文件
     *
     * @param fileKey fileKey
     * @param imgs    图片文件访问url列表
     */
    public void putImgCache(String fileKey, List<String> imgs) {
        cacheService.putImgCache(fileKey, imgs);
    }

    /**
     * cad定义线程池
     */
    private ExecutorService pool = null;

    @Override
    public void afterPropertiesSet() throws Exception {
        pool = Executors.newFixedThreadPool(ConfigConstants.getCadThread());
    }

    /**
     * 对转换后的文件进行操作(改变编码方式)
     *
     * @param outFilePath 文件绝对路径
     */
    public void doActionConvertedFile(String outFilePath) {
        String charset = EncodingDetects.getJavaEncode(outFilePath);
        StringBuilder sb = new StringBuilder();
        try (InputStream inputStream = new FileInputStream(outFilePath); BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, charset))) {
            String line;
            while (null != (line = reader.readLine())) {
                if (line.contains("charset=gb2312")) {
                    line = line.replace("charset=gb2312", "charset=utf-8");
                }
                sb.append(line);
            }
            // 添加sheet控制头
            sb.append("<script src=\"js/jquery-3.6.1.min.js\" type=\"text/javascript\"></script>");
            sb.append("<script src=\"excel/excel.header.js\" type=\"text/javascript\"></script>");
            sb.append("<link rel=\"stylesheet\" href=\"excel/excel.css\">");
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 重新写入文件
        try (FileOutputStream fos = new FileOutputStream(outFilePath); BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, StandardCharsets.UTF_8))) {
            writer.write(sb.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取本地 pdf 转 image 后的 web 访问地址
     *
     * @param pdfFilePath pdf文件名
     * @param index       图片索引
     * @return 图片访问地址
     */
    private String getPdf2jpgUrl(String pdfFilePath, int index) {
        String baseUrl = BaseUrlFilter.getBaseUrl();
        pdfFilePath = pdfFilePath.replace(fileDir, "");
        String pdfFolder = pdfFilePath.substring(0, pdfFilePath.length() - 4);
        String urlPrefix;
        try {
            urlPrefix = baseUrl + URLEncoder.encode(pdfFolder, uriEncoding).replaceAll("\\+", "%20");
        } catch (UnsupportedEncodingException e) {
            logger.error("UnsupportedEncodingException", e);
            urlPrefix = baseUrl + pdfFolder;
        }
        return urlPrefix + "/" + index + PDF2JPG_IMAGE_FORMAT;
    }

    /**
     * 获取缓存中的 pdf 转换成 jpg 图片集
     *
     * @param pdfFilePath pdf文件路径
     * @return 图片访问集合
     */
    private List<String> loadPdf2jpgCache(String pdfFilePath) {
        List<String> imageUrls = new ArrayList<>();
        Integer imageCount = this.getPdf2jpgCache(pdfFilePath);
        if (Objects.isNull(imageCount)) {
            return imageUrls;
        }
        IntStream.range(0, imageCount).forEach(i -> {
            String imageUrl = this.getPdf2jpgUrl(pdfFilePath, i);
            imageUrls.add(imageUrl);
        });
        return imageUrls;
    }

    /**
     * pdf文件转换成jpg图片集
     * fileNameFilePath pdf文件路径
     * pdfFilePath pdf输出文件路径
     * pdfName     pdf文件名称
     * loadPdf2jpgCache 图片访问集合
     */
    public List<String> pdf2jpg(String fileNameFilePath, String pdfFilePath, String pdfName, FileAttribute fileAttribute) throws Exception {
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        boolean usePasswordCache = fileAttribute.getUsePasswordCache();
        String filePassword = fileAttribute.getFilePassword();
        String pdfPassword = null;
        PDDocument doc = null;
        PdfReader pdfReader = null;
        if (!forceUpdatedCache) {
            List<String> cacheResult = this.loadPdf2jpgCache(pdfFilePath);
            if (!CollectionUtils.isEmpty(cacheResult)) {
                return cacheResult;
            }
        }
        List<String> imageUrls = new ArrayList<>();
        try {
            File pdfFile = new File(fileNameFilePath);
            if (!pdfFile.exists()) {
                return null;
            }
            doc = PDDocument.load(pdfFile, filePassword);
            doc.setResourceCache(new NotResourceCache());
            int pageCount = doc.getNumberOfPages();
            PDFRenderer pdfRenderer = new PDFRenderer(doc);
            int index = pdfFilePath.lastIndexOf(".");
            String folder = pdfFilePath.substring(0, index);
            File path = new File(folder);
            if (!path.exists() && !path.mkdirs()) {
                logger.error("创建转换文件【{}】目录失败，请检查目录权限！", folder);
            }
            String imageFilePath;
            for (int pageIndex = 0; pageIndex < pageCount; pageIndex++) {
                imageFilePath = folder + File.separator + pageIndex + PDF2JPG_IMAGE_FORMAT;
                BufferedImage image = pdfRenderer.renderImageWithDPI(pageIndex, ConfigConstants.getPdf2JpgDpi(), ImageType.RGB);
                ImageIOUtil.writeImage(image, imageFilePath, ConfigConstants.getPdf2JpgDpi());
                String imageUrl = this.getPdf2jpgUrl(pdfFilePath, pageIndex);
                imageUrls.add(imageUrl);
            }
            try {
                if (!ObjectUtils.isEmpty(filePassword)) {  //获取到密码 判断是否是加密文件
                    pdfReader = new PdfReader(fileNameFilePath);   //读取PDF文件 通过异常获取该文件是否有密码字符
                }
            } catch (Exception e) {  //获取异常方法 判断是否有加密字符串
                Throwable[] throwableArray = ExceptionUtils.getThrowables(e);
                for (Throwable throwable : throwableArray) {
                    if (throwable instanceof IOException || throwable instanceof EncryptedDocumentException) {
                        if (e.getMessage().toLowerCase().contains(PDF_PASSWORD_MSG)) {
                            pdfPassword = PDF_PASSWORD_MSG;  //查询到该文件是密码文件 输出带密码的值
                        }
                    }
                }
                if (!PDF_PASSWORD_MSG.equals(pdfPassword)) {  //该文件异常 错误原因非密码原因输出错误
                    logger.error("Convert pdf exception, pdfFilePath：{}", pdfFilePath, e);
                }

            } finally {
                if (pdfReader != null) {   //关闭
                    pdfReader.close();
                }
            }

            if (usePasswordCache || !PDF_PASSWORD_MSG.equals(pdfPassword)) {   //加密文件  判断是否启用缓存命令
                this.addPdf2jpgCache(pdfFilePath, pageCount);
            }
        } catch (IOException e) {
            if (!e.getMessage().contains(PDF_PASSWORD_MSG)) {
                logger.error("Convert pdf to jpg exception, pdfFilePath：{}", pdfFilePath, e);
            }
            throw new Exception(e);
        } finally {
            if (doc != null) {   //关闭
                doc.close();
            }
        }
        return imageUrls;
    }

    /**
     * cad文件转pdf
     *
     * @param inputFilePath  cad文件路径
     * @param outputFilePath pdf输出文件路径
     * @return 转换是否成功
     */
    public String cadToPdf(String inputFilePath, String outputFilePath, String cadPreviewType, FileAttribute fileAttribute) throws Exception {
        final InterruptionTokenSource source = new InterruptionTokenSource();//CAD延时
        if (fileAttribute.isCompressFile()) { //判断 是压缩包的创建新的目录
            int index = outputFilePath.lastIndexOf("/");  //截取最后一个斜杠的前面的内容
            String folder = outputFilePath.substring(0, index);
            File path = new File(folder);
            //目录不存在 创建新的目录
            if (!path.exists()) {
                path.mkdirs();
            }
        }
        Callable<String> call = () -> {
            File outputFile = new File(outputFilePath);
            LoadOptions opts = new LoadOptions();
            opts.setSpecifiedEncoding(CodePages.SimpChinese);
            Image cadImage = Image.load(inputFilePath, opts);
            RasterizationQuality rasterizationQuality = new RasterizationQuality();
            rasterizationQuality.setArc(RasterizationQualityValue.High);
            rasterizationQuality.setHatch(RasterizationQualityValue.High);
            rasterizationQuality.setText(RasterizationQualityValue.High);
            rasterizationQuality.setOle(RasterizationQualityValue.High);
            rasterizationQuality.setObjectsPrecision(RasterizationQualityValue.High);
            rasterizationQuality.setTextThicknessNormalization(true);
            CadRasterizationOptions cadRasterizationOptions = new CadRasterizationOptions();
            cadRasterizationOptions.setBackgroundColor(Color.getWhite());
            cadRasterizationOptions.setPageWidth(cadImage.getWidth());
            cadRasterizationOptions.setPageHeight(cadImage.getHeight());
            cadRasterizationOptions.setUnitType(cadImage.getUnitType());
            cadRasterizationOptions.setAutomaticLayoutsScaling(false);
            cadRasterizationOptions.setNoScaling(false);
            cadRasterizationOptions.setQuality(rasterizationQuality);
            cadRasterizationOptions.setDrawType(CadDrawTypeMode.UseObjectColor);
            cadRasterizationOptions.setExportAllLayoutContent(true);
            cadRasterizationOptions.setVisibilityMode(VisibilityMode.AsScreen);
            SvgOptions SvgOptions = null;
            PdfOptions pdfOptions = null;
            TiffOptions TiffOptions = null;
            switch (cadPreviewType) {  //新增格式方法
                case "svg":
                    SvgOptions = new SvgOptions();
                    SvgOptions.setVectorRasterizationOptions(cadRasterizationOptions);
                    SvgOptions.setInterruptionToken(source.getToken());
                    break;
                case "pdf":
                    pdfOptions = new PdfOptions();
                    pdfOptions.setVectorRasterizationOptions(cadRasterizationOptions);
                    pdfOptions.setInterruptionToken(source.getToken());
                    break;
                case "tif":
                    TiffOptions = new TiffOptions(TiffExpectedFormat.TiffJpegRgb);
                    TiffOptions.setVectorRasterizationOptions(cadRasterizationOptions);
                    TiffOptions.setInterruptionToken(source.getToken());
                    break;
            }
            try (OutputStream stream = new FileOutputStream(outputFile)) {
                switch (cadPreviewType) {
                    case "svg":
                        cadImage.save(stream, SvgOptions);
                        break;
                    case "pdf":
                        cadImage.save(stream, pdfOptions);
                        break;
                    case "tif":
                        cadImage.save(stream, TiffOptions);
                        break;
                }
            } catch (IOException e) {
                logger.error("PDFFileNotFoundException，inputFilePath：{}", inputFilePath, e);
                return null;
            } finally {
                //关闭
                if (cadImage != null) {   //关闭
                    cadImage.dispose();
                }
                source.interrupt();  //结束任务
            }
            return "true";
        };
        Future<String> result = pool.submit(call);
        try {
            // 如果在超时时间内，没有数据返回：则抛出TimeoutException异常
            result.get(Long.parseLong(ConfigConstants.getCadTimeout()), TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            System.out.println("InterruptedException发生");
            return null;
        } catch (ExecutionException e) {
            System.out.println("ExecutionException发生");
            return null;
        } catch (TimeoutException e) {
            System.out.println("TimeoutException发生，意味着线程超时报错");
            return null;
        } finally {
            source.dispose();
        }
        return "true";
    }

    /**
     * @param str    原字符串（待截取原串）
     * @param posStr 指定字符串
     * @return 截取截取指定字符串之后的数据
     */
    public static String getSubString(String str, String posStr) {
        return str.substring(str.indexOf(posStr) + posStr.length());
    }
    
    /**
     * 获取文件属性
     *
     * @param url url
     * @return 文件属性
     */
    public FileAttribute getFileAttribute(String url, HttpServletRequest req) {
        FileAttribute attribute = new FileAttribute();
        String suffix;
        FileType type;
        String originFileName; //原始文件名
        String outFilePath; //生成文件的路径
        String originFilePath; //原始文件路径
        String fullFileName = WebUtils.getUrlParameterReg(url, "fullfilename");
        String compressFileKey = WebUtils.getUrlParameterReg(url, "kkCompressfileKey"); //压缩包获取文件名
        String compressFilePath = WebUtils.getUrlParameterReg(url, "kkCompressfilepath"); //压缩包获取文件路径
        if (StringUtils.hasText(fullFileName)) {
            originFileName = fullFileName;
            type = FileType.typeFromFileName(fullFileName);
            suffix = KkFileUtils.suffixFromFileName(fullFileName);
            // 移除fullfilename参数
            url = WebUtils.clearFullfilenameParam(url);
        } else {
            originFileName = WebUtils.getFileNameFromURL(url);
            type = FileType.typeFromUrl(url);
            suffix = WebUtils.suffixFromUrl(url);
        }
        boolean isCompressFile = !ObjectUtils.isEmpty(compressFileKey);
        if (isCompressFile) {  //判断是否使用特定压缩包符号
            try {
                // http://127.0.0.1:8012/各类型文件1 - 副本.zip_/各类型文件/正常预览/PPT转的PDF.pdf?kkCompressfileKey=各类型文件1 - 副本.zip_
                // http://127.0.0.1:8012/preview/各类型文件1 - 副本.zip_/各类型文件/正常预览/PPT转的PDF.pdf?kkCompressfileKey=各类型文件1 - 副本.zip_ 获取路径就会错误 需要下面的方法
                String urlStrr = getSubString(compressFilePath, compressFileKey); //反代情况下添加前缀,只获取有压缩包字符的路径
                originFileName = compressFileKey + urlStrr.trim(); //拼接完整路径
                originFileName = URLDecoder.decode(originFileName, uriEncoding); //压缩包文件中文编码问题
                attribute.setSkipDownLoad(true);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        if (UrlEncoderUtils.hasUrlEncoded(originFileName)) {  //判断文件名是否转义
            try {
                originFileName = URLDecoder.decode(originFileName, uriEncoding);  //转义的文件名 解下出原始文件名
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }else {
            url = WebUtils.encodeUrlFileName(url); //对未转义的url进行转义
        }
        originFileName = KkFileUtils.htmlEscape(originFileName);  //文件名处理
        boolean isHtmlView = suffix.equalsIgnoreCase("xls") || suffix.equalsIgnoreCase("xlsx") || suffix.equalsIgnoreCase("csv") || suffix.equalsIgnoreCase("xlsm") || suffix.equalsIgnoreCase("xlt") || suffix.equalsIgnoreCase("xltm") || suffix.equalsIgnoreCase("et") || suffix.equalsIgnoreCase("ett") || suffix.equalsIgnoreCase("xlam");
        String cacheFilePrefixName = originFileName.substring(0, originFileName.lastIndexOf(".")) + suffix + "."; //这里统一文件名处理 下面更具类型 各自添加后缀
        String cacheFileName = this.getCacheFileName(type, originFileName, cacheFilePrefixName, isHtmlView, isCompressFile);
        outFilePath = fileDir + cacheFileName;
        originFilePath = fileDir + originFileName;
        String cacheListName = cacheFilePrefixName + "ListName";  //文件列表缓存文件名
        attribute.setType(type);
        attribute.setName(originFileName);
        attribute.setCacheName(cacheFileName);
        attribute.setCacheListName(cacheListName);
        attribute.setHtmlView(isHtmlView);
        attribute.setOutFilePath(outFilePath);
        attribute.setOriginFilePath(originFilePath);
        attribute.setSuffix(suffix);
        attribute.setUrl(url);
        if (req != null) {
            String officePreviewType = req.getParameter("officePreviewType");
            String forceUpdatedCache = req.getParameter("forceUpdatedCache");
            String usePasswordCache = req.getParameter("usePasswordCache");
            if (StringUtils.hasText(officePreviewType)) {
                attribute.setOfficePreviewType(officePreviewType);
            }
            if (StringUtils.hasText(compressFileKey)) {
                attribute.setCompressFile(isCompressFile);
                attribute.setCompressFileKey(compressFileKey);
            }
            if ("true".equalsIgnoreCase(forceUpdatedCache)) {
                attribute.setForceUpdatedCache(true);
            }

            String tifPreviewType = req.getParameter("tifPreviewType");
            if (StringUtils.hasText(tifPreviewType)) {
                attribute.setTifPreviewType(tifPreviewType);
            }

            String filePassword = req.getParameter("filePassword");
            if (StringUtils.hasText(filePassword)) {
                attribute.setFilePassword(filePassword);
            }
            if ("true".equalsIgnoreCase(usePasswordCache)) {
                attribute.setUsePasswordCache(true);
            }
            String kkProxyAuthorization = req.getHeader("kk-proxy-authorization");
            attribute.setKkProxyAuthorization(kkProxyAuthorization);

        }

        return attribute;
    }

    /**
     * 获取缓存的文件名
     *
     * @return 文件名
     */
    private String getCacheFileName(FileType type, String originFileName, String cacheFilePrefixName, boolean isHtmlView, boolean isCompressFile) {
        String cacheFileName;
        if (type.equals(FileType.OFFICE)) {
            cacheFileName = cacheFilePrefixName + (isHtmlView ? "html" : "pdf"); //生成文件添加类型后缀 防止同名文件
        } else if (type.equals(FileType.PDF)) {
            cacheFileName = originFileName;
        } else if (type.equals(FileType.MEDIACONVERT)) {
            cacheFileName = cacheFilePrefixName + "mp4";
        } else if (type.equals(FileType.CAD)) {
            String cadPreviewType = ConfigConstants.getCadPreviewType();
            cacheFileName = cacheFilePrefixName + cadPreviewType; //生成文件添加类型后缀 防止同名文件
        } else if (type.equals(FileType.COMPRESS)) {
            cacheFileName = originFileName;
        } else if (type.equals(FileType.TIFF)) {
            cacheFileName = cacheFilePrefixName + ConfigConstants.getTifPreviewType();
        } else {
            cacheFileName = originFileName;
        }
        if (isCompressFile) {  //判断是否使用特定压缩包符号
            cacheFileName = "_decompression" + cacheFileName;
        }
        return cacheFileName;
    }

    /**
     * @return 已转换过的视频文件集合(缓存)
     */
    public Map<String, String> listConvertedMedias() {
        return cacheService.getMediaConvertCache();
    }

    /**
     * 添加转换后的视频文件缓存
     *
     * @param fileName
     * @param value
     */
    public void addConvertedMedias(String fileName, String value) {
        cacheService.putMediaConvertCache(fileName, value);
    }

    /**
     * @return 已转换视频文件缓存，根据文件名获取
     */
    public String getConvertedMedias(String key) {
        return cacheService.getMediaConvertCache(key);
    }
}
