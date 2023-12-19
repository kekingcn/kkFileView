package cn.keking.model;

import cn.keking.config.ConfigConstants;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
public class FileAttribute {

    private FileType type;
    private String suffix;
    private String name;
    private String url;
    private boolean isCompressFile = false;
    private String compressFileKey;
    private String filePassword;
    private boolean usePasswordCache;
    private String officePreviewType = ConfigConstants.getOfficePreviewType();
    private String tifPreviewType;
    private Boolean skipDownLoad = false;
    private Boolean forceUpdatedCache = false;
    private String cacheName;
    private String outFilePath;
    private String originFilePath;
    private String cacheListName;
    private boolean isHtmlView = false;

    /**
     * 代理请求到文件服务器的认证请求头，格式如下：
     * {“username”:"test","password":"test"}
     * 请求文件服务器时，会将 json 直接塞到请求头里
     */
    private String kkProxyAuthorization;

    public FileAttribute() {
    }

    public FileAttribute(FileType type, String suffix, String name, String url) {
        this.type = type;
        this.suffix = suffix;
        this.name = name;
        this.url = url;
    }

    public FileAttribute(FileType type, String suffix, String name, String url, String officePreviewType) {
        this.type = type;
        this.suffix = suffix;
        this.name = name;
        this.url = url;
        this.officePreviewType = officePreviewType;
    }

    public boolean isCompressFile() {
        return isCompressFile;
    }

    public void setCompressFile(boolean compressFile) {
        isCompressFile = compressFile;
    }

    public String getFilePassword() {
        return filePassword;
    }

    public void setFilePassword(String filePassword) {
        this.filePassword = filePassword;
    }

    public boolean getUsePasswordCache() {
        return usePasswordCache;
    }

    public void setUsePasswordCache(boolean usePasswordCache) {
        this.usePasswordCache = usePasswordCache;
    }

    public String getOfficePreviewType() {
        return officePreviewType;
    }

    public void setOfficePreviewType(String officePreviewType) {
        this.officePreviewType = officePreviewType;
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

    public String getCompressFileKey() {
        return compressFileKey;
    }

    public void setCompressFileKey(String compressFileKey) {
        this.compressFileKey = compressFileKey;
    }

    public String getName() {
        return name;
    }
    public String getCacheName() {
        return cacheName;
    }
    public String getCacheListName() {
        return cacheListName;
    }
    public String getOutFilePath() {
        return outFilePath;
    }
    public String getOriginFilePath() {
        return originFilePath;
    }
    public boolean isHtmlView() {
        return isHtmlView;
    }

    public void setCacheName(String cacheName) {
        this.cacheName = cacheName;
    }
    public void setCacheListName(String cacheListName) {
        this.cacheListName = cacheListName;
    }
    public void setOutFilePath(String outFilePath) {
        this.outFilePath = outFilePath;
    }
    public void setOriginFilePath(String originFilePath) {
        this.originFilePath = originFilePath;
    }
    public void setHtmlView(boolean isHtmlView) {
        this.isHtmlView = isHtmlView;
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

    public Boolean getSkipDownLoad() {
        return skipDownLoad;
    }

    public void setSkipDownLoad(Boolean skipDownLoad) {
        this.skipDownLoad = skipDownLoad;
    }

    public String getTifPreviewType() {
        return tifPreviewType;
    }

    public void setTifPreviewType(String previewType) {
        this.tifPreviewType = previewType;
    }
    public Boolean forceUpdatedCache() {
        return forceUpdatedCache;
    }
    public void setForceUpdatedCache(Boolean forceUpdatedCache) {
        this.forceUpdatedCache = forceUpdatedCache;
    }

    public String getKkProxyAuthorization() {
        return kkProxyAuthorization;
    }

    public void setKkProxyAuthorization(String kkProxyAuthorization) {
        this.kkProxyAuthorization = kkProxyAuthorization;
    }
}
