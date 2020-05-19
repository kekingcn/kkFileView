package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import com.google.common.collect.Lists;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.*;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author yudian-it
 * @date 2017/11/13
 */
@Component
public class FileUtils {

    private static final String DEFAULT_CONVERTER_CHARSET = System.getProperty("sun.jnu.encoding");

    private final String fileDir = ConfigConstants.getFileDir();

    private final CacheService cacheService;

    public FileUtils(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    /**
     * @return 已转换过的文件集合(缓存)
     */
    public Map<String, String> listConvertedFiles() {
        return cacheService.getPDFCache();
    }

    /**
     * @return 已转换过的文件，根据文件名获取
     */
    public String getConvertedFile(String key) {
        return cacheService.getPDFCache(key);
    }

    /**
     * @param key pdf本地路径
     * @return 已将pdf转换成图片的图片本地相对路径
     */
    public Integer getConvertedPdfImage(String key) {
        return cacheService.getPdfImageCache(key);
    }

    /**
     * 查看文件类型(防止参数中存在.点号或者其他特殊字符，所以先抽取文件名，然后再获取文件类型)
     *
     * @param url url
     * @return 文件类型
     */
    public FileType typeFromUrl(String url) {
        String nonPramStr = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        return typeFromFileName(fileName);
    }

    private FileType typeFromFileName(String fileName) {
        String[] simText = ConfigConstants.getSimText();
        String[] media = ConfigConstants.getMedia();
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
        if (listPictureTypes().contains(fileType.toLowerCase())) {
            return FileType.picture;
        }
        if (listArchiveTypes().contains(fileType.toLowerCase())) {
            return FileType.compress;
        }
        if (listOfficeTypes().contains(fileType.toLowerCase())) {
            return FileType.office;
        }
        if (Arrays.asList(simText).contains(fileType.toLowerCase())) {
            return FileType.simText;
        }
        if (Arrays.asList(media).contains(fileType.toLowerCase())) {
            return FileType.media;
        }
        if ("pdf".equalsIgnoreCase(fileType)) {
            return FileType.pdf;
        }
        if ("dwg".equalsIgnoreCase(fileType)) {
            return FileType.cad;
        }
        return FileType.other;
    }
    /**
     * 从url中剥离出文件名
     * @param url
     *      格式如：http://keking.ufile.ucloud.com.cn/20171113164107_月度绩效表模板(新).xls?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=I D1NOFtAJSPT16E6imv6JWuq0k=
     * @return 文件名
     */
    public String getFileNameFromURL(String url) {
        // 因为url的参数中可能会存在/的情况，所以直接url.lastIndexOf("/")会有问题
        // 所以先从？处将url截断，然后运用url.lastIndexOf("/")获取文件名
        String noQueryUrl = url.substring(0, url.contains("?") ? url.indexOf("?"): url.length());
        return noQueryUrl.substring(noQueryUrl.lastIndexOf("/") + 1);
    }

    /**
     * 从路径中获取文件负
     * @param path
     *      类似这种：C:\Users\yudian-it\Downloads
     * @return 文件名
     */
    public String getFileNameFromPath(String path) {
        return path.substring(path.lastIndexOf(File.separator) + 1);
    }

    public List<String> listPictureTypes(){
        List<String> list = Lists.newArrayList();
        list.add("jpg");
        list.add("jpeg");
        list.add("png");
        list.add("gif");
        list.add("bmp");
        list.add("ico");
        list.add("RAW");
        return list;
    }

    public List<String> listArchiveTypes(){
        List<String> list = Lists.newArrayList();
        list.add("rar");
        list.add("zip");
        list.add("jar");
        list.add("7-zip");
        list.add("tar");
        list.add("gzip");
        list.add("7z");
        return list;
    }

    public List<String> listOfficeTypes() {
        List<String> list = Lists.newArrayList();
        list.add("docx");
        list.add("doc");
        list.add("xls");
        list.add("xlsx");
        list.add("ppt");
        list.add("pptx");
        return list;
    }

    /**
     * 获取相对路径
     * @param absolutePath 绝对路径
     * @return 相对路径
     */
    public String getRelativePath(String absolutePath) {
        return absolutePath.substring(fileDir.length());
    }

    /**
     * 添加转换后PDF缓存
     * @param fileName pdf文件名
     * @param value 缓存相对路径
     */
    public void addConvertedFile(String fileName, String value){
        cacheService.putPDFCache(fileName, value);
    }

    /**
     * 添加转换后图片组缓存
     * @param pdfFilePath pdf文件绝对路径
     * @param num 图片张数
     */
    public void addConvertedPdfImage(String pdfFilePath, int num){
        cacheService.putPdfImageCache(pdfFilePath, num);
    }

    /**
     * 获取redis中压缩包内图片文件
     * @param fileKey fileKey
     * @return 图片文件访问url列表
     */
    public List<String> getImgCache(String fileKey){
        return cacheService.getImgCache(fileKey);
    }

    /**
     * 设置redis中压缩包内图片文件
     * @param fileKey fileKey
     * @param imgs 图片文件访问url列表
     */
    public void putImgCache(String fileKey,List<String> imgs){
        cacheService.putImgCache(fileKey, imgs);
    }
    /**
     * 判断文件编码格式
     * @param path 绝对路径
     * @return 编码格式
     */
    public String getFileEncodeUTFGBK(String path){
        String enc = Charset.forName("GBK").name();
        File file = new File(path);
        InputStream in;
        try {
            in = new FileInputStream(file);
            byte[] b = new byte[3];
            in.read(b);
            in.close();
            if (b[0] == -17 && b[1] == -69 && b[2] == -65) {
                enc = StandardCharsets.UTF_8.name();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("文件编码格式为:" + enc);
        return enc;
    }

    /**
     * 对转换后的文件进行操作(改变编码方式)
     * @param outFilePath 文件绝对路径
     */
    public void doActionConvertedFile(String outFilePath) {
        StringBuilder sb = new StringBuilder();
        try (InputStream inputStream = new FileInputStream(outFilePath);
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, DEFAULT_CONVERTER_CHARSET))){
            String line;
            while(null != (line = reader.readLine())){
                if (line.contains("charset=gb2312")) {
                    line = line.replace("charset=gb2312", "charset=utf-8");
                }
                sb.append(line);
            }
            // 添加sheet控制头
            sb.append("<script src=\"js/jquery-3.0.0.min.js\" type=\"text/javascript\"></script>");
            sb.append("<script src=\"js/excel.header.js\" type=\"text/javascript\"></script>");
            sb.append("<link rel=\"stylesheet\" href=\"bootstrap/css/bootstrap.min.css\">");
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 重新写入文件
        try(FileOutputStream fos = new FileOutputStream(outFilePath);
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, StandardCharsets.UTF_8))) {
            writer.write(sb.toString());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    /**
     * 获取文件后缀
     * @param url url
     * @return 文件后缀
     */
    private String suffixFromUrl(String url) {
        String nonPramStr = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        return suffixFromFileName(fileName);
    }

    private String suffixFromFileName(String fileName) {
        return fileName.substring(fileName.lastIndexOf(".") + 1);
    }

    /**
     * 获取url中的参数
     * @param url url
     * @param name 参数名
     * @return 参数值
     */
    public String getUrlParameterReg(String url, String name) {
        Map<String, String> mapRequest = new HashMap<>();
        String strUrlParam = truncateUrlPage(url);
        if (strUrlParam == null) {
            return "";
        }
        //每个键值为一组
        String[] arrSplit = strUrlParam.split("[&]");
        for(String strSplit : arrSplit) {
            String[] arrSplitEqual = strSplit.split("[=]");
            //解析出键值
            if(arrSplitEqual.length > 1) {
                //正确解析
                mapRequest.put(arrSplitEqual[0], arrSplitEqual[1]);
            } else if (!arrSplitEqual[0].equals("")) {
                //只有参数没有值，不加入
                mapRequest.put(arrSplitEqual[0], "");
            }
        }
        return mapRequest.get(name);
    }

    /**
     * 去掉url中的路径，留下请求参数部分
     * @param strURL url地址
     * @return url请求参数部分
     */
    private String truncateUrlPage(String strURL) {
        String strAllParam = null;
        strURL = strURL.trim();
        String[] arrSplit = strURL.split("[?]");
        if(strURL.length() > 1)  {
            if(arrSplit.length > 1) {
                if(arrSplit[1] != null) {
                    strAllParam=arrSplit[1];
                }
            }
        }
        return strAllParam;
    }

    /**
     * 获取文件属性
     * @param url url
     * @return 文件属性
     */
    public FileAttribute getFileAttribute(String url) {
        String fileName;
        FileType type;
        String suffix;
        String fullFileName = getUrlParameterReg(url, "fullfilename");
        if (!StringUtils.isEmpty(fullFileName)) {
            fileName = fullFileName;
            type = typeFromFileName(fileName);
            suffix = suffixFromFileName(fileName);
        } else {
            fileName = getFileNameFromURL(url);
            type = typeFromUrl(url);
            suffix = suffixFromUrl(url);
        }
        return new FileAttribute(type,suffix,fileName,url);
    }
}
