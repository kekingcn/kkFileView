package cn.keking.service;

import cn.keking.model.FileAttribute;
import org.springframework.ui.Model;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
public interface FilePreview {

    String FLV_FILE_PREVIEW_PAGE = "flv";
    String PDF_FILE_PREVIEW_PAGE = "pdf";
    String PPT_FILE_PREVIEW_PAGE = "ppt";
    String COMPRESS_FILE_PREVIEW_PAGE = "compress";
    String MEDIA_FILE_PREVIEW_PAGE = "media";
    String PICTURE_FILE_PREVIEW_PAGE = "picture";
    String TIFF_FILE_PREVIEW_PAGE = "tiff";
    String OFD_FILE_PREVIEW_PAGE = "ofd";
    String SVG_FILE_PREVIEW_PAGE = "svg";
    String Online3D_FILE_PAGE = "online3D";
    String EpubFilePreviewImpl = "epub";
    String XMIND_FILE_PREVIEW_PAGE = "xmind";
    String EML_FILE_PREVIEW_PAGE = "eml";
    String OFFICE_PICTURE_FILE_PREVIEW_PAGE = "officePicture";
    String TXT_FILE_PREVIEW_PAGE = "txt";
    String CODE_FILE_PREVIEW_PAGE = "code";
    String EXEL_FILE_PREVIEW_PAGE = "html";
    String XML_FILE_PREVIEW_PAGE = "xml";
    String MARKDOWN_FILE_PREVIEW_PAGE = "markdown";
    String BPMN_FILE_PREVIEW_PAGE = "bpmn";
    String NOT_SUPPORTED_FILE_PAGE = "fileNotSupported";

    String filePreviewHandle(String url, Model model, FileAttribute fileAttribute);
}
