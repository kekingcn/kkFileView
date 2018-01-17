package cn.keking.model;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
public class FileAttribute {

    private FileType type;

    private String suffix;

    private String name;

    private String url;

    private String decodedUrl;

    public FileAttribute() {
    }

    public FileAttribute(FileType type, String suffix, String name, String url, String decodedUrl) {
        this.type = type;
        this.suffix = suffix;
        this.name = name;
        this.url = url;
        this.decodedUrl = decodedUrl;
    }

    public FileType getType() {
        return type;
    }

    public void setType(FileType type) {
        this.type = type;
    }

    public String getSuffix() {
        return suffix;
    }

    public void setSuffix(String suffix) {
        this.suffix = suffix;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDecodedUrl() {
        return decodedUrl;
    }

    public void setDecodedUrl(String decodedUrl) {
        this.decodedUrl = decodedUrl;
    }
}
