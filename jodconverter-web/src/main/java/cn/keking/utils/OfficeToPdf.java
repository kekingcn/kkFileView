package cn.keking.utils;

import org.artofsolving.jodconverter.OfficeDocumentConverter;
import org.springframework.stereotype.Component;

import java.io.File;

/**
 * @author yudian-it
 */
@Component
public class OfficeToPdf {
    private final ConverterUtils converterUtils;

    public OfficeToPdf(ConverterUtils converterUtils) {
        this.converterUtils = converterUtils;
    }

    public void openOfficeToPDF(String inputFilePath, String outputFilePath) {
        office2pdf(inputFilePath, outputFilePath);
    }


    public static void converterFile(File inputFile, String outputFilePath_end,
                                     OfficeDocumentConverter converter) {
        File outputFile = new File(outputFilePath_end);
        // 假如目标路径不存在,则新建该路径
        if (!outputFile.getParentFile().exists()) {
            outputFile.getParentFile().mkdirs();
        }
        converter.convert(inputFile, outputFile);
    }


    public void office2pdf(String inputFilePath, String outputFilePath) {
        OfficeDocumentConverter converter = converterUtils.getDocumentConverter();
        if (null != inputFilePath) {
            File inputFile = new File(inputFilePath);
            // 判断目标文件路径是否为空
            if (null == outputFilePath) {
                // 转换后的文件路径
                String outputFilePath_end = getOutputFilePath(inputFilePath);
                if (inputFile.exists()) {
                    // 找不到源文件, 则返回
                    converterFile(inputFile, outputFilePath_end,converter);
                }
            } else {
                if (inputFile.exists()) {
                    // 找不到源文件, 则返回
                    converterFile(inputFile, outputFilePath, converter);
                }
            }
        }
    }

    public static String getOutputFilePath(String inputFilePath) {
        return inputFilePath.replaceAll("."+ getPostfix(inputFilePath), ".pdf");
    }

    public static String getPostfix(String inputFilePath) {
        return inputFilePath.substring(inputFilePath.lastIndexOf(".") + 1);
    }

}
