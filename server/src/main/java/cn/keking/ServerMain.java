package cn.keking;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
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
		ServerMain.staticInitSystemProperty();
		new SpringApplicationBuilder(ServerMain.class)
				.logStartupInfo(false)
				.run(args);
		stopWatch.stop();
		logger.info("kkFileView 服务启动完成，耗时:{}s，演示页请访问: http://127.0.0.1:8012 ",stopWatch.getTotalTimeSeconds() );

	}

	private static void staticInitSystemProperty(){
		//pdfbox兼容低版本jdk
		System.setProperty("sun.java2d.cmm", "sun.java2d.cmm.kcms.KcmsServiceProvider");
	}

}
