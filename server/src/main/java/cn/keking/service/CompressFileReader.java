package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
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
import org.springframework.stereotype.Component;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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

    public String unRar(String filePath, String filePassword, String fileName, FileAttribute fileAttribute) throws Exception {
        List<String> imgUrls = new ArrayList<>();
        String baseUrl = BaseUrlFilter.getBaseUrl();
        String packagePath = "_";
        String folderName = filePath.replace(fileDir, ""); //修复压缩包 多重目录获取路径错误
        if (fileAttribute.isCompressFile()) {
            folderName = "_decompression" + folderName;
        }
        Path folderPath = Paths.get(fileDir, folderName + packagePath);
        Files.createDirectories(folderPath);

        try (RandomAccessFile randomAccessFile = new RandomAccessFile(filePath, "r");
             IInArchive inArchive = SevenZip.openInArchive(null, new RandomAccessFileInStream(randomAccessFile))) {

            ISimpleInArchive simpleInArchive = inArchive.getSimpleInterface();
            for (final ISimpleInArchiveItem item : simpleInArchive.getArchiveItems()) {
                if (!item.isFolder()) {
                    final Path filePathInsideArchive = getFilePathInsideArchive(item, folderPath);
                    ExtractOperationResult result = item.extractSlow(data -> {
                        try (OutputStream out = new BufferedOutputStream(new FileOutputStream(filePathInsideArchive.toFile(), true))) {
                            out.write(data);
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        return data.length;
                    }, filePassword);
                    if (result != ExtractOperationResult.OK) {
                        ExtractOperationResult result1 = ExtractOperationResult.valueOf("WRONG_PASSWORD");
                        if (result1.equals(result)) {
                            throw new Exception("Password");
                        }else {
                            throw new Exception("Failed to extract RAR file.");
                        }
                    }

                    FileType type = FileType.typeFromUrl(filePathInsideArchive.toString());
                    if (type.equals(FileType.PICTURE)) {  //图片缓存到集合，为了特殊符号需要进行编码
                        imgUrls.add(baseUrl + URLEncoder.encode(fileName + packagePath+"/"+ folderPath.relativize(filePathInsideArchive).toString().replace("\\", "/"), "UTF-8"));
                    }
                }
            }
            fileHandlerService.putImgCache(fileName + packagePath, imgUrls);
        } catch (Exception e) {
            throw new Exception("Error processing RAR file: " + e.getMessage(), e);
        }
        return folderName + packagePath;
    }

    private Path getFilePathInsideArchive(ISimpleInArchiveItem item, Path folderPath) throws SevenZipException, UnsupportedEncodingException {
        String insideFileName = RarUtils.getUtf8String(item.getPath());
        if (RarUtils.isMessyCode(insideFileName)) {
            insideFileName = new String(item.getPath().getBytes(StandardCharsets.ISO_8859_1), "gbk");
        }

        // 正规化路径并验证是否安全
        Path normalizedPath = folderPath.resolve(insideFileName).normalize();
        if (!normalizedPath.startsWith(folderPath)) {
            throw new SecurityException("Unsafe path detected: " + insideFileName);
        }

        try {
            Files.createDirectories(normalizedPath.getParent());
        } catch (IOException e) {
            throw new RuntimeException("Failed to create directory: " + normalizedPath.getParent(), e);
        }
        return normalizedPath;
    }


}