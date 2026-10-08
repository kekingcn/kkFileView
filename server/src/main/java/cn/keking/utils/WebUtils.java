package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import io.mola.galimatias.GalimatiasParseException;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.util.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.HtmlUtils;

import jakarta.servlet.ServletRequest;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author : kl
 * create : 2020-12-27 1:30 上午
 **/
public class WebUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(WebUtils.class);
    private static final String BASE64_MSG = "base64";
    private static final String URL_PARAM_BASIC_NAME = "basic.name";
    private static final String URL_PARAM_BASIC_PASS = "basic.pass";
    private static final Map<String, String> ERROR_MESSAGES = Map.of(
            "base64", "KK提醒您:接入方法错误未使用BASE64",
            "base641", "KK提醒您:BASE64解码异常,确认是否正确使用BASE64编码",
            "Keyerror", "KK提醒您:AES解码错误，请检测你的秘钥是否正确",
            "base64error", "KK提醒您:你选用的是ASE加密，实际用了BASE64加密接入",
            "byteerror", "KK提醒您:解码异常，检测你接入方法是否正确"
    );

    private static final String EMPTY_URL_MSG = "KK提醒您:地址不能为空";
    private static final String INVALID_URL_MSG = "KK提醒您:请正确使用URL(必须包括https ftp file 协议)";
    /**
     * 获取标准的URL
     *
     * @param urlStr url
     * @return 标准的URL
     */
    public static URL normalizedURL(String urlStr) throws GalimatiasParseException, MalformedURLException {
        return io.mola.galimatias.URL.parse(urlStr).toJavaURL();
    }


    /**
     * 对文件名进行编码
     *
     */
    public static String encodeFileName(String name) {
        name = URLEncoder.encode(name, StandardCharsets.UTF_8)
                .replaceAll("%2F", "/")  // 恢复斜杠
                .replaceAll("%5C", "/")  // 恢复反斜杠
                .replaceAll("\\+", "%20");  // 空格处理
        return name;
    }


    /**
     * 去除fullfilename参数
     *
     * @param urlStr
     * @return
     */
    public static String clearFullfilenameParam(String urlStr) {
        // 去除特定参数字段
        Pattern pattern = Pattern.compile("(&fullfilename=[^&]*)");
        Matcher matcher = pattern.matcher(urlStr);
        return matcher.replaceAll("");
    }

    /**
     * 对URL进行编码
     */
    public static String  urlEncoderencode(String urlStr) {

        String fullFileName = getUrlParameterReg(urlStr, "fullfilename");  //获取流文件名
        if (org.springframework.util.StringUtils.hasText(fullFileName)) {
            // 移除fullfilename参数
            urlStr = clearFullfilenameParam(urlStr);
        } else {
            fullFileName = getFileNameFromURL(urlStr); //获取文件名
        }
        if (KkFileUtils.isIllegalFileName(fullFileName)) { //判断文件名是否带有穿越漏洞
            return null;
        }
        if (!UrlEncoderUtils.hasUrlEncoded(fullFileName)) {  //判断文件名是否转义
            try {
                urlStr = URLEncoder.encode(urlStr, "UTF-8").replaceAll("\\+", "%20").replaceAll("%3A", ":").replaceAll("%2F", "/").replaceAll("%3F", "?").replaceAll("%26", "&").replaceAll("%3D", "=");
            } catch (UnsupportedEncodingException e) {
                LOGGER.error("Failed to encode URL: {}", urlStr, e);
            }
        }
        return urlStr;
    }

    /**
     * 获取url中的参数
     *
     * @param url  url
     * @param name 参数名
     * @return 参数值
     */
    public static String getUrlParameterReg(String url, String name) {
        Map<String, String> mapRequest = new HashMap<>();
        String strUrlParam = truncateUrlPage(url);
        if (strUrlParam == null) {
            return "";
        }
        //每个键值为一组
        String[] arrSplit = strUrlParam.split("[&]");
        for (String strSplit : arrSplit) {
            String[] arrSplitEqual = strSplit.split("[=]");
            //解析出键值
            if (arrSplitEqual.length > 1) {
                //正确解析
                mapRequest.put(arrSplitEqual[0], arrSplitEqual[1]);
            } else if (!arrSplitEqual[0].equals("")) {
                //只有参数没有值，不加入
                mapRequest.put(arrSplitEqual[0], "");
            }
        }
        return mapRequest.get(name);
    }


    /**
     * 去掉url中的路径，留下请求参数部分
     *
     * @param strURL url地址
     * @return url请求参数部分
     */
    private static String truncateUrlPage(String strURL) {
        String strAllParam = null;
        strURL = strURL.trim();
        String[] arrSplit = strURL.split("[?]");
        if (strURL.length() > 1) {
            if (arrSplit.length > 1) {
                if (arrSplit[1] != null) {
                    strAllParam = arrSplit[1];
                }
            }
        }
        return strAllParam;
    }

    /**
     * 从url中剥离出文件名
     *
     * @param url 格式如：http://www.com.cn/20171113164107_月度绩效表模板(新).xls?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=I D1NOFtAJSPT16E6imv6JWuq0k=
     * @return 文件名
     */
    public static String getFileNameFromURL(String url) {
        if (url.toLowerCase().startsWith("file:")) {
            try {
                URL urlObj = new URL(url);
                url = urlObj.getPath().substring(1);
            } catch (MalformedURLException e) {
                LOGGER.error("Failed to parse file URL: {}", url, e);
            }
        }
        // 因为url的参数中可能会存在/的情况，所以直接url.lastIndexOf("/")会有问题
        // 所以先从？处将url截断，然后运用url.lastIndexOf("/")获取文件名
        String noQueryUrl = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        return noQueryUrl.substring(noQueryUrl.lastIndexOf("/") + 1);
    }

    /**
     * 从url中剥离出文件名
     * @param file 文件
     * @return 文件名
     */
    public static String getFileNameFromMultipartFile(MultipartFile file) {
        String fileName = file.getOriginalFilename();
        //判断是否为IE浏览器的文件名，IE浏览器下文件名会带有盘符信
        // escaping dangerous characters to prevent XSS
        assert fileName != null;
        fileName = HtmlUtils.htmlEscape(fileName, KkFileUtils.DEFAULT_FILE_ENCODING);

        // Check for Unix-style path
        int unixSep = fileName.lastIndexOf('/');
        // Check for Windows-style path
        int winSep = fileName.lastIndexOf('\\');
        // Cut off at latest possible point
        int pos = (Math.max(winSep, unixSep));
        if (pos != -1) {
            fileName = fileName.substring(pos + 1);
        }
        return fileName;
    }


    /**
     * 从url中获取文件后缀
     *
     * @param url url
     * @return 文件后缀
     */
    public static String suffixFromUrl(String url) {
        String nonPramStr = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        return KkFileUtils.suffixFromFileName(fileName);
    }

    /**
     * 对url中的文件名进行UTF-8编码
     *
     * @param url url
     * @return 文件名编码后的url
     */
    public static String encodeUrlFileName(String url) {
        String encodedFileName;
        String noQueryUrl = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        int fileNameStartIndex = noQueryUrl.lastIndexOf('/') + 1;
        int fileNameEndIndex = noQueryUrl.lastIndexOf('.');
        if (fileNameEndIndex < fileNameStartIndex) {
            return url;
        }
        encodedFileName = URLEncoder.encode(noQueryUrl.substring(fileNameStartIndex, fileNameEndIndex), StandardCharsets.UTF_8);
        return url.substring(0, fileNameStartIndex) + encodedFileName + url.substring(fileNameEndIndex);
    }

    /**
     * 从 ServletRequest 获取预览的源 url , 已 base64 解码
     *
     * @param request 请求 request
     * @return url
     */
    public static String getSourceUrl(ServletRequest request) {
        List<String> urls = getSourceUrls(request);
        return urls.isEmpty() ? null : urls.get(0);
    }

    /** Validate every candidate consumed by preview endpoints, including all images. */
    public static List<String> getSourceUrls(ServletRequest request) {
        List<String> urls = new ArrayList<>();
        String encryption = request.getParameter("encryption");
        try {
            for (String name : List.of("url", "currentUrl", "urlPath", "urls")) {
                String[] values = request.getParameterValues(name);
                if (values == null) {
                    continue;
                }
                for (String value : values) {
                    if (StringUtils.isBlank(value)) {
                        continue;
                    }
                    // picturesPreview decodes currentUrl as Base64 independently of encryption.
                    String decoded = "currentUrl".equals(name)
                            ? decodeBase64String(value, StandardCharsets.UTF_8) : decodeUrl(value, encryption);
                    if (decoded == null) {
                        return List.of("");
                    }
                    if ("urls".equals(name)) {
                        urls.addAll(Arrays.asList(decoded.split("\\|", -1)));
                    } else {
                        urls.add(decoded);
                    }
                }
            }
        } catch (RuntimeException e) {
            return List.of("");
        }
        return urls;
    }
    /**
     *  判断地址是否正确
     * 高 2022/12/17
     */
    public static boolean isValidUrl(String url) {
        if (url == null) {
            return false;
        }
        String regStr = "^((https|http|ftp|rtsp|mms|file)://)";//[.?*]表示匹配的就是本身
        Pattern pattern = Pattern.compile(regStr);
        Matcher matcher = pattern.matcher(url);
        return matcher.find();
    }

    /**
     * 将 Base64 字符串解码，再解码URL参数, 默认使用 UTF-8
     * @param source 原始 Base64 字符串
     * @return decoded string
     *
     * aHR0cHM6Ly9maWxlLmtla2luZy5jbi9kZW1vL%2BS4reaWhy5wcHR4 -> https://file.keking.cn/demo/%E4%B8%AD%E6%96%87.pptx -> https://file.keking.cn/demo/中文.pptx
     */
    public static String decodeUrl(String source,String encryption) {
        String url;
        if(ObjectUtils.isEmpty(encryption) || Objects.equals(ConfigConstants.getaesKey(), "false")){
            encryption = "base64";
        }
        if(Objects.equals(encryption.toLowerCase(), "aes")){
            return AESUtil.AesDecrypt(source);
        }else {
            url = decodeBase64String(source, StandardCharsets.UTF_8);
            if(!isValidUrl(url)){
                url="base641";
            }
            return url;
        }
    }

    /**
     * 将 Base64 字符串使用指定字符集解码
     * @param source 原始 Base64 字符串
     * @param charsets 字符集
     * @return decoded string
     */
    public static String decodeBase64String(String source, Charset charsets) {
        /*
         * url 传入的参数里加号会被替换成空格，导致解析出错，这里需要把空格替换回加号
         * 有些 Base64 实现可能每 76 个字符插入换行符，也一并去掉
         * https://github.com/kekingcn/kkFileView/pull/340
         */
        try {
            return new String(Base64.decodeBase64(source.replaceAll(" ", "+").replaceAll("\n", "")), charsets);
        } catch (Exception e) {
            if (e.getMessage().toLowerCase().contains(BASE64_MSG)) {
                LOGGER.error("url解码异常，接入方法错误未使用BASE64");
            }else {
                LOGGER.error("url解码异常，其他错误", e);
            }
            return null;
        }
    }

    public static String urlSecurity(String url) {

        if (ObjectUtils.isEmpty(url)) {
            return EMPTY_URL_MSG;
        }
        // 检查已知的错误类型
        String errorMsg = ERROR_MESSAGES.get(url);
        if (errorMsg != null) {
            return errorMsg;
        }
        // 验证URL格式
        if (!isValidUrl(url)) {
            return INVALID_URL_MSG;
        }
        // file协议特殊处理
        if (url.toLowerCase().startsWith("file://")) {
            // 对于本地文件，可以返回URL本身或进行特殊处理
            // 根据业务需求决定：返回URL、返回特殊标识或进行本地文件安全检查
            return url; // 或者返回特殊标识如 "file-protocol"
        }
        // 提取主机名
        return getHost(url);
    }

    /**
     * 获取 url 的 host
     * @param urlStr url
     * @return host
     */
    public static String getHost(String urlStr) {
        if (urlStr == null) {
            return null;
        }
        try {
            URL url = normalizedURL(urlStr);
            return url.getHost().toLowerCase(Locale.ROOT);
        } catch (GalimatiasParseException | MalformedURLException | IllegalArgumentException ignored) {
        }
        return null;
    }

    /**
     * 获取 session 中的 String 属性
     * @param request 请求
     * @return 属性值
     */
    public static String getSessionAttr(HttpServletRequest request, String key) {
        HttpSession session = request.getSession();
        if (session == null) {
            return null;
        }
        Object value = session.getAttribute(key);
        if (value == null) {
            return null;
        }
        return value.toString();
    }

    /**
     * 获取 session 中的 long 属性
     * @param request 请求
     * @param key 属性名
     * @return 属性值
     */
    public static long getLongSessionAttr(HttpServletRequest request, String key) {
        String value = getSessionAttr(request, key);
        if (value == null) {
            return 0;
        }
        return Long.parseLong(value);
    }

    /**
     * session 中设置属性
     * @param request 请求
     * @param key 属性名
     */
    public static void setSessionAttr(HttpServletRequest request, String key, Object value) {
        HttpSession session = request.getSession();
        if (session == null) {
            return;
        }
        session.setAttribute(key, value);
    }

    /**
     * 移除 session 中的属性
     * @param request 请求
     * @param key 属性名
     */
    public static void removeSessionAttr(HttpServletRequest request, String key) {
        HttpSession session = request.getSession();
        if (session == null) {
            return;
        }
        session.removeAttribute(key);
    }

    public static boolean validateKey(String key) {
        String configKey = ConfigConstants.getKey();
        return !"false".equals(configKey) && !configKey.equals(key);
    }

    public static String getContentTypeByFilename(String filename) {
        String extension = filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
        switch (extension) {
            case "pdf": return "application/pdf";
            case "jpg": case "jpeg": return "image/jpeg";
            case "png": return "image/png";
            case "gif": return "image/gif";
            case "svg": return "image/svg+xml";
            case "txt": return "text/plain";
            case "html": case "htm": return "text/html";
            case "xml": return "application/xml";
            case "json": return "application/json";
            default: return null;
        }
    }
    /**
     * name pass  获取用户名 和密码
     */
    public static String[] namePass(String url,String name) {
        url= getHost(url);
        String[] items = name.split(",\\s*");
        String toRemove = ":";
        String names = null;
        String[] parts  = null;
        try {
            for (String item : items) {
                int index = item.indexOf(toRemove);
                if (index != -1) {
                    String result = item.substring(0, index);
                    if (Objects.equals(result, url)) {
                        names = item;
                    }
                }
            }
            if (names !=null){
                parts = names.split(toRemove);
            }
        } catch (Exception e) {
            LOGGER.error("获取认证权限错误：",e);
        }
        return parts;
    }

    /**
     * 获取Content-Type
     */

    public static String headersType(ClientHttpResponse fileResponse) {
        if (fileResponse == null) {
            return null;
        }
        HttpHeaders headers = fileResponse.getHeaders();
        if (headers == null) {
            return null;
        }
        String contentTypeStr = null;
        try {
            // 直接获取Content-Type头字符串
            contentTypeStr = headers.getFirst(HttpHeaders.CONTENT_TYPE);
            if (contentTypeStr == null || contentTypeStr.isEmpty()) {
                return null;
            }
            // 解析为MediaType对象
            MediaType mediaType = MediaType.parseMediaType(contentTypeStr);
            // 返回主类型和子类型，忽略参数
            return mediaType.getType() + "/" + mediaType.getSubtype();
        } catch (Exception e) {
            // 如果解析失败，尝试简单的字符串处理
            if (contentTypeStr != null) {
                // 移除分号及后面的参数
                int semicolonIndex = contentTypeStr.indexOf(';');
                if (semicolonIndex > 0) {
                    return contentTypeStr.substring(0, semicolonIndex).trim();
                }
                return contentTypeStr.trim();
            }
            return null;
        }
    }

    /**
     * 判断文件是否需要校验MIME类型
     * @param suffix 文件后缀
     * @return 是否需要校验
     */
    public static boolean isMimeCheckRequired(String suffix) {
        if (suffix == null) {
            return false;
        }
        String lowerSuffix = suffix.toLowerCase();
        return Arrays.asList(
                "doc", "docx", "ppt", "pptx", "pdf", "dwg",
                "dxf", "dwf", "psd", "wps", "xlsx", "xls",
                "rar", "zip"
        ).contains(lowerSuffix);
    }

    /**
     * 校验文件MIME类型是否有效
     * @param contentType 响应头中的Content-Type
     * @param suffix 文件后缀
     * @return 是否有效
     */
    public static boolean isValidMimeType(String contentType, String suffix) {
        if (contentType == null || suffix == null) {
            return true;
        }

        // 如果检测到是HTML、文本或JSON格式，则认为是错误响应
        String lowerContentType = contentType.toLowerCase();
        return !lowerContentType.contains("text/html")
                && !lowerContentType.contains("text/plain")
                && !lowerContentType.contains("application/json");
    }

    /**
     * 支持basic 下载方法
     */
    public static void applyBasicAuthHeaders(HttpHeaders headers, String url) {

        // 从配置文件读取User-Agent，如果没有配置则使用默认值
        String customUserAgent=ConfigConstants.getUserAgent();
        String userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";
        if (!StringUtils.isEmpty(customUserAgent) && !Objects.equals(customUserAgent, "false")) {
            userAgent = customUserAgent;
        }
        headers.set("User-Agent", userAgent);
        // 获取用户名和密码
        String username = null;
        String password = null;
        // 从basic配置获取
        String basic = ConfigConstants.getBasicName();
        if (!StringUtils.isEmpty(basic) && !Objects.equals(basic, "false")) {
            String[] urlUser = namePass(url, basic);
            if (urlUser != null && urlUser.length >= 3) {
                username = urlUser[1];
                password = urlUser[2];
            }
        }
        // URL参数优先
        String basicUsername = getUrlParameterReg(url, URL_PARAM_BASIC_NAME);
        String basicPassword = getUrlParameterReg(url, URL_PARAM_BASIC_PASS);

        if (!StringUtils.isEmpty(basicUsername)) {
            username = basicUsername;
            password = basicPassword;
        }

        // 设置Basic Auth
        if (!StringUtils.isEmpty(username)) {
            String plainCredentials = username + ":" + (password != null ? password : "");
            String base64Credentials = java.util.Base64.getEncoder().encodeToString(plainCredentials.getBytes());
            headers.set("Authorization", "Basic " + base64Credentials);
        }
    }
}
