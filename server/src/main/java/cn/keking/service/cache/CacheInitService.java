package cn.keking.service.cache;

public abstract class CacheInitService implements CacheService
{
    public abstract void initPDFCachePool(Integer capacity);
    public abstract void initIMGCachePool(Integer capacity);
    public abstract void initPdfImagesCachePool(Integer capacity);
    public abstract void initMediaConvertCachePool(Integer capacity);
}
