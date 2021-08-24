package cn.keking.model;

/**
 * 下载的结果
 */
public class DownloadResult {

    /**
     * 下载存放到的文件路径
     */
    private final String savePath;

    public DownloadResult(String savePath) {
        this.savePath = savePath;
    }

    public String getSavePath() {
        return savePath;
    }
}
