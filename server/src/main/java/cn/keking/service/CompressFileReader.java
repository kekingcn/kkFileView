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
    public CompressFileReader(FileHandlerService fileHandlerService) {
        this.fileHandlerService = fileHandlerService;
    }
    public String unRar(String paths, String passWord, String fileName) throws Exception {
        List<String> imgUrls = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String archiveFileName = fileHandlerService.getFileNameFromPath(paths);
        RandomAccessFile randomAccessFile = null;
        IInArchive inArchive = null;
        try {
            randomAccessFile = new RandomAccessFile(paths, "r");
            inArchive = SevenZip.openInArchive(null, new RandomAccessFileInStream(randomAccessFile));
            String folderName = paths.substring(paths.lastIndexOf(File.separator) + 1);
            String extractPath = paths.substring(0, paths.lastIndexOf(folderName));
            ISimpleInArchive   simpleInArchive = inArchive.getSimpleInterface();
            final String[] str = {null};
            for (final ISimpleInArchiveItem item : simpleInArchive.getArchiveItems()) {
                if (!item.isFolder()) {
                    ExtractOperationResult result;
                    result = item.extractSlow(data -> {
                        try {
                             str[0] = RarUtils.getUtf8String(item.getPath());
                            if (RarUtils.isMessyCode(str[0])){
                                str[0] = new String(item.getPath().getBytes(StandardCharsets.ISO_8859_1), "gbk");
                            }
                            str[0] = str[0].replace("\\",  File.separator); //Linux 下路径错误
                            String  str1 = str[0].substring(0, str[0].lastIndexOf(File.separator)+ 1);
                            File file = new File(extractPath, folderName + "_" + File.separator + str1);
                            if (!file.exists()) {
                                file.mkdirs();
                            }
                            OutputStream out = new FileOutputStream( extractPath+ folderName + "_" + File.separator + str[0], true);
                            IOUtils.write(data, out);
                            out.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        return data.length;
                    }, passWord);
                    if (result == ExtractOperationResult.OK) {
                        FileType type = FileType.typeFromUrl(str[0]);
                        if (type.equals(FileType.PICTURE)) {
                          //  System.out.println( baseUrl +folderName + "_" + str[0]);
                            imgUrls.add(baseUrl +folderName + "_/" + str[0].replace("\\", "/"));
                        }
                        fileHandlerService.putImgCache(fileName, imgUrls);
                    } else {
                        return null;
                    }
                }
            }
            return archiveFileName + "_";
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
