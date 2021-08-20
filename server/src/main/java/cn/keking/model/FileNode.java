package cn.keking.model;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class FileNode {

    private String originName;
    private String fileName;
    private String parentFileName;
    private boolean directory;
    //用于图片预览时寻址
    private String fileKey;
    private List<FileNode> childList = new ArrayList<>();

    public String getFileKey() {
        return fileKey;
    }

    public void setFileKey(String fileKey) {
        this.fileKey = fileKey;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getParentFileName() {
        return parentFileName;
    }

    public void setParentFileName(String parentFileName) {
        this.parentFileName = parentFileName;
    }

    public List<FileNode> getChildList() {
        return childList;
    }

    public void setChildList(List<FileNode> childList) {
        this.childList = childList;
    }

    public String getOriginName() {
        return originName;
    }

    public void setOriginName(String originName) {
        this.originName = originName;
    }

    public boolean isDirectory() {
        return directory;
    }

    public void setDirectory(boolean directory) {
        this.directory = directory;
    }

    public void addChild(FileNode childNode) {
        childNode.setParentFileName(this.fileName);
        this.childList.add(childNode);
        this.childList.sort(Comparator.comparing(FileNode::getFileName));
    }

    @Override
    public String toString() {
        return "FileNode{" +
            "originName='" + originName + '\'' +
            ", fileName='" + fileName + '\'' +
            ", parentFileName='" + parentFileName + '\'' +
            ", directory=" + directory +
            ", fileKey='" + fileKey + '\'' +
            '}';
    }
}
