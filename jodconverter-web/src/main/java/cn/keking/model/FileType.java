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
    cad("cadFilePreviewImpl");

    private static final String[] OFFICE_TYPES = {"docx", "doc", "xls", "xlsx", "ppt", "pptx"};
    private static final String[] PICTURE_TYPES = {"jpg", "jpeg", "png", "gif", "bmp", "ico", "RAW"};
    private static final String[] ARCHIVE_TYPES = {"rar", "zip", "jar", "7-zip", "tar", "gzip", "7z"};
    private static final String[] SIMTEXT_TYPES = ConfigConstants.getSimText();
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
        for (String text : SIMTEXT_TYPES) {
            FILE_TYPE_MAPPER.put(text, FileType.simText);
        }
        for (String media : MEDIA_TYPES) {
            FILE_TYPE_MAPPER.put(media, FileType.media);
        }
        FILE_TYPE_MAPPER.put("md", FileType.markdown);
        FILE_TYPE_MAPPER.put("xml", FileType.xml);
        FILE_TYPE_MAPPER.put("pdf", FileType.pdf);
        FILE_TYPE_MAPPER.put("dwg", FileType.cad);
    }

    public static FileType to(String fileType){
        return FILE_TYPE_MAPPER.getOrDefault(fileType,other);
    }

    private final String instanceName;

    FileType(String instanceName) {
        this.instanceName = instanceName;
    }

    public String getInstanceName() {
        return instanceName;
    }

}
