package cn.keking.config.configconstants;

import org.springframework.beans.factory.annotation.Value;

public class PDFConfigConstants
{
    private static String pdfPresentationModeDisable;
    private static String pdfOpenFileDisable;
    private static String pdfPrintDisable;
    private static String pdfDownloadDisable;
    private static String pdfBookmarkDisable;

    public static final String DEFAULT_PDF_PRESENTATION_MODE_DISABLE = "true";
    public static final String DEFAULT_PDF_OPEN_FILE_DISABLE = "true";
    public static final String DEFAULT_PDF_PRINT_DISABLE = "true";
    public static final String DEFAULT_PDF_DOWNLOAD_DISABLE = "true";
    public static final String DEFAULT_PDF_BOOKMARK_DISABLE = "true";

    public static String getPdfPresentationModeDisable() {
        return pdfPresentationModeDisable;
    }

    @Value("${pdf.presentationMode.disable:true}")
    public void setPdfPresentationModeDisable(String pdfPresentationModeDisable) {
        PDFConfigConstants.setPdfPresentationModeDisableValue(pdfPresentationModeDisable);
    }

    public static void setPdfPresentationModeDisableValue(String pdfPresentationModeDisable) {
        PDFConfigConstants.pdfPresentationModeDisable = pdfPresentationModeDisable;
    }

    public static String getPdfOpenFileDisable() {
        return pdfOpenFileDisable;
    }

    @Value("${pdf.openFile.disable:true}")
    public static void setPdfOpenFileDisable(String pdfOpenFileDisable) {
        setPdfOpenFileDisableValue(pdfOpenFileDisable);
    }
    public static void setPdfOpenFileDisableValue(String pdfOpenFileDisable) {
        PDFConfigConstants.pdfOpenFileDisable = pdfOpenFileDisable;
    }

    public static String getPdfPrintDisable() {
        return pdfPrintDisable;
    }
    @Value("${pdf.print.disable:true}")
    public  void setPdfPrintDisable(String pdfPrintDisable) {
        setPdfPrintDisableValue(pdfPrintDisable);
    }
    public static void setPdfPrintDisableValue(String pdfPrintDisable) {
        PDFConfigConstants.pdfPrintDisable = pdfPrintDisable;
    }

    public static String getPdfDownloadDisable() {
        return pdfDownloadDisable;
    }

    @Value("${pdf.download.disable:true}")
    public void setPdfDownloadDisable(String pdfDownloadDisable) {
        setPdfDownloadDisableValue(pdfDownloadDisable);
    }
    public static void setPdfDownloadDisableValue(String pdfDownloadDisable) {
        PDFConfigConstants.pdfDownloadDisable = pdfDownloadDisable;
    }

    public static String getPdfBookmarkDisable() {
        return pdfBookmarkDisable;
    }

    @Value("${pdf.bookmark.disable:true}")
    public void setPdfBookmarkDisable(String pdfBookmarkDisable) {
        setPdfBookmarkDisableValue(pdfBookmarkDisable);
    }
    public static void setPdfBookmarkDisableValue(String pdfBookmarkDisable) {
        PDFConfigConstants.pdfBookmarkDisable = pdfBookmarkDisable;
    }
}
