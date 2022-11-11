package cn.keking.utils;

import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.poi.extractor.ExtractorFactory;
import org.apache.poi.hssf.record.crypto.Biff8EncryptionKey;
import org.springframework.lang.Nullable;

import java.io.FileInputStream;
import java.io.IOException;

/**
 * Office工具类
 *
 * @author ylyue
 * @since 2022/7/5
 */
public class OfficeUtils {

    private static final String POI_INVALID_PASSWORD_MSG = "Invalid password specified";

    /**
     * 判断office（word,excel,ppt）文件是否受密码保护
     *
     * @param path office文件路径
     * @return 是否受密码保护
     */
    public static boolean isPwdProtected(String path) {
        try {
            ExtractorFactory.createExtractor(new FileInputStream(path));
        } catch (IOException e) {
            if (POI_INVALID_PASSWORD_MSG.equals(e.getMessage())) {
                return true;
            }
        } catch (Exception e) {
            Throwable[] throwableArray = ExceptionUtils.getThrowables(e);
            for (Throwable throwable : throwableArray) {
                if (throwable instanceof IOException && POI_INVALID_PASSWORD_MSG.equals(throwable.getMessage())) {
                    return true;
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
        try {
            Biff8EncryptionKey.setCurrentUserPassword(password);
            ExtractorFactory.createExtractor(new FileInputStream(path));
        } catch (Exception e) {
            return false;
        } finally {
            Biff8EncryptionKey.setCurrentUserPassword(null);
        }
        return true;
    }

}
