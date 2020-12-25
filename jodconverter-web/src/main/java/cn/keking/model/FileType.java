package cn.keking.model;

/**
 * Created by kl on 2018/1/17.
 * Content :文件类型，文本，office，压缩包等等
 */
public enum FileType {
    picture("picturefilepreviewimpl"),
    compress("compressFilePreviewImpl"),
    office("officeFilePreviewImpl"),
    simText("simTextFilePreviewImpl"),
    pdf("pdfFilePreviewImpl"),
    other("otherFilePreviewImpl"),
    media("mediaFilePreviewImpl"),
    markdown("markdownFilePreviewImpl"),
    cad("cadFilePreviewImpl");


    private final String instanceName;

    FileType(String instanceName){
        this.instanceName=instanceName;
    }

    public String getInstanceName() {
        return instanceName;
    }

}
