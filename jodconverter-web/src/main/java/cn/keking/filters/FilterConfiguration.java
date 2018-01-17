package cn.keking.filters;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


/**
 *
 * @author yudian-it
 * @date 2017/11/30
 */
@Configuration
public class FilterConfiguration {

    @Bean
    public FilterRegistrationBean getChinesePathFilter(){
        ChinesePathFilter filter = new ChinesePathFilter();
        FilterRegistrationBean registrationBean = new FilterRegistrationBean();
        registrationBean.setFilter(filter);
        return registrationBean;
    }
}
