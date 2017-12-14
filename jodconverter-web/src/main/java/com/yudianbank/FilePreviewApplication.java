package com.yudianbank;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;
import java.util.Properties;

@SpringBootApplication
@EnableScheduling
@ComponentScan(value = "com.yudianbank.*")
public class FilePreviewApplication {
	public static void main(String[] args) {
        Properties properties = System.getProperties();
        System.out.println(properties.get("user.dir"));
        SpringApplication.run(FilePreviewApplication.class, args);
	}
}
