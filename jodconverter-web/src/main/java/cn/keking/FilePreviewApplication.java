package cn.keking;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
@ComponentScan(value = "cn.keking.*")
public class FilePreviewApplication {

	public static void main(String[] args) {
		FilePreviewApplication.staticInitSystemProperty();
        SpringApplication.run(FilePreviewApplication.class, args);
	}

	private static void staticInitSystemProperty(){
		//pdfbox兼容低版本jdk
		System.setProperty("sun.java2d.cmm", "sun.java2d.cmm.kcms.KcmsServiceProvider");
	}
}
