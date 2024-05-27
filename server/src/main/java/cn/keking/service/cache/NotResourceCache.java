package cn.keking.service.cache;

import org.apache.pdfbox.cos.COSObject;
import org.apache.pdfbox.pdmodel.DefaultResourceCache;
import org.apache.pdfbox.pdmodel.documentinterchange.markedcontent.PDPropertyList;
import org.apache.pdfbox.pdmodel.graphics.PDXObject;
import org.apache.pdfbox.pdmodel.graphics.color.PDColorSpace;
import org.apache.pdfbox.pdmodel.graphics.pattern.PDAbstractPattern;
import org.apache.pdfbox.pdmodel.graphics.shading.PDShading;
import org.apache.pdfbox.pdmodel.graphics.state.PDExtendedGraphicsState;

/**
 * @author: Sawyer.Yong
 * @since: 2023/02/18 14:45
 * 解决图片 SoftReference 导致内存无法被回收导致的OOM, 详见 https://issues.apache.org/jira/browse/PDFBOX-3700
 */
public class NotResourceCache extends DefaultResourceCache {

    @Override
    public void put(COSObject indirect, PDColorSpace colorSpace) {
    }
    @Override
    public void put(COSObject indirect, PDExtendedGraphicsState extGState) {
    }
    @Override
    public void put(COSObject indirect, PDShading shading) {
    }
    @Override
    public void put(COSObject indirect, PDAbstractPattern pattern) {
    }
    @Override
    public void  put(COSObject indirect, PDPropertyList propertyList) {
    }
    @Override
    public void put(COSObject indirect, PDXObject xobject) {
    }
}
