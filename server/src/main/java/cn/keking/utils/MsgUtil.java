package cn.keking.utils;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.keking.service.FileVo;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.simplejavamail.outlookmessageparser.OutlookMessageParser;
import org.simplejavamail.outlookmessageparser.model.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class MsgUtil {

    /**
     * 邮件转换为HTML
     * @param file .msg文件
     * @return {@link FileVo}
     * @throws IOException IO异常
     */
    public static FileVo msgParseToPreview(File file) throws IOException {
        OutlookMessageParser messageParser = new OutlookMessageParser();
        OutlookMessage msg = messageParser.parseMsg(file.getAbsolutePath());
        List<FileVo> attachList = new ArrayList<>();
        List<OutlookAttachment> outlookAttachments = msg.getOutlookAttachments();
        for (OutlookAttachment outlookattachment : outlookAttachments) {
            if (outlookattachment instanceof OutlookMsgAttachment) {
                attachList.add(msgAttachmentToFile((OutlookMsgAttachment) outlookattachment));
            }else if(outlookattachment instanceof OutlookFileAttachment){
                attachList.add(fileAttachToFile((OutlookFileAttachment) outlookattachment));
            }
        }
        String html = messageToHtml(msg,attachList);
        File tmpFile = createTmpFileWithName(file.getName().substring(0,file.getName().lastIndexOf("."))+".html");
        Path path = Files.write(tmpFile.toPath(), html.getBytes(), StandardOpenOption.TRUNCATE_EXISTING);
        return new FileVo(file.getName(),path.toFile().getAbsolutePath(), cn.hutool.core.lang.UUID.randomUUID().toString());
    }

    /**
     * 邮件内容转换为html
     * @param msg         味精
     * @param attachments
     * @return {@link String}
     * @throws IOException IO异常
     */
    private static String messageToHtml(OutlookMessage msg,List<FileVo> attachments) throws IOException {
        String bodyText = msg.getBodyText();
        //主题
        String subject = msg.getSubject();
        //主题即为文件名
        String form = msg.getFromEmail();
        String to = msg.getDisplayTo();
        String cc = msg.getDisplayCc();
        String content = StrUtil.EMPTY;
        if(StrUtil.isNotEmpty(bodyText)){
            Document doc = Jsoup.parse(msg.getConvertedBodyHTML());
            //邮件中的图片转base64
            Elements imgList = doc.select("img");
            for (Element element : imgList) {
                String src = element.attr("src");
                if (!src.contains("cid:")) {
                    continue;
                }
                String contentId = src.substring(4);
                FileVo fileVo = null;
                for (FileVo tmp : attachments) {
                    if (contentId.equals(tmp.getContentId())) {
                        fileVo = tmp;
                        break;
                    }
                }
                if (fileVo == null) {
                    continue;
                }
                File attach = new File(fileVo.getFilePath());
                String base64 = null;
                try(InputStream in = Files.newInputStream(attach.toPath())){
                    byte[] bytes = new byte[(int) attach.length()];
                    in.read(bytes);
                    base64 = Base64.getEncoder().encodeToString(bytes);
                }catch (Exception e){
                    e.printStackTrace();
                }
                if (StringUtils.isNotBlank(base64)) {
                    String srcBase64 = "data:image/png;base64," + base64;
                    element.attr("src", fileVo.getFilePath());
                    if (CollUtil.isNotEmpty(attachments) && attachments.contains(fileVo)) {
                        attachments.remove(fileVo);
                    }
                }
            }
            // 内容
            Elements bodyList = doc.select("body");
            if (!bodyList.isEmpty()) {
                Element bodyEle = bodyList.first();
                if (!bodyEle.html().isEmpty()) {
                    content = bodyEle.html();
                }
            }
        }
        String html =
                "发件人:" + form + "</br>" +
                        "抄送:" + cc + "</br>" +
                        "收件人:" + to + "</br>" +
                        "主题:" + subject + "</br>"+
                        "附件:" + attachments.stream()
                        .map(file -> "<a href=\">"+file.getFilePath()+"\">"+file.getFileName()+"</>")
                        .collect(Collectors.joining(",")) + "</br>"+
                        content;
        return html;
    }

    /**
     * .msg文件转换为文件
     *
     * @param attachment 附件
     * @return {@link FileVo}
     * @throws IOException IO异常
     */
    private static FileVo msgAttachmentToFile(OutlookMsgAttachment attachment) throws IOException {
        //附件
        List<OutlookAttachment> outlookAttachments = attachment.getOutlookMessage().getOutlookAttachments();
        List<FileVo> attachList = new ArrayList<>();
        for (OutlookAttachment outlookAttachment : outlookAttachments) {
            if(outlookAttachment instanceof OutlookMsgAttachment){
                attachList.add(msgAttachmentToFile((OutlookMsgAttachment) outlookAttachment));
            }else if(outlookAttachment instanceof OutlookFileAttachment){
                attachList.add(fileAttachToFile((OutlookFileAttachment) outlookAttachment));
            }
        }
        //主题
        String subject = attachment.getOutlookMessage().getSubject();
        //邮件内容
        String html = messageToHtml(attachment.getOutlookMessage(), attachList);
        File file = createTmpFileWithName(subject+".html");
        Path path = Files.write(file.toPath(), html.getBytes(), StandardOpenOption.TRUNCATE_EXISTING);
       return new FileVo(subject,path.toFile().getAbsolutePath(),attachment.getOutlookMessage().getMessageId());
    }

    /**
     * 附件下载到本地
     *
     * @param attachment 附件
     * @return {@link FileVo}
     * @throws IOException IO异常
     */
    private static FileVo fileAttachToFile(OutlookFileAttachment attachment) throws IOException {
        String attachName = attachment.getLongFilename();
        //存在没有命名的文件
        if (StringUtils.isBlank(attachName)){
            attachName= UUID.randomUUID().toString().replace("-", "");
        }
        //创建临时文件
        File attachementFile = createTmpFileWithName(attachName);
        InputStream is = new ByteArrayInputStream(attachment.getData());
        Files.copy(is, attachementFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
        if (ObjectUtil.isNotNull(attachementFile)) {
            return new FileVo(attachName,attachementFile.getAbsolutePath(),attachment.getContentId());
        }
        return null;
    }

    private static File getTmpDir() {
        String projectPath = System.getProperty("user.dir") + File.separator + "temp";
        File file = new File(projectPath);
        if (!file.exists()) {
            file.mkdirs();
        }
        return file;
    }

    private static File createTmpFileWithName(String fileName) throws IOException {
        File file = new File(getTmpDir(), fileName);
        if (!file.exists()) {
            file.createNewFile();
        }
        return file;
    }
}
