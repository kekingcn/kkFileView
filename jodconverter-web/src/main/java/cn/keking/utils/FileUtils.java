package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.service.cache.CacheService;
import com.google.common.collect.Lists;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.*;
import java.nio.charset.Charset;
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

    public static final String DEFAULT_CONVERTER_CHARSET = System.getProperty("sun.jnu.encoding");

    Logger log= LoggerFactory.getLogger(getClass());

    @Autowired
    CacheService cacheService;

    String fileDir = ConfigConstants.getFileDir();

    /**
     * 已转换过的文件集合(redis缓存)
     * @return
     */
    public Map<String, String> listConvertedFiles() {
        return cacheService.getPDFCache();
    }

    /**
     * 已转换过的文件，根据文件名获取
     * @return
     */
    public String getConvertedFile(String key) {
        return cacheService.getPDFCache(key);
    }

    /**
     * 已将pdf转换成图片的图片本地路径
     * @param key pdf本地路径
     * @return
     */
    public Integer getConvertedPdfImage(String key) {
        return cacheService.getPdfImageCache(key);
    }

    /**
     * 查看文件类型(防止参数中存在.点号或者其他特殊字符，所以先抽取文件名，然后再获取文件类型)
     *
     * @param url
     * @return
     */
    public FileType typeFromUrl(String url) {
        String nonPramStr = url.substring(0, url.indexOf("?") != -1 ? url.indexOf("?") : url.length());
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
     * 从URL中解析出文件名
     *
     * @param url
     * @return
     */
    private String getFilenameFromQuery(String url) {
        return UrlUtils.getFilenameFromUrl(url);
    }

    /**
     * 获取文件后缀
     * @param fileName
     * @return
     */
    public String getSuffixFromFileName(String fileName) {
        String suffix = fileName.substring(fileName.lastIndexOf("."));
        return suffix;
    }

    /**
     * 从路径中获取
     * @param path
     *      类似这种：C:\Users\yudian-it\Downloads
     * @return
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
     * @param absolutePath
     * @return
     */
    public String getRelativePath(String absolutePath) {
        return absolutePath.substring(fileDir.length());
    }

    public void addConvertedFile(String fileName, String value){
        cacheService.putPDFCache(fileName, value);
    }

    /**
     *
     * @param pdfFilePath
     * @param num
     */
    public void addConvertedPdfImage(String pdfFilePath, int num){
        cacheService.putPdfImageCache(pdfFilePath, num);
    }

    /**
     * 获取redis中压缩包内图片文件
     * @param fileKey
     * @return
     */
    public List getRedisImgUrls(String fileKey){
        return cacheService.getImgCache(fileKey);
    }

    /**
     * 设置redis中压缩包内图片文件
     * @param fileKey
     * @param imgs
     */
    public void setRedisImgUrls(String fileKey,List imgs){
        cacheService.putImgCache(fileKey, imgs);
    }
    /**
     * 判断文件编码格式
     * @param path
     * @return
     */
    public String getFileEncodeUTFGBK(String path){
        String enc = Charset.forName("GBK").name();
        File file = new File(path);
        InputStream in= null;
        try {
            in = new FileInputStream(file);
            byte[] b = new byte[3];
            in.read(b);
            in.close();
            if (b[0] == -17 && b[1] == -69 && b[2] == -65) {
                enc = Charset.forName("UTF-8").name();
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("文件编码格式为:" + enc);
        return enc;
    }

    /**
     * 对转换后的文件进行操作(改变编码方式)
     * @param outFilePath
     */
    public void doActionConvertedFile(String outFilePath) {
        StringBuffer sb = new StringBuffer();
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
            sb.append("<link rel=\"stylesheet\" href=\"//cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css\">");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 重新写入文件
        try(FileOutputStream fos = new FileOutputStream(outFilePath);
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(fos, "utf-8"))) {
            writer.write(sb.toString());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String suffixFromFileName(String fileName) {
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
        return fileType;
    }

    /**
     * 获取url中的参数
     * @param url
     * @param name
     * @return
     */
    public String getUrlParameterReg(String url, String name) {
        return UrlUtils.getQueryMap(url).get(name);
    }

    public FileAttribute getFileAttribute(String url) {
        String fileName = "";
        FileType type = null;
        String suffix = "";
        String fullFileName = getFilenameFromQuery(url);
        if (!StringUtils.isEmpty(fullFileName)) {
            fileName = fullFileName;
            type = typeFromFileName(fileName);
            suffix = suffixFromFileName(fileName);
        }
        return new FileAttribute(type,suffix,fileName,url,url);
    }
}
