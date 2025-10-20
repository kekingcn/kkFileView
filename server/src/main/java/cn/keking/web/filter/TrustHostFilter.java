package cn.keking.web.filter;

import cn.keking.config.ConfigConstants;
import cn.keking.utils.WebUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

import org.apache.commons.collections4.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.FileCopyUtils;

/**
 * @author chenjh
 * @since 2020/2/18 19:13
 */
public class TrustHostFilter implements Filter {

    private static final Logger logger = LoggerFactory.getLogger(TrustHostFilter.class);
    private String notTrustHostHtmlView;

    @Override
    public void init(FilterConfig filterConfig) {
        ClassPathResource classPathResource = new ClassPathResource("web/notTrustHost.html");
        try {
            classPathResource.getInputStream();
            byte[] bytes = FileCopyUtils.copyToByteArray(classPathResource.getInputStream());
            this.notTrustHostHtmlView = new String(bytes, StandardCharsets.UTF_8);
        } catch (IOException e) {
            logger.error("Failed to load notTrustHost.html file", e);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        String url = WebUtils.getSourceUrl(request);
        String host = WebUtils.getHost(url);
        assert host != null;
        if (isNotTrustHost(host)) {
            String html = this.notTrustHostHtmlView.replace("${current_host}", host);
            response.getWriter().write(html);
            response.getWriter().close();
        } else {
            chain.doFilter(request, response);
        }
    }

    public boolean isNotTrustHost(String host) {
        // 如果配置了黑名单，优先检查黑名单
        if (CollectionUtils.isNotEmpty(ConfigConstants.getNotTrustHostSet())) {
            return ConfigConstants.getNotTrustHostSet().contains(host);
        }

        // 如果配置了白名单，检查是否在白名单中
        if (CollectionUtils.isNotEmpty(ConfigConstants.getTrustHostSet())) {
            // 支持通配符 * 表示允许所有主机
            if (ConfigConstants.getTrustHostSet().contains("*")) {
                logger.debug("允许所有主机访问（通配符模式）: {}", host);
                return false;
            }
            return !ConfigConstants.getTrustHostSet().contains(host);
        }

        // 安全加固：默认拒绝所有未配置的主机（防止SSRF攻击）
        // 如果需要允许所有主机，请在配置文件中明确设置 trust.host = *
        logger.warn("未配置信任主机列表，拒绝访问主机: {}，请在配置文件中设置 trust.host 或 KK_TRUST_HOST 环境变量", host);
        return true;
    }

    @Override
    public void destroy() {

    }

}
