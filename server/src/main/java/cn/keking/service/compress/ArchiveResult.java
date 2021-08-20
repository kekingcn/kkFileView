package cn.keking.service.compress;

import cn.keking.model.FileNode;

import java.util.List;

public class ArchiveResult {

    private FileNode tree;

    private List<String> imageUrls;

    public ArchiveResult() {
    }

    public ArchiveResult(FileNode tree) {
        this.tree = tree;
    }

    public ArchiveResult(FileNode tree, List<String> imageUrls) {
        this.tree = tree;
        this.imageUrls = imageUrls;
    }

    public FileNode getTree() {
        return tree;
    }

    public void setTree(FileNode tree) {
        this.tree = tree;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
}
