package com.yudianbank.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.hssf.converter.ExcelToHtmlConverter;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hwpf.converter.PicturesManager;
import org.apache.poi.hwpf.converter.WordToHtmlConverter;
import org.apache.poi.hwpf.usermodel.Picture;
import org.apache.poi.hwpf.usermodel.PictureType;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.Document;


public  class PoiExcelToHtml {
//    String  path = getClass().getClassLoader().getResource(".").getPath()+File.separator+"static"+File.separator;
    public static  void excelConvert(URL url) {
        try {
            String path = "";

//            http://keking.ufile.ucloud.com.cn/20171101152525_左晓晖2017年9.xls?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=1n8ASiYMcfiF30YHxwpzwfqmlM0=
//            URL url = new URL("http://keking.ufile.ucloud.com.cn/20171101150322_运费贷信审资料（给予客户收集版）.xlsx?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=RRVFIICITMNFed1LQgB10WdKHiE=");
            HttpURLConnection conn = (HttpURLConnection)url.openConnection();
            //设置超时间为3秒
            conn.setConnectTimeout(3*1000);
            //防止屏蔽程序抓取而返回403错误
            conn.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
            //得到输入流
            InputStream inputStream = conn.getInputStream();
            HSSFWorkbook excelBook = new HSSFWorkbook(inputStream);
            ExcelToHtmlConverter excelToHtmlConverter = new ExcelToHtmlConverter(DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument());
            excelToHtmlConverter.processWorkbook(excelBook);
            List pics = excelBook.getAllPictures();
            if (pics != null) {
                for (int i = 0; i < pics.size(); i++) {
                    Picture pic = (Picture) pics.get(i);
                    try {
                        pic.writeImageContent(new FileOutputStream(path + pic.suggestFullFileName()));
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    }
                }
            }
            Document htmlDocument = excelToHtmlConverter.getDocument();
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();
            DOMSource domSource = new DOMSource(htmlDocument);
            StreamResult streamResult = new StreamResult(outStream);
            TransformerFactory tf = TransformerFactory.newInstance();
            Transformer serializer = tf.newTransformer();
            serializer.setOutputProperty(OutputKeys.ENCODING, "utf-8");
            serializer.setOutputProperty(OutputKeys.INDENT, "yes");
            serializer.setOutputProperty(OutputKeys.METHOD, "html");
            serializer.transform(domSource, streamResult);
            outStream.close();

            String content = new String(outStream.toByteArray());

        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (TransformerException e) {
            e.printStackTrace();
        }
    }

    /**
     * excel07转html
     * filename:要读取的文件所在文件夹
     * filepath:文件名
     * htmlname:生成html名称
     * path:html存放路径
     * */
    public static void excelToHtml () throws Exception{
        String htmlname="exportExcel"+"07Test"+".html";


        URL url = new URL("http://keking.ufile.ucloud.com.cn/20171101150322_运费贷信审资料（给予客户收集版）.xlsx?UCloudPublicKey=ucloudtangshd@weifenf.com14355492830001993909323&Expires=&Signature=RRVFIICITMNFed1LQgB10WdKHiE=");
        HttpURLConnection conn = (HttpURLConnection)url.openConnection();
        //设置超时间为3秒
        conn.setConnectTimeout(3*1000);
        //防止屏蔽程序抓取而返回403错误
        conn.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 5.0; Windows NT; DigExt)");
        //得到输入流
        InputStream is = conn.getInputStream();

        Workbook workbook = null;
//        InputStream is = new FileInputStream(filename+"/"+filepath);
        try {
            String html="";
            workbook =  new XSSFWorkbook(is);
            for (int numSheet = 0; numSheet < workbook.getNumberOfSheets(); numSheet++) {
                Sheet sheet = workbook.getSheetAt(numSheet);
                if (sheet == null) {
                    continue;
                }
                html+="=======================" + sheet.getSheetName() + "=========================<br><br>";

                int firstRowIndex = sheet.getFirstRowNum();
                int lastRowIndex = sheet.getLastRowNum();
                html+="<table border='1' align='left'>";
                Row firstRow = sheet.getRow(firstRowIndex);
                for (int i = firstRow.getFirstCellNum(); i <= firstRow.getLastCellNum(); i++) {
                    Cell cell = firstRow.getCell(i);
                    String cellValue = getCellValue(cell, true);
                    html+="<th>" + cellValue + "</th>";
                }


                //行
                for (int rowIndex = firstRowIndex + 1; rowIndex <= lastRowIndex; rowIndex++) {
                    Row currentRow = sheet.getRow(rowIndex);
                    html+="<tr>";
                    if(currentRow!=null){

                        int firstColumnIndex = currentRow.getFirstCellNum();
                        int lastColumnIndex = currentRow.getLastCellNum();
                        //列
                        for (int columnIndex = firstColumnIndex; columnIndex <= lastColumnIndex; columnIndex++) {
                            Cell currentCell = currentRow.getCell(columnIndex);
                            String currentCellValue = getCellValue(currentCell, true);
                            html+="<td>"+currentCellValue + "</td>";
                        }
                    }else{
                        html+=" ";
                    }
                    html+="</tr>";
                }
                html+="</table>";


                ByteArrayOutputStream outStream = new ByteArrayOutputStream();
                DOMSource domSource = new DOMSource ();
                StreamResult streamResult = new StreamResult (outStream);

                TransformerFactory tf = TransformerFactory.newInstance();
                Transformer serializer = tf.newTransformer();
                serializer.setOutputProperty (OutputKeys.ENCODING, "utf-8");
                serializer.setOutputProperty (OutputKeys.INDENT, "yes");
                serializer.setOutputProperty (OutputKeys.METHOD, "html");
                serializer.transform (domSource, streamResult);
                outStream.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 读取单元格
     *
     */
    private static String getCellValue(Cell cell, boolean treatAsStr) {
        if (cell == null) {
            return "";
        }

        if (treatAsStr) {
            cell.setCellType(Cell.CELL_TYPE_STRING);
        }

        if (cell.getCellType() == Cell.CELL_TYPE_BOOLEAN) {
            return String.valueOf(cell.getBooleanCellValue());
        } else if (cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
            return String.valueOf(cell.getNumericCellValue());
        } else {
            return String.valueOf(cell.getStringCellValue());
        }
    }
}
