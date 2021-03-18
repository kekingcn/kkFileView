package cn.keking.model;

import cn.keking.config.ConfigConstants;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :文件类型，文本，office，压缩包等等
 */
public enum FileType {

    PICTURE("pictureFilePreviewImpl"),
    COMPRESS("compressFilePreviewImpl"),
    OFFICE("officeFilePreviewImpl"),
    SIMTEXT("simTextFilePreviewImpl"),
    PDF("pdfFilePreviewImpl"),
    CODE("codeFilePreviewImpl"),
    OTHER("otherFilePreviewImpl"),
    MEDIA("mediaFilePreviewImpl"),
    MARKDOWN("markdownFilePreviewImpl"),
    XML("xmlFilePreviewImpl"),
    FLV("flvFilePreviewImpl"),
    CAD("cadFilePreviewImpl"),
    TIFF("tiffFilePreviewImpl");


    private static final String[] OFFICE_TYPES = {"docx", "wps", "doc", "xls", "xlsx", "ppt", "pptx"};
    private static final String[] PICTURE_TYPES = {"jpg", "jpeg", "png", "gif", "bmp", "ico", "raw"};
    private static final String[] ARCHIVE_TYPES = {"rar", "zip", "jar", "7-zip", "tar", "gzip", "7z"};
    private static final String[] TIFF_TYPES = {"tif", "tiff"};
    private static final String[] SSIM_TEXT_TYPES = ConfigConstants.getSimText();
    private static final String[] CODES = {"java", "c", "php", "go", "python", "py", "js", "html", "ftl", "css", "lua", "sh", "rb", "yml", "json", "h", "cpp", "cs", "aspx", "jsp"};
    private static final String[] MEDIA_TYPES = ConfigConstants.getMedia();
    private static final Map<String, FileType> FILE_TYPE_MAPPER = new HashMap<>();

    static {
        for (String office : OFFICE_TYPES) {
            FILE_TYPE_MAPPER.put(office, FileType.OFFICE);
        }
        for (String picture : PICTURE_TYPES) {
            FILE_TYPE_MAPPER.put(picture, FileType.PICTURE);
        }
        for (String archive : ARCHIVE_TYPES) {
            FILE_TYPE_MAPPER.put(archive, FileType.COMPRESS);
        }
        for (String text : SSIM_TEXT_TYPES) {
            FILE_TYPE_MAPPER.put(text, FileType.SIMTEXT);
        }
        for (String media : MEDIA_TYPES) {
            FILE_TYPE_MAPPER.put(media, FileType.MEDIA);
        }
        for (String tif : TIFF_TYPES) {
            FILE_TYPE_MAPPER.put(tif, FileType.TIFF);
        }
        for (String code : CODES) {
            FILE_TYPE_MAPPER.put(code, FileType.CODE);
        }
        FILE_TYPE_MAPPER.put("md", FileType.MARKDOWN);
        FILE_TYPE_MAPPER.put("xml", FileType.XML);
        FILE_TYPE_MAPPER.put("pdf", FileType.PDF);
        FILE_TYPE_MAPPER.put("dwg", FileType.CAD);
        FILE_TYPE_MAPPER.put("flv", FileType.FLV);
    }

    private static FileType to(String fileType) {
        return FILE_TYPE_MAPPER.getOrDefault(fileType, OTHER);
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
