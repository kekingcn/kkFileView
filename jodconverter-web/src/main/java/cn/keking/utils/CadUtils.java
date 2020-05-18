package cn.keking.utils;

import com.aspose.cad.Color;
import com.aspose.cad.fileformats.cad.CadDrawTypeMode;
import com.aspose.cad.imageoptions.CadRasterizationOptions;
import com.aspose.cad.imageoptions.PdfOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;

/**
 * @author chenjhc
 * @since 2019/11/21 14:34
 */
@Component
public class CadUtils {

    private final Logger logger = LoggerFactory.getLogger(CadUtils.class);

    public boolean cadToPdf(String inputFilePath, String outputFilePath)  {
        com.aspose.cad.Image cadImage = com.aspose.cad.Image.load(inputFilePath);
        CadRasterizationOptions cadRasterizationOptions = new CadRasterizationOptions();
        cadRasterizationOptions.setLayouts(new String[]{"Model"});
        cadRasterizationOptions.setNoScaling(true);
        cadRasterizationOptions.setBackgroundColor(Color.getWhite());
        cadRasterizationOptions.setPageWidth(cadImage.getWidth());
        cadRasterizationOptions.setPageHeight(cadImage.getHeight());
        cadRasterizationOptions.setPdfProductLocation("center");
        cadRasterizationOptions.setAutomaticLayoutsScaling(true);
        cadRasterizationOptions.setDrawType(CadDrawTypeMode.UseObjectColor);
        PdfOptions pdfOptions = new PdfOptions();
        pdfOptions.setVectorRasterizationOptions(cadRasterizationOptions);
        File outputFile = new File(outputFilePath);
        OutputStream stream;
        try {
            stream = new FileOutputStream(outputFile);
            cadImage.save(stream, pdfOptions);
            cadImage.close();
            return true;
        } catch (FileNotFoundException e) {
            logger.error("PDFFileNotFoundException，inputFilePath：{}", inputFilePath, e);
            return false;
        }
    }
}
