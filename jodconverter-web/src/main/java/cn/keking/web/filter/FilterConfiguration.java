package cn.keking.web.filter;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.HashSet;
import java.util.Set;


/**
 *
 * @author yudian-it
 * @date 2017/11/30
 */
@Configuration
public class FilterConfiguration {


    @Bean
    public FilterRegistrationBean getChinesePathFilter() {
        ChinesePathFilter filter = new ChinesePathFilter();
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean getTrustHostFilter() {
        Set<String> filterUri = new HashSet<>();
        filterUri.add("/onlinePreview");
        filterUri.add("/picturesPreview");
        filterUri.add("/getCorsFile");
        filterUri.add("/addTask");
        TrustHostFilter filter = new TrustHostFilter();
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        registrationBean.setUrlPatterns(filterUri);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean getBaseUrlFilter() {
        Set<String> filterUri = new HashSet<>();
        filterUri.add("/index");
        filterUri.add("/onlinePreview");
        filterUri.add("/picturesPreview");
        BaseUrlFilter filter = new BaseUrlFilter();
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        registrationBean.setUrlPatterns(filterUri);
        return registrationBean;
    }

    @Bean
    public FilterRegistrationBean getWatermarkConfigFilter() {
        Set<String> filterUri = new HashSet<>();
        filterUri.add("/onlinePreview");
        filterUri.add("/picturesPreview");
        WatermarkConfigFilter filter = new WatermarkConfigFilter();
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        registrationBean.setUrlPatterns(filterUri);
        return registrationBean;
    }
}
