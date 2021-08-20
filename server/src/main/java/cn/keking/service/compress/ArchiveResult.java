package cn.keking.service.compress;

import cn.keking.model.FileNode;

public class ArchiveResult {

    private FileNode tree;

    public ArchiveResult() {
    }

    public ArchiveResult(FileNode tree) {
        this.tree = tree;
    }

    public FileNode getTree() {
        return tree;
    }

    public void setTree(FileNode tree) {
        this.tree = tree;
    }
}
