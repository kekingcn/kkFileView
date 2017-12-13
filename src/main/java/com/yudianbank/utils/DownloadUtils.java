package com.yudianbank.utils;

import com.yudianbank.param.ReturnResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import java.io.*;
import java.net.*;
import java.util.UUID;

/**
 * @author yudian-it
 */
@Component
public class DownloadUtils {

    @Value("${file.dir}")
    String fileDir;

    /**
     * 一开始测试的时候发现有些文件没有下载下来，而有些可以；当时也是郁闷了好一阵，但是最终还是不得解
     * 再次测试的时候，通过前台对比url发现，原来参数中有+号特殊字符存在，但是到后之后却变成了空格，突然恍然大悟
     * 应该是转义出了问题，url转义中会把+号当成空格来计算，所以才会出现这种情况，遂想要通过整体替换空格为加号，因为url
     * 中的参数部分是不会出现空格的，但是文件名中就不好确定了，所以只对url参数部分做替换
     * @param urlAddress
     * @param type
     * @param needEncode
     *      在处理本地文件(测试预览界面的，非ufile)的时候要对中文进行转码，
     *      因为tomcat对[英文字母（a-z，A-Z）、数字（0-9）、- _ . ~ 4个特殊字符以及所有保留字符]
     *      以外的字符会处理不正常，导致失败
     * @return
     */
    public ReturnResponse<String> downLoad(String urlAddress, String type, String fileName, String needEncode){
//        type = dealWithMS2013(type);
        ReturnResponse<String> response = new ReturnResponse<>(0, "下载成功!!!", "");
        URL url = null;
        try {
            if (null != needEncode) {
                urlAddress = encodeUrlParam(urlAddress);
                // 因为tomcat不能处理'+'号，所以讲'+'号替换成'%20%'
                urlAddress = urlAddress.replaceAll("\\+", "%20");
            }else{
                urlAddress = replacePlusMark(urlAddress);
            }
            url = new URL(urlAddress);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        UUID uuid = UUID.randomUUID();
        if (null == fileName) {
            fileName = uuid+ "."+type;
        }else { // 文件后缀不一致时，以type为准(针对simText【将类txt文件转为txt】)
            fileName = fileName.replace(fileName.substring(fileName.lastIndexOf(".") + 1), type);
        }
        String realPath = fileDir + fileName;
        File dirFile = new File(fileDir);
        if (!dirFile.exists()) {
            dirFile.mkdirs();
        }
        try {
            URLConnection connection = url.openConnection();
            InputStream in = connection.getInputStream();

            FileOutputStream os = new FileOutputStream(realPath);
            byte[] buffer = new byte[4 * 1024];
            int read;
            while ((read = in.read(buffer)) > 0) {
                os.write(buffer, 0, read);
            }
            os.close();
            in.close();
            response.setContent(realPath);
            // 同样针对类txt文件，如果成功msg包含的是转换后的文件名
            response.setMsg(fileName);
            return response;
        } catch (IOException e) {
            e.printStackTrace();
            response.setCode(1);
            response.setContent(null);
            if (e instanceof FileNotFoundException) {
                response.setMsg("文件不存在!!!");
            }else {
                response.setMsg(e.getMessage());
            }
            return response;
        }
    }

    /**
     * 转换url参数部分的空格为加号(因为在url编解码的过程中出现+转为空格的情况)
     * @param urlAddress
     * @return
     */
    private String replacePlusMark(String urlAddress) {
        String nonParamStr = urlAddress.substring(0,urlAddress.indexOf("?") + 1);
        String paramStr = urlAddress.substring(nonParamStr.length());
        return nonParamStr + paramStr.replace(" ", "+");
    }

    /**
     * 对最有一个路径进行转码
     * @param urlAddress
     *          http://192.168.2.111:8013/demo/Handle中文.zip
     * @return
     */
    private String encodeUrlParam(String urlAddress) {
        String newUrl = "";
        try {
            String path = "";
            String param = "";
            if (urlAddress.contains("?")) {
                path = urlAddress.substring(0, urlAddress.indexOf("?"));
                param = urlAddress.substring(urlAddress.indexOf("?") + 1);
            }else {
                path = urlAddress;
            }
            String lastPath = path.substring(path.lastIndexOf("/") + 1);
            String leftPath = path.substring(0, path.lastIndexOf("/") + 1);
            String encodeLastPath = URLEncoder.encode(lastPath, "UTF-8");
            newUrl += leftPath + encodeLastPath;
            if (urlAddress.contains("?")) {
                newUrl += param;
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return newUrl;
    }



    /**
     * 因为jodConvert2.1不支持ms2013版本的office转换，这里偷懒，尝试看改一下文件类型，让jodConvert2.1去
     * 处理ms2013，看结果如何，如果问题很大的话只能采取其他方式，如果没有问题，暂时使用该版本来转换
     * @param type
     * @return
     */
    private String dealWithMS2013(String type) {
        String newType = null;
        switch (type){
            case "docx":
                newType = "doc";
            break;
            case "xlsx":
                newType = "doc";
            break;
            case "pptx":
                newType = "ppt";
            break;
            default:
                newType = type;
            break;
        }
        return newType;
    }
}
