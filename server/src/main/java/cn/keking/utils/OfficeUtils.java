package cn.keking.utils;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.extractor.ExtractorFactory;
import org.apache.poi.hssf.record.crypto.Biff8EncryptionKey;
import org.springframework.lang.Nullable;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Office工具类
 *
 * @author ylyue
 * @since 2022/7/5
 */
public class OfficeUtils {

    private static final String POI_INVALID_PASSWORD_MSG = "password";

    /**
     * 判断office（word,excel,ppt）文件是否受密码保护
     *
     * @param path office文件路径
     * @return 是否受密码保护
     */
    public static boolean isPwdProtected(String path) {
        InputStream propStream = null;
        try {
            propStream = Files.newInputStream(Paths.get(path));
            ExtractorFactory.createExtractor(propStream);
        } catch (IOException | EncryptedDocumentException e) {
            if (e.getMessage().toLowerCase().contains(POI_INVALID_PASSWORD_MSG)) {
                return true;
            }
        } catch (Exception e) {
            Throwable[] throwableArray = ExceptionUtils.getThrowables(e);
            for (Throwable throwable : throwableArray) {
                if (throwable instanceof IOException || throwable instanceof EncryptedDocumentException) {
                    if (e.getMessage().toLowerCase().contains(POI_INVALID_PASSWORD_MSG)) {
                        return true;
                    }
                }
            }
        }finally {
            if(propStream!=null) {//如果文件输入流不是null
                try {
                    propStream.close();//关闭文件输入流
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
    /**
     * 判断office文件是否可打开（兼容）
     *
     * @param path     office文件路径
     * @param password 文件密码
     * @return 是否可打开（兼容）
     */
    public static synchronized boolean isCompatible(String path, @Nullable String password) {
        InputStream propStream = null;
        try {
            propStream = Files.newInputStream(Paths.get(path));
            Biff8EncryptionKey.setCurrentUserPassword(password);
            ExtractorFactory.createExtractor(propStream);
        } catch (Exception e) {
            return false;
        } finally {
            Biff8EncryptionKey.setCurrentUserPassword(null);
            if(propStream!=null) {//如果文件输入流不是null
                try {
                    propStream.close();//关闭文件输入流
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return true;
    }

}