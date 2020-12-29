package cn.keking.model;

import cn.keking.config.ConfigConstants;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :文件类型，文本，office，压缩包等等
 */
public enum FileType {

    picture("pictureFilePreviewImpl"),
    compress("compressFilePreviewImpl"),
    office("officeFilePreviewImpl"),
    simText("simTextFilePreviewImpl"),
    pdf("pdfFilePreviewImpl"),
    other("otherFilePreviewImpl"),
    media("mediaFilePreviewImpl"),
    markdown("markdownFilePreviewImpl"),
    xml("xmlFilePreviewImpl"),
    flv("flvFilePreviewImpl"),
    cad("cadFilePreviewImpl");

    private static final String[] OFFICE_TYPES = {"docx", "doc", "xls", "xlsx", "ppt", "pptx"};
    private static final String[] PICTURE_TYPES = {"jpg", "jpeg", "png", "gif", "bmp", "ico", "raw"};
    private static final String[] ARCHIVE_TYPES = {"rar", "zip", "jar", "7-zip", "tar", "gzip", "7z"};
    private static final String[] SSIM_TEXT_TYPES = ConfigConstants.getSimText();
    private static final String[] MEDIA_TYPES = ConfigConstants.getMedia();
    private static final Map<String, FileType> FILE_TYPE_MAPPER = new HashMap<>();

    static {
        for (String office : OFFICE_TYPES) {
            FILE_TYPE_MAPPER.put(office, FileType.office);
        }
        for (String picture : PICTURE_TYPES) {
            FILE_TYPE_MAPPER.put(picture, FileType.picture);
        }
        for (String archive : ARCHIVE_TYPES) {
            FILE_TYPE_MAPPER.put(archive, FileType.compress);
        }
        for (String text : SSIM_TEXT_TYPES) {
            FILE_TYPE_MAPPER.put(text, FileType.simText);
        }
        for (String media : MEDIA_TYPES) {
            FILE_TYPE_MAPPER.put(media, FileType.media);
        }
        FILE_TYPE_MAPPER.put("md", FileType.markdown);
        FILE_TYPE_MAPPER.put("xml", FileType.xml);
        FILE_TYPE_MAPPER.put("pdf", FileType.pdf);
        FILE_TYPE_MAPPER.put("dwg", FileType.cad);
        FILE_TYPE_MAPPER.put("flv", FileType.flv);

    }

    private static FileType to(String fileType){
        return FILE_TYPE_MAPPER.getOrDefault(fileType,other);
    }
    /**
     * 查看文件类型(防止参数中存在.点号或者其他特殊字符，所以先抽取文件名，然后再获取文件类型)
     *
     * @param url url
     * @return 文件类型
     */
    public static FileType typeFromUrl(String url) {
        String nonPramStr = url.substring(0, url.contains("?") ? url.indexOf("?") : url.length());
        String fileName = nonPramStr.substring(nonPramStr.lastIndexOf("/") + 1);
        return typeFromFileName(fileName);
    }

    public static FileType typeFromFileName(String fileName) {
        String fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
        String lowerCaseFileType = fileType.toLowerCase();
        return FileType.to(lowerCaseFileType);
    }

    private final String instanceName;

    FileType(String instanceName) {
        this.instanceName = instanceName;
    }

    public String getInstanceName() {
        return instanceName;
    }

}
