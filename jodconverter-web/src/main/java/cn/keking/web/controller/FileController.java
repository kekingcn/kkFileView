package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 *
 * @author yudian-it
 * @date 2017/12/1
 */
@RestController
public class FileController {

    private final Logger logger = LoggerFactory.getLogger(FileController.class);

    private String fileDir = ConfigConstants.getFileDir();
    @Autowired
    private FileUtils fileUtils;
    private String demoDir = "demo";
    private String demoPath = demoDir + File.separator;

    @RequestMapping(value = "fileUpload", method = RequestMethod.POST)
    public String fileUpload(@RequestParam("file") MultipartFile file) throws JsonProcessingException {
        // 获取文件名
        String fileName = file.getOriginalFilename();
        //判断是否为IE浏览器的文件名，IE浏览器下文件名会带有盘符信息
        // Check for Unix-style path
        int unixSep = fileName.lastIndexOf('/');
        // Check for Windows-style path
        int winSep = fileName.lastIndexOf('\\');
        // Cut off at latest possible point
        int pos = (winSep > unixSep ? winSep : unixSep);
        if (pos != -1)  {
            fileName = fileName.substring(pos + 1);
        }
        // 判断是否存在同名文件
        if (existsFile(fileName)) {
            return new ObjectMapper().writeValueAsString(new ReturnResponse<String>(1, "存在同名文件，请先删除原有文件再次上传", null));
        }
        File outFile = new File(fileDir + demoPath);
        if (!outFile.exists()) {
            outFile.mkdirs();
        }
        logger.info("上传文件：{}", outFile.getAbsolutePath());
        try(InputStream in = file.getInputStream();
            OutputStream ot = new FileOutputStream(fileDir + demoPath + fileName)){
            byte[] buffer = new byte[1024];
            int len;
            while ((-1 != (len = in.read(buffer)))) {
                ot.write(buffer, 0, len);
            }
            return new ObjectMapper().writeValueAsString(new ReturnResponse<String>(0, "SUCCESS", null));
        } catch (IOException e) {
            logger.error("文件上传失败", e);
            return new ObjectMapper().writeValueAsString(new ReturnResponse<String>(1, "FAILURE", null));
        }
    }

    @RequestMapping(value = "deleteFile", method = RequestMethod.GET)
    public String deleteFile(String fileName) throws JsonProcessingException {
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }
        File file = new File(fileDir + demoPath + fileName);
        logger.info("删除文件：{}", file.getAbsolutePath());
        if (file.exists()) {
            file.delete();
        }
        return new ObjectMapper().writeValueAsString(new ReturnResponse<String>(0, "SUCCESS", null));
    }

    @RequestMapping(value = "listFiles", method = RequestMethod.GET)
    public String getFiles() throws JsonProcessingException {
        List<Map<String, String>> list = Lists.newArrayList();
        File file = new File(fileDir + demoPath);
        if (file.exists()) {
            Arrays.stream(file.listFiles()).forEach(file1 -> list.add(ImmutableMap.of("fileName", demoDir + "/" + file1.getName())));
        }
        return new ObjectMapper().writeValueAsString(list);
    }

    private String getFileName(String name) {
        String suffix = name.substring(name.lastIndexOf("."));
        String nameNoSuffix = name.substring(0, name.lastIndexOf("."));
        String uuid = UUID.randomUUID().toString();
        return uuid + "-" + nameNoSuffix + suffix;
    }

    /**
     * 是否存在该类型的文件
     * @return
     * @param fileName
     */
    private boolean existsFile(String fileName) {
        boolean result = false;
        File file = new File(fileDir + demoPath + fileName);
        if (file.exists()) {
            return true;
        }
        return result;
    }
}
