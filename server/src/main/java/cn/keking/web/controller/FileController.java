package cn.keking.web.controller;

import cn.keking.config.ConfigConstants;
import cn.keking.model.ReturnResponse;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.HtmlUtils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

/**
 * @author yudian-it
 *  2017/12/1
 */
@RestController
public class FileController {

    private final Logger logger = LoggerFactory.getLogger(FileController.class);

    private final String fileDir = ConfigConstants.getFileDir();
    private final String demoDir = "demo";
    private final String demoPath = demoDir + File.separator;
    public static final String BASE64_DECODE_ERROR_MSG = "Base64解码失败，请检查你的 %s 是否采用 Base64 + urlEncode 双重编码了！";
    @PostMapping("/fileUpload")
    public ReturnResponse<Object> fileUpload(@RequestParam("file") MultipartFile file) {
        if (ConfigConstants.getFileUploadDisable()) {
            return ReturnResponse.failure("文件传接口已禁用");
        }
        // 获取文件名
        String fileName = file.getOriginalFilename();
        //判断是否为IE浏览器的文件名，IE浏览器下文件名会带有盘符信息

        // escaping dangerous characters to prevent XSS
        assert fileName != null;
        fileName = HtmlUtils.htmlEscape(fileName, StandardCharsets.UTF_8.name());

        // Check for Unix-style path
        int unixSep = fileName.lastIndexOf('/');
        // Check for Windows-style path
        int winSep = fileName.lastIndexOf('\\');
        // Cut off at latest possible point
        int pos = (Math.max(winSep, unixSep));
        if (pos != -1) {
            fileName = fileName.substring(pos + 1);
        }
        String fileType= "";
        int i = fileName.lastIndexOf('.');
        if (i > 0) {
            fileType= fileName.substring(i+1);
            fileType= fileType.toLowerCase();
        }
        if (fileType.length() == 0 || fileType.equals("dll") || fileType.equals("exe") || fileType.equals("msi") ){
            return ReturnResponse.failure(fileName+"不允许上传的文件");
        }
        // 判断是否存在同名文件
        if (existsFile(fileName)) {
            return ReturnResponse.failure("存在同名文件，请先删除原有文件再次上传");
        }
        File outFile = new File(fileDir + demoPath);
        if (!outFile.exists() && !outFile.mkdirs()) {
            logger.error("创建文件夹【{}】失败，请检查目录权限！", fileDir + demoPath);
        }
        logger.info("上传文件：{}", fileDir + demoPath + fileName);
        try (InputStream in = file.getInputStream(); OutputStream out = Files.newOutputStream(Paths.get(fileDir + demoPath + fileName))) {
            StreamUtils.copy(in, out);
            in.close();
            out.close();
            return ReturnResponse.success(null);
        } catch (IOException e) {
            logger.error("文件上传失败", e);
            return ReturnResponse.failure();
        }
    }

    @GetMapping("/deleteFile")
    public ReturnResponse<Object> deleteFile(String fileName) {
        if (fileName == null || fileName.length() == 0) {
            return ReturnResponse.failure("文件名为空，删除失败！");
        }
        try {
            fileName = WebUtils.decodeUrl(fileName);
        } catch (Exception ex) {
            String errorMsg = String.format(BASE64_DECODE_ERROR_MSG, "url");
            return ReturnResponse.failure(errorMsg+"删除失败！");
        }
        if (fileName.contains("/")) {
            fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
        }
        if (KkFileUtils.isIllegalFileName(fileName)) {
            return ReturnResponse.failure("非法文件名，删除失败！");
        }
        File file = new File(fileDir + demoPath + fileName);
        logger.info("删除文件：{}", file.getAbsolutePath());
        if (file.exists() && !file.delete()) {
            String msg = String.format("删除文件【%s】失败，请检查目录权限！", file.getPath());
            logger.error(msg);
            return ReturnResponse.failure(msg);
        }
        return ReturnResponse.success();
    }

    @GetMapping("/listFiles")
    public List<Map<String, String>> getFiles() {
        List<Map<String, String>> list = new ArrayList<>();
        File file = new File(fileDir + demoPath);
        if (file.exists()) {
            Arrays.stream(Objects.requireNonNull(file.listFiles())).forEach(file1 -> {
                Map<String, String> fileName = new HashMap<>();
                fileName.put("fileName", demoDir + "/" + file1.getName());
                list.add(fileName);
            });
        }
        return list;
    }

    private boolean existsFile(String fileName) {
        File file = new File(fileDir + demoPath + fileName);
        return file.exists();
    }
}
