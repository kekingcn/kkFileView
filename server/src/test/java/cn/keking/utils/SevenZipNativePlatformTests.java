package cn.keking.utils;

import net.sf.sevenzipjbinding.SevenZip;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Properties;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Linux arm64（aarch64）压缩包预览回归测试。
 *
 * 背景：sevenzipjbinding-all-platforms 不包含 Linux arm64 的原生库，并且 SevenZipJBinding 按
 * os.name + "-" + os.arch 拼出的平台名是 Linux-aarch64，与原生库所在目录 Linux-arm64 不一致，
 * 导致 aarch64 的 Linux 上所有压缩包都无法预览。
 *
 * 运行测试的机器通常不是 arm64，无法真正加载该原生库，这里校验加载之前的各个环节：
 * 原生库在类路径上且是 AArch64 的 ELF 文件；Linux + aarch64 时指定的平台名与原生库所在目录一致；
 * 其它平台不指定平台名，仍由 SevenZipJBinding 自动选择。
 */
class SevenZipNativePlatformTests {

    private static final int ELF_MACHINE_X86_64 = 62;
    private static final int ELF_MACHINE_AARCH64 = 183;

    @Test
    void shouldShipLinuxArm64NativeLibrary() throws Exception {
        assertEquals(ELF_MACHINE_AARCH64, elfMachineOfNativeLibrary("Linux-arm64"));
    }

    @Test
    void shouldSelectLinuxArm64PlatformOnLinuxAarch64() throws Exception {
        String platform = SevenZipNativePlatform.explicitPlatform("Linux", "aarch64");

        assertEquals("Linux-arm64", platform);
        // 指定的平台名必须能定位到 AArch64 的原生库
        assertEquals(ELF_MACHINE_AARCH64, elfMachineOfNativeLibrary(platform));
    }

    @Test
    void shouldLeaveOtherPlatformsToAutomaticSelection() {
        assertNull(SevenZipNativePlatform.explicitPlatform("Linux", "amd64"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Linux", "i386"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Linux", "arm"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Windows 11", "amd64"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Windows Server 2022", "aarch64"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Mac OS X", "aarch64"));
        assertNull(SevenZipNativePlatform.explicitPlatform("Mac OS X", "x86_64"));
        assertNull(SevenZipNativePlatform.explicitPlatform(null, null));
    }

    /**
     * 对照：原有平台仍在 SevenZipJBinding 读取到的平台列表中，原生库也仍能取到。
     * 如果 arm64 的 jar 在类路径上排到 all-platforms 之前，平台列表会只剩 Linux-arm64 一项，
     * 所有平台都会去加载 arm64 的原生库。
     */
    @Test
    void shouldKeepExistingPlatformsAvailable() throws Exception {
        List<String> platforms = SevenZip.getPlatformList();

        assertTrue(platforms.contains("Windows-amd64"), () -> "listed platforms: " + platforms);
        assertTrue(platforms.contains("Linux-amd64"), () -> "listed platforms: " + platforms);
        assertNotNull(nativeLibraryHeader("Windows-amd64"));
        assertEquals(ELF_MACHINE_X86_64, elfMachineOfNativeLibrary("Linux-amd64"));
    }

    private static int elfMachineOfNativeLibrary(String platform) throws IOException {
        byte[] header = nativeLibraryHeader(platform);
        assertTrue(header[0] == 0x7f && header[1] == 'E' && header[2] == 'L' && header[3] == 'F',
                () -> platform + " native library is not an ELF file");
        return (header[18] & 0xff) | ((header[19] & 0xff) << 8);
    }

    /**
     * 与 SevenZipJBinding 定位原生库的方式一致：先读取 /平台名/sevenzipjbinding-lib.properties，
     * 再按其中的 lib.1.name 读取文件。
     */
    private static byte[] nativeLibraryHeader(String platform) throws IOException {
        assertNotNull(platform, "no platform name");
        String directory = "/" + platform + "/";
        Properties properties = new Properties();
        try (InputStream inputStream = SevenZip.class.getResourceAsStream(directory + "sevenzipjbinding-lib.properties")) {
            assertNotNull(inputStream, () -> directory + "sevenzipjbinding-lib.properties is not on the classpath");
            properties.load(inputStream);
        }
        String libraryName = properties.getProperty("lib.1.name");
        assertNotNull(libraryName, () -> directory + "sevenzipjbinding-lib.properties has no lib.1.name");
        try (InputStream inputStream = SevenZip.class.getResourceAsStream(directory + libraryName)) {
            assertNotNull(inputStream, () -> directory + libraryName + " is not on the classpath");
            byte[] header = inputStream.readNBytes(20);
            assertEquals(20, header.length, () -> directory + libraryName + " is shorter than an ELF header");
            return header;
        }
    }
}
