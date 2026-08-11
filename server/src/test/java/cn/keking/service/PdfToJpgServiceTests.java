package cn.keking.service;

import org.junit.jupiter.api.Test;

import javax.imageio.ImageIO;
import javax.imageio.spi.IIORegistry;
import javax.imageio.spi.ImageReaderSpi;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PdfToJpgServiceTests {

    @Test
    void shouldRediscoverJbig2ReaderAfterInitialRegistryMiss() {
        IIORegistry registry = IIORegistry.getDefaultInstance();
        List<ImageReaderSpi> providers = findJbig2Providers(registry);
        assertFalse(providers.isEmpty(), "jbig2-imageio must be present on the test class path");

        try {
            providers.forEach(registry::deregisterServiceProvider);
            assertFalse(hasJbig2Reader());

            PdfToJpgService.refreshImageIoPlugins();

            assertTrue(hasJbig2Reader());
        } finally {
            providers.forEach(registry::registerServiceProvider);
        }
    }

    private static List<ImageReaderSpi> findJbig2Providers(IIORegistry registry) {
        Iterator<ImageReaderSpi> providers = registry.getServiceProviders(
                ImageReaderSpi.class,
                provider -> Arrays.stream(((ImageReaderSpi) provider).getFormatNames())
                        .anyMatch("JBIG2"::equalsIgnoreCase),
                true
        );
        List<ImageReaderSpi> result = new ArrayList<>();
        providers.forEachRemaining(result::add);
        return result;
    }

    private static boolean hasJbig2Reader() {
        return ImageIO.getImageReadersByFormatName("JBIG2").hasNext();
    }
}
