package cn.keking.utils;

import com.sun.star.document.UpdateDocMode;
import cn.keking.extend.ControlDocumentFormatRegistry;
import org.apache.commons.lang3.StringUtils;
import org.artofsolving.jodconverter.OfficeDocumentConverter;
import org.artofsolving.jodconverter.office.DefaultOfficeManagerConfiguration;
import org.artofsolving.jodconverter.office.OfficeManager;
import org.artofsolving.jodconverter.office.OfficeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * 创建文件转换器
 *
 * @author yudian-it
 * @date 2017/11/13
 */
@Component
public class ConverterUtils {

    private final Logger logger = LoggerFactory.getLogger(ConverterUtils.class);

//    @Value("${office.home}")
//    String officeHome;
//    OpenOfficeConnection connection;
    OfficeManager officeManager;

    @PostConstruct
    public void initOfficeManager() {
        String officeHome = OfficeUtils.getDefaultOfficeHome().getAbsolutePath();
        if (officeHome == null) {
            throw new RuntimeException("找不到office组件，请确认'office.home'配置是否有误");
        }
        boolean killOffice = killProcess("soffice.bin");
        if (killOffice) {
            logger.warn("检测到有正在运行的office进程，已自动结束该进程");
        }
        try {
            DefaultOfficeManagerConfiguration configuration = new DefaultOfficeManagerConfiguration();
            configuration.setOfficeHome(officeHome);
            configuration.setPortNumber(8100);
            // 设置任务执行超时为5分钟
            configuration.setTaskExecutionTimeout(1000 * 60 * 5L);
            // 设置任务队列超时为24小时
            //configuration.setTaskQueueTimeout(1000 * 60 * 60 * 24L);
            officeManager = configuration.buildOfficeManager();
            officeManager.start();
        } catch (Exception e) {
            logger.error("启动office组件失败，请检查office组件是否可用");
            throw e;
        }
    }

    public OfficeDocumentConverter getDocumentConverter() {
        OfficeDocumentConverter converter = new OfficeDocumentConverter(officeManager, new ControlDocumentFormatRegistry());
        converter.setDefaultLoadProperties(getLoadProperties());
        return converter;
    }

    private Map<String,?> getLoadProperties() {
        Map<String,Object> loadProperties = new HashMap<>(10);
        loadProperties.put("Hidden", true);
        loadProperties.put("ReadOnly", true);
        loadProperties.put("UpdateDocMode", UpdateDocMode.QUIET_UPDATE);
        loadProperties.put("CharacterSet", Charset.forName("UTF-8").name());
        return loadProperties;
    }

    private boolean killProcess(String processName) {
        boolean flag = false;
        Properties props = System.getProperties();
        try {
            if (props.getProperty("os.name").toLowerCase().contains("windows")) {
                Process p = Runtime.getRuntime().exec("cmd /c tasklist ");
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                InputStream os = p.getInputStream();
                byte b[] = new byte[256];
                while (os.read(b) > 0) {
                    baos.write(b);
                }
                String s = baos.toString();
                if (s.indexOf(processName) >= 0) {
                    Runtime.getRuntime().exec("taskkill /im " + processName + " /f");
                    flag = true;
                } else {
                    flag = false;
                }
            } else {
                Process p = Runtime.getRuntime().exec(new String[]{"sh","-c","ps -ef | grep " + processName});
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                InputStream os = p.getInputStream();
                byte b[] = new byte[256];
                while (os.read(b) > 0) {
                    baos.write(b);
                }
                String s = baos.toString();
                if (StringUtils.ordinalIndexOf(s, processName, 3) > 0) {
                    String[] cmd ={"sh","-c","kill -15 `ps -ef|grep " + processName + "|awk 'NR==1{print $2}'`"};
                    Runtime.getRuntime().exec(cmd);
                    flag = true;
                } else {
                    flag = false;
                }
            }
        } catch (IOException e) {
            logger.error("检测office进程异常", e);
        }
        return flag;
    }

    @PreDestroy
    public void destroyOfficeManager(){
        if (null != officeManager && officeManager.isRunning()) {
            officeManager.stop();
        }
    }

}
