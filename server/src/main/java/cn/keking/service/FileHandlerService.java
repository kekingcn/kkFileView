package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import cn.keking.utils.*;
import cn.keking.web.filter.BaseUrlFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.DependsOn;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import jakarta.servlet.http.HttpServletRequest;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.IntStream;

/**
 * @author yudian-it
 * @date 2017/11/13
 */
@Component
@DependsOn(ConfigConstants.BEAN_NAME)
public class FileHandlerService {

    private static final String PDF2JPG_IMAGE_FORMAT = ".jpg";

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
            logger.error("Failed to read file: {}", outFilePath, e);
        }
        // 重新写入文件
        try (FileOutputStream fos = new FileOutputStream(outFilePath); BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, StandardCharsets.UTF_8))) {
            writer.write(sb.toString());
        } catch (IOException e) {
            logger.error("Failed to write file: {}", outFilePath, e);
        }
    }

    /**
     * 获取本地 pdf 转 image 后的 web 访问地址
     *
     * @param pdfFilePath pdf文件名
     * @param index       图片索引
     * @return 图片访问地址
     */
    public String getPdf2jpgUrl(String pdfFilePath, int index) {
        String baseUrl = BaseUrlFilter.getBaseUrl();
        pdfFilePath = pdfFilePath.replace(fileDir, "");
        String pdfFolder = pdfFilePath.substring(0, pdfFilePath.length() - 4);
        // 对整个路径进行编码，包括特殊字符
        String encodedPath = URLEncoder.encode(pdfFolder, StandardCharsets.UTF_8);
        encodedPath = encodedPath
                .replaceAll("%2F", "/")  // 恢复斜杠
                .replaceAll("%5C", "/")  // 恢复反斜杠
                .replaceAll("\\+", "%20");  // 空格处理
        // 构建URL：使用_作为分隔符（这是kkFileView压缩包预览的常见格式）
        String url = baseUrl + encodedPath + "/" + index + PDF2JPG_IMAGE_FORMAT;
        return url;

    }

    /**
     * 获取缓存中的 pdf 转换成 jpg 图片集
     *
     * @param pdfFilePath pdf文件路径
     * @return 图片访问集合
     */
    public List<String> loadPdf2jpgCache(String pdfFilePath) {  // 移除 static 修饰符
        List<String> imageUrls = new ArrayList<>();
        Integer imageCount = this.getPdf2jpgCache(pdfFilePath);  // 使用 this. 调用
        if (Objects.isNull(imageCount)) {
            return imageUrls;
        }
        IntStream.range(0, imageCount).forEach(i -> {
            String imageUrl = this.getPdf2jpgUrl(pdfFilePath, i);  // 使用 this. 调用
            imageUrls.add(imageUrl);
        });
        return imageUrls;
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
                originFileName = URLDecoder.decode(compressFilePath, uriEncoding);  //转义的文件名 解下出原始文件名
                attribute.setSkipDownLoad(true);
            } catch (UnsupportedEncodingException e) {
                logger.error("Failed to decode file name: {}", originFileName, e);
            }
        }
        if (UrlEncoderUtils.hasUrlEncoded(originFileName)) {  //判断文件名是否转义
            try {
                originFileName = URLDecoder.decode(originFileName, uriEncoding);  //转义的文件名 解下出原始文件名
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }else {
            url = Objects.requireNonNull(WebUtils.encodeUrlFileName(url))
                    .replaceAll("\\+", "%20")
                    .replaceAll("%3A", ":")
                    .replaceAll("%2F", "/")
                    .replaceAll("%3F", "?")
                    .replaceAll("%26", "&")
                    .replaceAll("%3D", "=");

        }
        originFileName = KkFileUtils.htmlEscape(originFileName);  //文件名处理
        if (!KkFileUtils.validateFileNameLength(originFileName)) {
            // 处理逻辑：抛出异常、记录日志、返回错误等
            throw new IllegalArgumentException("文件名超过系统限制");
        }
        String officePreviewType = req == null ? null : req.getParameter("officePreviewType");
        if (StringUtils.hasText(officePreviewType)) {
            attribute.setOfficePreviewType(officePreviewType);
        }
        boolean isHtmlView = isHtmlPreview(suffix, attribute.getOfficePreviewType(),
                attribute.isOfficePreviewTypeSpecified());
        String cacheFilePrefixName = null;
        try {
            cacheFilePrefixName = originFileName.substring(0, originFileName.lastIndexOf(".")) + suffix + "."; //这里统一文件名处理 下面更具类型 各自添加后缀
        } catch (Exception e) {
            logger.error("获取文件名后缀错误：", e);
            //  e.printStackTrace();
        }
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
            String forceUpdatedCache = req.getParameter("forceUpdatedCache");
            String usePasswordCache = req.getParameter("usePasswordCache");
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
     * 判断电子表格是否需要生成 HTML 预览缓存。
     * 未显式指定预览类型时保留原有行为；显式指定时仅 {@code html} 模式生成 HTML。
     *
     * @param suffix 文件后缀
     * @param officePreviewType Office 预览类型
     * @param previewTypeSpecified 是否由请求或调用方显式指定预览类型
     * @return 是否生成 HTML 预览缓存
     */
    static boolean isHtmlPreview(String suffix, String officePreviewType, boolean previewTypeSpecified) {
        return isSpreadsheet(suffix)
                && (!previewTypeSpecified || "html".equalsIgnoreCase(officePreviewType));
    }

    /**
     * 判断文件后缀是否属于支持 HTML 预览的电子表格类型。
     *
     * @param suffix 文件后缀
     * @return 是否为电子表格类型
     */
    private static boolean isSpreadsheet(String suffix) {
        return suffix.equalsIgnoreCase("xls")
                || suffix.equalsIgnoreCase("xlsx")
                || suffix.equalsIgnoreCase("csv")
                || suffix.equalsIgnoreCase("xlsm")
                || suffix.equalsIgnoreCase("xlt")
                || suffix.equalsIgnoreCase("xltm")
                || suffix.equalsIgnoreCase("et")
                || suffix.equalsIgnoreCase("ett")
                || suffix.equalsIgnoreCase("xlam");
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
