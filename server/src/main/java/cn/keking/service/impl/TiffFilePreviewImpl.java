package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.utils.ConvertPicUtil;
import cn.keking.utils.DownloadUtils;
import cn.keking.utils.KkFileUtils;
import cn.keking.utils.WebUtils;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.util.List;

/**
 * tiff 图片文件处理
 *
 * @author kl (http://kailing.pub)
 * @since 2021/2/8
 */
@Service
public class TiffFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    public TiffFilePreviewImpl(FileHandlerService fileHandlerService,OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
    }
    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String tifPreviewType = ConfigConstants.getTifPreviewType();
        String cacheName =  fileAttribute.getCacheName();
        String outFilePath = fileAttribute.getOutFilePath();
        boolean forceUpdatedCache=fileAttribute.forceUpdatedCache();
        if ("jpg".equalsIgnoreCase(tifPreviewType) || "pdf".equalsIgnoreCase(tifPreviewType)) {
            if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(cacheName) || !ConfigConstants.isCacheEnabled()) {
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }
                String filePath = response.getContent();
                if ("pdf".equalsIgnoreCase(tifPreviewType)) {
                    try {
                       ConvertPicUtil.convertJpg2Pdf(filePath, outFilePath);
                    } catch (Exception e) {
                        if (e.getMessage().contains("Bad endianness tag (not 0x4949 or 0x4d4d)") ) {
                            model.addAttribute("imgUrls", url);
                            model.addAttribute("currentUrl", url);
                            return PICTURE_FILE_PREVIEW_PAGE;
                        }else {
                            return otherFilePreview.notSupportedFile(model, fileAttribute, "TIF转pdf异常，请联系系统管理员!" );
                        }
                    }
                    //是否保留TIFF源文件
                    if (!fileAttribute.isCompressFile() && ConfigConstants.getDeleteSourceFile()) {
                      //  KkFileUtils.deleteFileByPath(filePath);
                    }
                    if (ConfigConstants.isCacheEnabled()) {
                        // 加入缓存
                        fileHandlerService.addConvertedFile(cacheName, fileHandlerService.getRelativePath(outFilePath));
                    }
                    model.addAttribute("pdfUrl", WebUtils.encodeFileName(cacheName));
                    return PDF_FILE_PREVIEW_PAGE;
                }else {
                    // 将tif转换为jpg，返回转换后的文件路径、文件名的list
                    List<String> listPic2Jpg;
                    try {
                        listPic2Jpg = ConvertPicUtil.convertTif2Jpg(filePath, outFilePath,forceUpdatedCache);
                    } catch (Exception e) {
                        if (e.getMessage().contains("Bad endianness tag (not 0x4949 or 0x4d4d)") ) {
                            model.addAttribute("imgUrls", url);
                            model.addAttribute("currentUrl", url);
                            return PICTURE_FILE_PREVIEW_PAGE;
                        }else {
                            return otherFilePreview.notSupportedFile(model, fileAttribute, "TIF转JPG异常，请联系系统管理员!" );
                        }
                    }
                    //是否保留源文件,转换失败保留源文件,转换成功删除源文件
                    if(!fileAttribute.isCompressFile() &&  ConfigConstants.getDeleteSourceFile()) {
                        KkFileUtils.deleteFileByPath(filePath);
                    }
                    if (ConfigConstants.isCacheEnabled()) {
                        // 加入缓存
                        fileHandlerService.putImgCache(cacheName, listPic2Jpg);
                        fileHandlerService.addConvertedFile(cacheName, fileHandlerService.getRelativePath(outFilePath));
                    }
                    model.addAttribute("imgUrls", listPic2Jpg);
                    model.addAttribute("currentUrl", listPic2Jpg.get(0));
                    return PICTURE_FILE_PREVIEW_PAGE;
                }
            }
            if ("pdf".equalsIgnoreCase(tifPreviewType)) {
                model.addAttribute("pdfUrl", WebUtils.encodeFileName(cacheName));
                return PDF_FILE_PREVIEW_PAGE;
            }
            else if ("jpg".equalsIgnoreCase(tifPreviewType)) {
                model.addAttribute("imgUrls",  fileHandlerService.getImgCache(cacheName));
                model.addAttribute("currentUrl", fileHandlerService.getImgCache(cacheName).get(0));
                return PICTURE_FILE_PREVIEW_PAGE;
            }
        }
        // 不是http开头，浏览器不能直接访问，需下载到本地
        if (url != null && !url.toLowerCase().startsWith("http")) {
            if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(fileName) || !ConfigConstants.isCacheEnabled()) {
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }
                model.addAttribute("currentUrl", fileHandlerService.getRelativePath(response.getContent()));
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileHandlerService.addConvertedFile(fileName, fileHandlerService.getRelativePath(outFilePath));
                }
            } else {
                model.addAttribute("currentUrl",  WebUtils.encodeFileName(fileName));
            }
            return TIFF_FILE_PREVIEW_PAGE;
        }
        model.addAttribute("currentUrl", url);
        return TIFF_FILE_PREVIEW_PAGE;
    }
}

