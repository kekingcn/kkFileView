package cn.keking;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.util.StopWatch;

@SpringBootApplication
@EnableScheduling
@ComponentScan(value = "cn.keking.*")
public class ServerMain {

    private static final Logger logger = LoggerFactory.getLogger(ServerMain.class);

    public static void main(String[] args) {
        StopWatch stopWatch = new StopWatch();
        stopWatch.start();
        ConfigurableApplicationContext context = new SpringApplicationBuilder(ServerMain.class)
                .logStartupInfo(false)
                .run(args);
        stopWatch.stop();
        ServerProperties serverProperties = context.getBean(ServerProperties.class);
        Integer port = serverProperties.getPort();
        ServerProperties.Servlet servlet = serverProperties.getServlet();
        String contextPath = servlet.getContextPath();
        String urlSuffix = StringUtils.isBlank(contextPath)? String.valueOf(port):port+contextPath;
        logger.info("kkFileView 服务启动完成，耗时:{}s，演示页请访问: http://127.0.0.1:{} ", stopWatch.getTotalTimeSeconds(), urlSuffix);
    }

}
