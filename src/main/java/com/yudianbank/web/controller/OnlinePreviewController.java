package com.yudianbank.web.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.yudianbank.param.ReturnResponse;
import com.yudianbank.utils.DownloadUtils;
import com.yudianbank.utils.FileUtils;
import com.yudianbank.utils.OfficeToPdf;
import com.yudianbank.utils.ZipReader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

/**
 * @author yudian-it
 */
@Controller
public class OnlinePreviewController {
    @Autowired
    private OfficeToPdf officeToPdf;
    @Autowired
    FileUtils fileUtils;
    @Autowired
    DownloadUtils downloadUtils;
    @Autowired
    ZipReader zipReader;

    @Value("${file.dir}")
    String fileDir;

    /**
     * xls:http://keking.ufile.ucloud.com.cn/20171113164107_月度绩效表模板(新).xls?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=I+D1NOFtAJSPT16E6imv6JWuq0k=
     * img:http://keking.ufile.ucloud.com.cn/ufile-a703a5a2-788f-488c-a9bf-f36878d5e308.JPG?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=W9TKj5Kp9oxg85fn5/0zgwF2PL4=
     * doc:http://keking.ufile.ucloud.com.cn/20171113173342_凯京新员工试用期评估与转正确认表.doc?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=v1fC5ijYs8WnPzbSYa/bb0Z2Jf4=
     * docx:http://keking.ufile.ucloud.com.cn/20171103180053_财产线索类需求20170920(1).docx?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=p7/L1W3iwktzRtkY5Ef2vK7kn3o=
     * @param url
     * @param model
     * @return
     */
    @RequestMapping(value = "onlinePreview",method = RequestMethod.GET)
    public String onlinePreview(String url, String needEncode, Model model) throws UnsupportedEncodingException {
        // 路径转码
        url = URLDecoder.decode(url, "utf-8");
        String type = typeFromUrl(url);
        String suffix = suffixFromUrl(url);
        model.addAttribute("fileType", suffix);
        if (type.equalsIgnoreCase("picture")) {
            model.addAttribute("imgurl", url);
            return "picture";
        } else if (type.equalsIgnoreCase("txt")
                || type.equalsIgnoreCase("html")
                || type.equalsIgnoreCase("xml")
                || type.equalsIgnoreCase("java")
                || type.equalsIgnoreCase("properties")
                || type.equalsIgnoreCase("mp3")){
            model.addAttribute("ordinaryUrl",url);
            return "txt";
        } else if(type.equalsIgnoreCase("pdf")){
            model.addAttribute("pdfUrl",url);
            return "pdf";
        } else if(type.equalsIgnoreCase("compress")){
            // 抽取文件并返回文件列表
            String fileName = fileUtils.getFileNameFromURL(url);
            String fileTree = null;
            // 判断文件名是否存在(redis缓存读取)
            if (!StringUtils.hasText(fileUtils.getConvertedFile(fileName))) {
                ReturnResponse<String> response = downloadUtils.downLoad(url, suffix, fileName, needEncode);
                if (0 != response.getCode()) {
                    model.addAttribute("msg", response.getMsg());
                    return "fileNotSupported";
                }
                String filePath = response.getContent();
                if ("zip".equalsIgnoreCase(suffix)
                        || "jar".equalsIgnoreCase(suffix)
                        || "gzip".equalsIgnoreCase(suffix)) {
                    fileTree = zipReader.readZipFile(filePath);
                } else if ("rar".equalsIgnoreCase(suffix)) {
                    fileTree = zipReader.unRar(filePath);
                }
                fileUtils.addConvertedFile(fileName, fileTree);
            }else {
                fileTree = fileUtils.getConvertedFile(fileName);
            }
            System.out.println("返回文件tree》》》》》》》》》》》》》》》》》》》");
            if (null != fileTree) {
                model.addAttribute("fileTree",fileTree);
                return "compress";
            }else {
                model.addAttribute("msg", "压缩文件类型不受支持，尝试在压缩的时候选择RAR4格式");
                return "fileNotSupported";
            }
        } else if ("office".equalsIgnoreCase(type)) {
            String fileName = fileUtils.getFileNameFromURL(url);
            String pdfName = fileName.substring(0, fileName.lastIndexOf(".") + 1)
                    + ((suffix.equalsIgnoreCase("xls") || suffix.equalsIgnoreCase("xlsx")) ?
                    "html" : "pdf");
            // 判断之前是否已转换过，如果转换过，直接返回，否则执行转换
            if (!fileUtils.listConvertedFiles().containsKey(pdfName)) {
                String filePath = fileDir + fileName;
                if (!new File(filePath).exists()) {
                    ReturnResponse<String> response = downloadUtils.downLoad(url, suffix, null, needEncode);
                    if (0 != response.getCode()) {
                        model.addAttribute("msg", response.getMsg());
                        return "fileNotSupported";
                    }
                    filePath = response.getContent();
                }
                String outFilePath = fileDir + pdfName;
                if (StringUtils.hasText(outFilePath)) {
                    officeToPdf.openOfficeToPDF(filePath, outFilePath);
                    File f = new File(filePath);
                    if (f.exists()) {
                        f.delete();
                    }
                    if (suffix.equalsIgnoreCase("xls")
                            || suffix.equalsIgnoreCase("xlsx")) {
                        // 对转换后的文件进行操作(改变编码方式)
                        fileUtils.doActionConvertedFile(outFilePath);
                    }
                    // 加入缓存
                    fileUtils.addConvertedFile(pdfName, fileUtils.getRelativePath(outFilePath));
                }
            }
            model.addAttribute("pdfUrl", pdfName);
            return "pdf";
        }else {
            model.addAttribute("msg", "系统还不支持该格式文件的在线预览，" + "如有需要请按下方显示的邮箱地址联系系统维护人员");
            return "fileNotSupported";
        }
    }

    private String suffixFromUrl(String url) {
        String nonPramStr = url.substring(0, url.indexOf("?") != -1 ? url.indexOf("?"): url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
        return fileType;
    }

    /**
     * 查看文件类型(防止参数中存在.点号或者其他特殊字符，所以先抽取文件名，然后再获取文件类型)
     * @param url
     * @return
     */
    private String typeFromUrl(String url) {
        String nonPramStr = url.substring(0, url.indexOf("?") != -1 ? url.indexOf("?"): url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
        if (fileUtils.listPictureTypes().contains(fileType.toLowerCase())) {
            fileType = "picture";
        }
        if (fileUtils.listArchiveTypes().contains(fileType.toLowerCase())) {
            fileType = "compress";
        }
        if (fileUtils.listOfficeTypes().contains(fileType.toLowerCase())) {
            fileType = "office";
        }
        return fileType;
    }


}
