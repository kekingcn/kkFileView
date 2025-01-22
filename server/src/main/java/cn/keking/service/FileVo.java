package cn.keking.service;

public class FileVo {
    /**
     * 文件名
     */
    private  String  fileName;
    /**
     * 文件路径
     */
    private  String  filePath;

    /**
     * UUID
     */
    private String contentId;

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }


    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getContentId() {
        return contentId;
    }

    public void setContentId(String contentId) {
        this.contentId = contentId;
    }

    public FileVo() {
    }

    public FileVo(String fileName, String filePath,String contentId) {
        this.fileName = fileName;
        this.filePath = filePath;
        this.contentId = contentId;
    }
}
