package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileType;
import cn.keking.utils.RarUtils;
import cn.keking.web.filter.BaseUrlFilter;
import net.sf.sevenzipjbinding.ExtractOperationResult;
import net.sf.sevenzipjbinding.IInArchive;
import net.sf.sevenzipjbinding.SevenZip;
import net.sf.sevenzipjbinding.SevenZipException;
import net.sf.sevenzipjbinding.impl.RandomAccessFileInStream;
import net.sf.sevenzipjbinding.simple.ISimpleInArchive;
import net.sf.sevenzipjbinding.simple.ISimpleInArchiveItem;
import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.ObjectUtils;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * @author yudian-it
 * create 2017/11/27
 */
@Component
public class CompressFileReader {
    private final FileHandlerService fileHandlerService;
    private static final String fileDir = ConfigConstants.getFileDir();
    public CompressFileReader(FileHandlerService fileHandlerService) {
        this.fileHandlerService = fileHandlerService;
    }
    public String unRar(String filePath, String filePassword, String fileName, String fileKey) throws Exception {
        List<String> imgUrls = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String packagePath = "_"; //防止文件名重复 压缩包统一生成文件添加_符号
        String folderName =  filePath.replace(fileDir, ""); //修复压缩包 多重目录获取路径错误
        if (!ObjectUtils.isEmpty(fileKey)) { //压缩包文件 直接赋予路径 不予下载
              folderName = "_decompression"+folderName;  //重新修改多重压缩包 生成文件路径
        }
        RandomAccessFile randomAccessFile = null;
        IInArchive inArchive = null;
        try {
            randomAccessFile = new RandomAccessFile(filePath, "r");
            inArchive = SevenZip.openInArchive(null, new RandomAccessFileInStream(randomAccessFile));
            ISimpleInArchive   simpleInArchive = inArchive.getSimpleInterface();
            final String[] str = {null};
            for (final ISimpleInArchiveItem item : simpleInArchive.getArchiveItems()) {
                if (!item.isFolder()) {
                    ExtractOperationResult result;
                    String finalFolderName = folderName;
                    result = item.extractSlow(data -> {
                        try {
                            str[0] = RarUtils.getUtf8String(item.getPath());
                            if (RarUtils.isMessyCode(str[0])){
                                str[0] = new String(item.getPath().getBytes(StandardCharsets.ISO_8859_1), "gbk");
                            }
                            str[0] = str[0].replace("\\",  File.separator); //Linux 下路径错误
                            String  str1 = str[0].substring(0, str[0].lastIndexOf(File.separator)+ 1);
                            File file = new File(fileDir, finalFolderName + packagePath + File.separator + str1);
                            if (!file.exists()) {
                                file.mkdirs();
                            }
                            OutputStream out = new FileOutputStream( fileDir+ finalFolderName + packagePath + File.separator + str[0], true);
                            IOUtils.write(data, out);
                            out.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                            return Integer.parseInt(null);
                        }
                        return data.length;
                    }, filePassword);
                    if (result == ExtractOperationResult.OK) {
                        FileType type = FileType.typeFromUrl(str[0]);
                        if (type.equals(FileType.PICTURE)) {
                            imgUrls.add(baseUrl +folderName + packagePath +"/" + str[0].replace("\\", "/"));
                        }
                        fileHandlerService.putImgCache(fileName+ packagePath, imgUrls);
                    } else {
                        return null;
                    }
                }
            }
            return folderName + packagePath;
        } catch (Exception e) {
            throw new Exception(e);
        } finally {
            if (inArchive != null) {
                try {
                    inArchive.close();
                } catch (SevenZipException e) {
                    System.err.println("Error closing archive: " + e);
                }
            }
            if (randomAccessFile != null) {
                try {
                    randomAccessFile.close();
                } catch (IOException e) {
                    System.err.println("Error closing file: " + e);
                }
            }
        }
    }

}
