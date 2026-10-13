package cn.keking.utils;

import net.sf.sevenzipjbinding.SevenZip;
import net.sf.sevenzipjbinding.SevenZipNativeInitializationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 在 Linux arm64（aarch64）上为 SevenZipJBinding 指定原生库所在的平台名。
 *
 * SevenZipJBinding 自动选择平台时，用 os.name 的第一个单词 + "-" + os.arch 作为平台名，
 * 在 aarch64 的 Linux 上得到的是 Linux-aarch64，而 arm64 原生库所在的目录是 Linux-arm64，
 * 两者不一致，即使原生库已在类路径上也会提示 Can't find suited platform，因此需要显式指定。
 * 其它平台不做任何处理，仍由 SevenZipJBinding 自动选择。
 */
public final class SevenZipNativePlatform {

    private static final Logger logger = LoggerFactory.getLogger(SevenZipNativePlatform.class);

    /**
     * sevenzipjbinding-linux-arm64 中原生库所在的目录名，也是初始化时使用的平台名
     */
    static final String LINUX_ARM64 = "Linux-arm64";

    private SevenZipNativePlatform() {
    }

    /**
     * 获取需要显式指定的平台名
     *
     * @param osName 系统属性 os.name
     * @param osArch 系统属性 os.arch
     * @return 平台名，返回 null 表示不指定，由 SevenZipJBinding 自动选择
     */
    static String explicitPlatform(String osName, String osArch) {
        if (osName == null || osArch == null) {
            return null;
        }
        // 与 SevenZipJBinding 一致，只取 os.name 的第一个单词
        if ("Linux".equals(osName.split(" ")[0]) && "aarch64".equals(osArch)) {
            return LINUX_ARM64;
        }
        return null;
    }

    /**
     * 在首次使用 SevenZip 之前调用。初始化失败只记录日志，不影响应用启动
     */
    public static void init() {
        String platform = explicitPlatform(System.getProperty("os.name"), System.getProperty("os.arch"));
        if (platform == null) {
            return;
        }
        try {
            SevenZip.initSevenZipFromPlatformJAR(platform);
            logger.info("SevenZipJBinding 原生库加载成功，平台: {}", platform);
        } catch (SevenZipNativeInitializationException | RuntimeException e) {
            logger.error("SevenZipJBinding 原生库加载失败，平台: {}，压缩文件将无法预览", platform, e);
        }
    }
}
