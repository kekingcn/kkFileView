package cn.keking.service;
import java.util.List;
public class ZtreeNodeVo {
    public String id;
    public String pid;
    public String name;
    public List<ZtreeNodeVo> children;
    public void setId(String id) {
        this.id = id;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void setPid(String pid) {
        this.pid = pid;
    }
    public void setChildren(List<ZtreeNodeVo> children) {
        this.children = children;
    }
}