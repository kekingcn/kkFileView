package cn.keking.extend;

import com.google.common.collect.Maps;
import com.sun.star.beans.PropertyValue;
import org.artofsolving.jodconverter.document.DocumentFamily;
import org.artofsolving.jodconverter.document.DocumentFormat;
import org.artofsolving.jodconverter.document.SimpleDocumentFormatRegistry;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 重写了DefaultDocumentFormatRegistry类，因为要添加自定义行为，比如字符编码。。。
 * @author yudian-it
 * @date 2017/12/5
 */
public class ControlDocumentFormatRegistry extends SimpleDocumentFormatRegistry {

    public ControlDocumentFormatRegistry() {
        DocumentFormat pdf = new DocumentFormat("Portable Document Format", "pdf", "application/pdf");
        pdf.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "writer_pdf_Export"));
        pdf.setStoreProperties(DocumentFamily.SPREADSHEET, Collections.singletonMap("FilterName", "calc_pdf_Export"));
        pdf.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "impress_pdf_Export"));
        pdf.setStoreProperties(DocumentFamily.DRAWING, Collections.singletonMap("FilterName", "draw_pdf_Export"));
        addFormat(pdf);

        DocumentFormat swf = new DocumentFormat("Macromedia Flash", "swf", "application/x-shockwave-flash");
        swf.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "impress_flash_Export"));
        swf.setStoreProperties(DocumentFamily.DRAWING, Collections.singletonMap("FilterName", "draw_flash_Export"));
        addFormat(swf);

        // disabled because it's not always available
        //DocumentFormat xhtml = new DocumentFormat("XHTML", "xhtml", "application/xhtml+xml");
        //xhtml.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "XHTML Writer File"));
        //xhtml.setStoreProperties(DocumentFamily.SPREADSHEET, Collections.singletonMap("FilterName", "XHTML Calc File"));
        //xhtml.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "XHTML Impress File"));
        //addFormat(xhtml);

        DocumentFormat html = new DocumentFormat("HTML", "html", "text/html");
        // HTML is treated as Text when supplied as input, but as an output it is also
        // available for exporting Spreadsheet and Presentation formats
        html.setInputFamily(DocumentFamily.TEXT);
        html.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "HTML (StarWriter)"));
        Map<String,Object> htmlLoadAndStoreProperties = new LinkedHashMap<String,Object>();
        htmlLoadAndStoreProperties.put("FilterName", "HTML (StarCalc)");
        htmlLoadAndStoreProperties.put("FilterOptions", "utf8");
        html.setStoreProperties(DocumentFamily.SPREADSHEET, htmlLoadAndStoreProperties);
        html.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "impress_html_Export"));
        addFormat(html);

        DocumentFormat odt = new DocumentFormat("OpenDocument Text", "odt", "application/vnd.oasis.opendocument.text");
        odt.setInputFamily(DocumentFamily.TEXT);
        odt.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "writer8"));
        addFormat(odt);

        DocumentFormat sxw = new DocumentFormat("OpenOffice.org 1.0 Text Document", "sxw", "application/vnd.sun.xml.writer");
        sxw.setInputFamily(DocumentFamily.TEXT);
        sxw.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "StarOffice XML (Writer)"));
        addFormat(sxw);

        DocumentFormat doc = new DocumentFormat("Microsoft Word", "doc", "application/msword");
        doc.setInputFamily(DocumentFamily.TEXT);
        doc.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "MS Word 97"));
        addFormat(doc);

        DocumentFormat docx = new DocumentFormat("Microsoft Word 2007 XML", "docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        docx.setInputFamily(DocumentFamily.TEXT);
        addFormat(docx);

        DocumentFormat rtf = new DocumentFormat("Rich Text Format", "rtf", "text/rtf");
        rtf.setInputFamily(DocumentFamily.TEXT);
        rtf.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "Rich Text Format"));
        addFormat(rtf);

        DocumentFormat wpd = new DocumentFormat("WordPerfect", "wpd", "application/wordperfect");
        wpd.setInputFamily(DocumentFamily.TEXT);
        addFormat(wpd);

        DocumentFormat txt = new DocumentFormat("Plain Text", "txt", "text/plain");
        txt.setInputFamily(DocumentFamily.TEXT);
        Map<String,Object> txtLoadAndStoreProperties = new LinkedHashMap<String,Object>();
        txtLoadAndStoreProperties.put("FilterName", "Text (encoded)");
        txtLoadAndStoreProperties.put("FilterOptions", "utf8");
        txt.setLoadProperties(txtLoadAndStoreProperties);
        txt.setStoreProperties(DocumentFamily.TEXT, txtLoadAndStoreProperties);
        addFormat(txt);

        DocumentFormat wikitext = new DocumentFormat("MediaWiki wikitext", "wiki", "text/x-wiki");
        wikitext.setStoreProperties(DocumentFamily.TEXT, Collections.singletonMap("FilterName", "MediaWiki"));
        //addFormat(wikitext);

        DocumentFormat ods = new DocumentFormat("OpenDocument Spreadsheet", "ods", "application/vnd.oasis.opendocument.spreadsheet");
        ods.setInputFamily(DocumentFamily.SPREADSHEET);
        ods.setStoreProperties(DocumentFamily.SPREADSHEET, Collections.singletonMap("FilterName", "calc8"));
        addFormat(ods);

        DocumentFormat sxc = new DocumentFormat("OpenOffice.org 1.0 Spreadsheet", "sxc", "application/vnd.sun.xml.calc");
        sxc.setInputFamily(DocumentFamily.SPREADSHEET);
        sxc.setStoreProperties(DocumentFamily.SPREADSHEET, Collections.singletonMap("FilterName", "StarOffice XML (Calc)"));
        addFormat(sxc);

        DocumentFormat xls = new DocumentFormat("Microsoft Excel", "xls", "application/vnd.ms-excel");
        xls.setInputFamily(DocumentFamily.SPREADSHEET);
        xls.setStoreProperties(DocumentFamily.SPREADSHEET, Collections.singletonMap("FilterName", "MS Excel 97"));
        addFormat(xls);

        DocumentFormat xlsx = new DocumentFormat("Microsoft Excel 2007 XML", "xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        xlsx.setInputFamily(DocumentFamily.SPREADSHEET);
        addFormat(xlsx);

        DocumentFormat csv = new DocumentFormat("Comma Separated Values", "csv", "text/csv");
        csv.setInputFamily(DocumentFamily.SPREADSHEET);
        Map<String,Object> csvLoadAndStoreProperties = new LinkedHashMap<String,Object>();
        csvLoadAndStoreProperties.put("FilterName", "Text - txt - csv (StarCalc)");
        csvLoadAndStoreProperties.put("FilterOptions", "44,34,0");  // Field Separator: ','; Text Delimiter: '"'
        csv.setLoadProperties(csvLoadAndStoreProperties);
        csv.setStoreProperties(DocumentFamily.SPREADSHEET, csvLoadAndStoreProperties);
        addFormat(csv);

        DocumentFormat tsv = new DocumentFormat("Tab Separated Values", "tsv", "text/tab-separated-values");
        tsv.setInputFamily(DocumentFamily.SPREADSHEET);
        Map<String,Object> tsvLoadAndStoreProperties = new LinkedHashMap<String,Object>();
        tsvLoadAndStoreProperties.put("FilterName", "Text - txt - csv (StarCalc)");
        tsvLoadAndStoreProperties.put("FilterOptions", "9,34,0");  // Field Separator: '\t'; Text Delimiter: '"'
        tsv.setLoadProperties(tsvLoadAndStoreProperties);
        tsv.setStoreProperties(DocumentFamily.SPREADSHEET, tsvLoadAndStoreProperties);
        addFormat(tsv);

        DocumentFormat odp = new DocumentFormat("OpenDocument Presentation", "odp", "application/vnd.oasis.opendocument.presentation");
        odp.setInputFamily(DocumentFamily.PRESENTATION);
        odp.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "impress8"));
        addFormat(odp);

        DocumentFormat sxi = new DocumentFormat("OpenOffice.org 1.0 Presentation", "sxi", "application/vnd.sun.xml.impress");
        sxi.setInputFamily(DocumentFamily.PRESENTATION);
        sxi.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "StarOffice XML (Impress)"));
        addFormat(sxi);

        DocumentFormat ppt = new DocumentFormat("Microsoft PowerPoint", "ppt", "application/vnd.ms-powerpoint");
        ppt.setInputFamily(DocumentFamily.PRESENTATION);
        ppt.setStoreProperties(DocumentFamily.PRESENTATION, Collections.singletonMap("FilterName", "MS PowerPoint 97"));
        addFormat(ppt);

        DocumentFormat pptx = new DocumentFormat("Microsoft PowerPoint 2007 XML", "pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation");
        pptx.setInputFamily(DocumentFamily.PRESENTATION);
        addFormat(pptx);

        DocumentFormat odg = new DocumentFormat("OpenDocument Drawing", "odg", "application/vnd.oasis.opendocument.graphics");
        odg.setInputFamily(DocumentFamily.DRAWING);
        odg.setStoreProperties(DocumentFamily.DRAWING, Collections.singletonMap("FilterName", "draw8"));
        addFormat(odg);

        DocumentFormat svg = new DocumentFormat("Scalable Vector Graphics", "svg", "image/svg+xml");
        svg.setStoreProperties(DocumentFamily.DRAWING, Collections.singletonMap("FilterName", "draw_svg_Export"));
        addFormat(svg);
    }

    /**
     * 创建默认的导出属性
     * @return
     */
    private PropertyValue[] getCommonPropertyValue() {
        PropertyValue[] aFilterData = new PropertyValue[11];
        // 不显示文档标题
        aFilterData[0] = new PropertyValue();
        aFilterData[0].Name = "DisplayPDFDocumentTitle";
        aFilterData[0].Value= true;
        // 导出文件编码方式
        aFilterData[1] = new PropertyValue();
        aFilterData[1].Name = "Encoding";
        aFilterData[1].Value= "UTF-8";
        // 隐藏工具条
        aFilterData[2] = new PropertyValue();
        aFilterData[2].Name = "HideViewerToolbar";
        aFilterData[2].Value= false;
        // 隐藏窗口控制条
        aFilterData[3] = new PropertyValue();
        aFilterData[3].Name = "HideViewerWindowControls";
        aFilterData[3].Value= true;
        // 全屏展示
        aFilterData[4] = new PropertyValue();
        aFilterData[4].Name = "OpenInFullScreenMode";
        aFilterData[4].Value= false;
        // 第一页左边展示
        aFilterData[5] = new PropertyValue();
        aFilterData[5].Name = "MathToMathType";
        aFilterData[5].Value= true;
        // 文档标题内容
        aFilterData[6] = new PropertyValue();
        aFilterData[6].Name = "Watermark";
        aFilterData[6].Value= "KEKING.CN";
        // 导出文件编码方式
        aFilterData[7] = new PropertyValue();
        aFilterData[7].Name = "CharacterSet";
        aFilterData[7].Value= "UTF-8";
        // 导出文件编码方式
        aFilterData[8] = new PropertyValue();
        aFilterData[8].Name = "Encoding";
        aFilterData[8].Value= "UTF-8";
        // 导出文件编码方式
        aFilterData[9] = new PropertyValue();
        aFilterData[9].Name = "CharSet";
        aFilterData[9].Value= "UTF-8";
        // 导出文件编码方式
        aFilterData[10] = new PropertyValue();
        aFilterData[10].Name = "charset";
        aFilterData[10].Value= "UTF-8";
        return aFilterData;
    }
}
