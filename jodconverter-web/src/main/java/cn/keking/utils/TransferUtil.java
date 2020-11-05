package cn.keking.utils;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 * pdf 转换工具
 *
 * @author lr
 */
public class TransferUtil {

    public final static String PDF_SUFFIX = "pdf";

    public final static String PDF_TRANSFER = "pdfTransferImg";


    public static String getOSPath() {

        //获取转换的路径
/*        String path =
                GlobalProperties.getGlobalProperty("attachmentPath") + "/" + PDF_TRANSFER + "/";*/
         String path = "attachmentPath";

        //转换一下地址
        path = YjUtil.encodePath(path);

        File file = new File(path);
        if (!file.exists()) {
            // 不存在则创建
            file.mkdirs();
        }

        return path;
    }


    /**
     * pdf转图片 返回本地存储路径图片集合
     *
     * @param file 文件
     * @return
     * @throws Exception
     */
    public static List<String> transferPdfToImage(MultipartFile file) throws Exception {

        //0.判断是否是pdf文件
        String suffixName = getFileSuffix(file.getOriginalFilename());
        if (!suffixName.equals(PDF_SUFFIX)) {
            throw new Exception("附件不是pdf文件格式");
        }
        //1.保存file到文件中
        //文件名称，这里使用时间戳来重新生成文件名称
        String fileName = System.currentTimeMillis() + "." + suffixName;

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        //获取日期
        String time = formatter.format(LocalDateTime.now());

        //保存文件路径-根据时间创建一个文件夹
        String fileSavePath = getOSPath() + time + "/";
        fileSavePath = YjUtil.encodePath(fileSavePath);

        //文件保存的完整路径
        String fileLocalSavePath = fileSavePath + fileName;

        //写入文件
        FileUtils.writeByteArrayToFile(new File(fileLocalSavePath), file.getBytes());
        System.out.println("文件保存路为->" + fileLocalSavePath);

        //保存的图片路径
        String localImgPath = fileLocalSavePath.substring(0, fileLocalSavePath.lastIndexOf("."));

        PdfTransferUtil transferUtil = new PdfTransferUtil();
        //保存图片
        List<byte[]> ins = transferUtil.pdf2Image(fileLocalSavePath, "png", 1.5f);
        List<String> localFilePath = new ArrayList<>(ins.size());
        for (int i = 0; i < ins.size(); i++) {
            byte[] data = ins.get(i);

            //设置保存图片的路径并保存
            String pathReal = localImgPath + "_pdf_" + i + ".png";
            FileUtils.writeByteArrayToFile(new File(pathReal), data);
            //返回路径
            localFilePath.add(pathReal);
        }
        return localFilePath;
    }

    /**
     * <ul>
     * <li>生成时间： 2020/7/8 16:44</li>
     * <li>方法说明： 根据pdf路径和文件路径进行图片转换</li>
     * <li>开发人员：zhengyu</li>
     * </ul>
     * @param
     * @return
     */

    public static List<String> transferPdfToImage(String pdfPath,String pdfName, String baseUrl) throws Exception {

        //文件夹名称
        String pdfFolder = pdfName.substring(0, pdfName.length() - 4);

        //创建同级的文件夹名称
        int index = pdfPath.lastIndexOf(".");
        String folder = pdfPath.substring(0, index);
        File path = new File(folder);
        if (!path.exists()) {
            path.mkdirs();
        }

        PdfTransferUtil transferUtil = new PdfTransferUtil();
        //保存图片
        List<byte[]> ins = transferUtil.pdf2Image( YjUtil.encodePath(pdfPath), "jpg", 1.5f);
        List<String> localFilePath = new ArrayList<>(ins.size());
        for (int i = 0; i < ins.size(); i++) {
            byte[] data = ins.get(i);

            //设置保存图片的路径并保存
            String pathReal = YjUtil.encodePath(folder+"/") + i + ".jpg";
            FileUtils.writeByteArrayToFile(new File(pathReal), data);
            //返回路径
            //localFilePath.add(pathReal);
            localFilePath.add(baseUrl+"/"+pdfFolder+ "/"+ i +".jpg");
        }

        //todo 写入缓存
        //fileUtils.addConvertedPdfImage(pdfFilePath, pageCount);

        return localFilePath;
    }

    /**
     * 获取文件后缀名 不包含点
     */
    public static String getFileSuffix(String fileWholeName) throws Exception {
        if (StringUtils.isEmpty(fileWholeName)) {
            throw new Exception("文件名称为空!");
        }
        int lastIndexOf = fileWholeName.lastIndexOf(".");
        return fileWholeName.substring(lastIndexOf + 1);
    }

}