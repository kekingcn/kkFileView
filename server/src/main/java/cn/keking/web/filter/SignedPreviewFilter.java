package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.JwtUtils;
import cn.keking.utils.SignedPreviewUtils;
import cn.keking.utils.WebUtils;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletRequestWrapper;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 签名预览（signed.preview.enabled，默认关闭）。
 * 关闭时请求原样往后传；开启后预览入口只接受带有效签名令牌的请求，并按令牌重建请求参数：
 * 文件地址、文件名、水印、是否强制重新转换取令牌里的，浏览器带的参数只留放行名单上的。
 * 重建后的参数里只有令牌给的那一个文件地址，后面的信任站点、信任目录过滤器照常对它做检查。
 */
public class SignedPreviewFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(SignedPreviewFilter.class);

    private static final String PICTURES_PREVIEW_PATH = "/picturesPreview";
    private static final String PARAM_URL = "url";
    private static final String PARAM_URLS = "urls";
    private static final String PARAM_CURRENT_URL = "currentUrl";
    private static final String PARAM_WATERMARK = "watermarkTxt";
    private static final String PARAM_FORCE = "forceUpdatedCache";
    /**
     * 由令牌决定的参数，写进放行名单也不从浏览器取
     */
    private static final Set<String> TOKEN_OWNED_PARAMS = tokenOwnedParams();

    private static final String MSG_MISSING = "预览链接缺少签名令牌，请回到原页面重新打开";
    private static final String MSG_EXPIRED = "预览链接已过期，请回到原页面重新打开";
    private static final String MSG_INVALID = "预览链接的签名令牌无效，请回到原页面重新打开";
    private static final String MSG_NO_SECRET = "已开启签名预览但未配置密钥，请联系管理员";
    private static final String MSG_BAD_CONFIG = "签名预览的令牌用途配置有误，请联系管理员";

    /**
     * 已经执行过「强制重新转换」的令牌（签名段 → 过期时间）。
     * 转换中的等待页会带着同一枚令牌整页刷新，每枚令牌只认一次，否则每刷新一次就重新转换一次。
     */
    private final Map<String, Long> forcedTokens = new ConcurrentHashMap<>();
    private String deniedView;

    @Override
    public void init(FilterConfig filterConfig) {
        try {
            byte[] bytes = FileCopyUtils.copyToByteArray(new ClassPathResource("web/signedPreviewDenied.html").getInputStream());
            this.deniedView = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            logger.error("加载signedPreviewDenied.html失败", e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (!ConfigConstants.isSignedPreviewEnabled()) {
            chain.doFilter(request, response);
            return;
        }
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        if (!SignedPreviewUtils.isSecretConfigured()) {
            logger.error("已开启 signed.preview.enabled 但没有配置 signed.preview.secret，拒绝全部预览请求");
            deny(response, MSG_NO_SECRET);
            return;
        }
        if (!SignedPreviewUtils.isUseConfigValid()) {
            logger.error("signed.preview.use.preview / archive / fetch 三个值必须不为空且互不相同，拒绝全部预览请求");
            deny(response, MSG_BAD_CONFIG);
            return;
        }
        String token = httpRequest.getParameter(ConfigConstants.getSignedPreviewTokenParam());
        if (!StringUtils.hasText(token)) {
            deny(response, MSG_MISSING);
            return;
        }
        Map<String, Object> claims;
        Map<String, String[]> parameters;
        try {
            claims = SignedPreviewUtils.verify(token);
            parameters = rebuildParameters(httpRequest, token, claims);
        } catch (JwtUtils.JwtException e) {
            logger.warn("签名预览拒绝请求：{}", e.getMessage());
            deny(response, e.isExpired() ? MSG_EXPIRED : MSG_INVALID);
            return;
        }
        request.setAttribute(SignedPreviewUtils.CLAIMS_ATTRIBUTE, claims);
        chain.doFilter(new ParameterRequest(httpRequest, parameters), response);
    }

    private Map<String, String[]> rebuildParameters(HttpServletRequest request, String token, Map<String, Object> claims) throws JwtUtils.JwtException {
        Map<String, String[]> parameters = new LinkedHashMap<>();
        boolean picturesPreview = request.getRequestURI().endsWith(PICTURES_PREVIEW_PATH);
        // 用途：没写时按配置决定算不算预览令牌；写了就必须正好是配置的那个值
        Object use = claims.get(ConfigConstants.getSignedPreviewClaimUse());
        boolean previewToken = use == null ? !ConfigConstants.isSignedPreviewUseRequired()
                : ConfigConstants.getSignedPreviewUsePreview().equals(use);
        if (previewToken) {
            if (picturesPreview) {
                parameters.put(PARAM_URLS, new String[]{base64(imageUrls(claims))});
                String currentUrl = text(claims.get(SignedPreviewUtils.claimName(PARAM_CURRENT_URL)));
                if (currentUrl != null) {
                    parameters.put(PARAM_CURRENT_URL, new String[]{base64(currentUrl)});
                }
            } else {
                parameters.put(PARAM_URL, new String[]{base64(fileUrl(claims))});
            }
            if (isTrue(claims.get(ConfigConstants.getSignedPreviewClaimForce())) && firstForce(token, claims)) {
                parameters.put(PARAM_FORCE, new String[]{"true"});
            }
        } else if (ConfigConstants.getSignedPreviewUseArchive().equals(use) && !picturesPreview) {
            parameters.put(PARAM_URL, new String[]{archiveEntryUrl(request, claims)});
        } else {
            throw new JwtUtils.JwtException("令牌的用途不是预览");
        }
        String watermark = text(claims.get(ConfigConstants.getSignedPreviewClaimWatermark()));
        if (watermark != null) {
            parameters.put(PARAM_WATERMARK, new String[]{watermark});
        }
        for (String name : SignedPreviewUtils.WATERMARK_PARAMS) {
            String value = text(claims.get(SignedPreviewUtils.claimName(name)));
            if (value != null) {
                parameters.put(name, new String[]{value});
            }
        }
        String tokenParam = ConfigConstants.getSignedPreviewTokenParam();
        ConfigConstants.getSignedPreviewAllowParams().forEach((name, allowedValues) -> {
            String[] values = request.getParameterValues(name);
            if (values != null && !TOKEN_OWNED_PARAMS.contains(name) && !name.equals(tokenParam)
                    && isAllowedValue(values, allowedValues)) {
                parameters.put(name, values);
            }
        });
        return parameters;
    }

    /**
     * 放行名单里限定了取值的参数：只能给一个值，且必须正好是列出的值之一；没限定的任意值
     */
    private static boolean isAllowedValue(String[] values, Set<String> allowedValues) {
        return allowedValues.isEmpty() || (values.length == 1 && allowedValues.contains(values[0]));
    }

    /**
     * 令牌里的文件地址；令牌带了文件名、地址里又没有 fullfilename 时，按现有约定把文件名接在地址后面
     */
    private String fileUrl(Map<String, Object> claims) throws JwtUtils.JwtException {
        String url = text(claims.get(ConfigConstants.getSignedPreviewClaimUrl()));
        if (!StringUtils.hasText(url)) {
            throw new JwtUtils.JwtException("令牌里没有文件地址");
        }
        String fileName = text(claims.get(ConfigConstants.getSignedPreviewClaimFilename()));
        if (StringUtils.hasText(fileName) && !StringUtils.hasText(WebUtils.getUrlParameterReg(url, "fullfilename"))) {
            url += (url.contains("?") ? "&" : "?") + "fullfilename=" + URLEncoder.encode(fileName, StandardCharsets.UTF_8);
        }
        return url;
    }

    /**
     * 多图预览的图片地址：令牌里可以是数组，也可以是用 | 分隔的字符串
     */
    private String imageUrls(Map<String, Object> claims) throws JwtUtils.JwtException {
        Object urls = claims.get(ConfigConstants.getSignedPreviewClaimUrls());
        if (urls instanceof List<?> list) {
            List<String> items = new ArrayList<>();
            for (Object item : list) {
                items.add(text(item));
            }
            urls = items.contains(null) ? null : String.join("|", items);
        }
        if (!(urls instanceof String joined) || !StringUtils.hasText(joined)) {
            throw new JwtUtils.JwtException("令牌里没有图片地址");
        }
        return joined;
    }

    /**
     * 压缩包令牌：包内文件的地址由压缩包预览页拼好、浏览器带来，这里只放行落在该压缩包目录下的那些。
     * 返回的是浏览器带来的原值，后面按原有流程解码。
     */
    private String archiveEntryUrl(HttpServletRequest request, Map<String, Object> claims) throws JwtUtils.JwtException {
        String root = text(claims.get(SignedPreviewUtils.CLAIM_ARCHIVE_ROOT));
        String prefix = text(claims.get(SignedPreviewUtils.CLAIM_ARCHIVE_PREFIX));
        String[] values = request.getParameterValues(PARAM_URL);
        String entryUrl = values == null || values.length != 1 ? null
                : WebUtils.decodeBase64String(values[0], StandardCharsets.UTF_8);
        if (!StringUtils.hasText(root) || !StringUtils.hasText(prefix) || entryUrl == null) {
            throw new JwtUtils.JwtException("压缩包令牌或包内文件地址不完整");
        }
        int query = entryUrl.indexOf('?');
        String location = query < 0 ? entryUrl : entryUrl.substring(0, query);
        String entryPath = fullyDecoded(WebUtils.getUrlParameterReg(entryUrl, "kkCompressfilepath"));
        boolean insideArchive = location.startsWith(prefix)
                && isPlainRelativePath(fullyDecoded(location.substring(prefix.length())))
                && root.equals(WebUtils.getUrlParameterReg(entryUrl, "kkCompressfileKey"))
                && entryPath != null && entryPath.startsWith(root + "/")
                && isPlainRelativePath(entryPath.substring(root.length() + 1));
        if (!insideArchive) {
            throw new JwtUtils.JwtException("包内文件地址不在令牌对应的压缩包下");
        }
        return values[0];
    }

    /**
     * 反复做 URL 解码直到不再变化（后面的流程对文件名可能解码不止一次）
     */
    private static String fullyDecoded(String value) {
        String current = value;
        for (int i = 0; current != null && i < 8; i++) {
            String decoded;
            try {
                decoded = URLDecoder.decode(current, StandardCharsets.UTF_8);
            } catch (IllegalArgumentException e) {
                return current;
            }
            if (decoded.equals(current)) {
                return current;
            }
            current = decoded;
        }
        return null;
    }

    private static boolean isPlainRelativePath(String path) {
        if (!StringUtils.hasText(path) || path.contains("\\")) {
            return false;
        }
        for (String segment : path.split("/", -1)) {
            if ("..".equals(segment)) {
                return false;
            }
        }
        return true;
    }

    private boolean firstForce(String token, Map<String, Object> claims) {
        long now = System.currentTimeMillis() / 1000;
        forcedTokens.values().removeIf(expireAt -> expireAt < now);
        long expireAt = ((Number) claims.get("exp")).longValue() + ConfigConstants.getSignedPreviewLeeway();
        return forcedTokens.putIfAbsent(token.substring(token.lastIndexOf('.') + 1), expireAt) == null;
    }

    private static Set<String> tokenOwnedParams() {
        Set<String> names = new HashSet<>(List.of(PARAM_URL, PARAM_URLS, PARAM_CURRENT_URL, "urlPath", "encryption",
                PARAM_WATERMARK, PARAM_FORCE));
        names.addAll(SignedPreviewUtils.WATERMARK_PARAMS);
        return names;
    }

    private static String text(Object value) {
        return value instanceof String || value instanceof Number || value instanceof Boolean ? value.toString() : null;
    }

    private static boolean isTrue(Object value) {
        return Boolean.TRUE.equals(value) || "true".equalsIgnoreCase(text(value));
    }

    private static String base64(String value) {
        return Base64.getEncoder().encodeToString(value.getBytes(StandardCharsets.UTF_8));
    }

    private void deny(ServletResponse response, String message) throws IOException {
        if (response instanceof HttpServletResponse httpServletResponse) {
            httpServletResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
        }
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("text/html;charset=UTF-8");
        String html = this.deniedView == null
                ? "<html><head><meta charset=\"utf-8\"></head><body>" + message + "</body></html>"
                : this.deniedView.replace("${message}", message);
        response.getWriter().write(html);
        response.getWriter().close();
    }

    @Override
    public void destroy() {

    }

    /**
     * 只暴露重建后的那一份请求参数
     */
    private static final class ParameterRequest extends HttpServletRequestWrapper {

        private final Map<String, String[]> parameters;

        private ParameterRequest(HttpServletRequest request, Map<String, String[]> parameters) {
            super(request);
            this.parameters = Collections.unmodifiableMap(parameters);
        }

        @Override
        public String getParameter(String name) {
            String[] values = parameters.get(name);
            return values == null || values.length == 0 ? null : values[0];
        }

        @Override
        public Map<String, String[]> getParameterMap() {
            return parameters;
        }

        @Override
        public Enumeration<String> getParameterNames() {
            return Collections.enumeration(parameters.keySet());
        }

        @Override
        public String[] getParameterValues(String name) {
            return parameters.get(name);
        }
    }
}
