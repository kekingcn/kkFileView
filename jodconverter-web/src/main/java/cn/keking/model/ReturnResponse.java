package cn.keking.model;

import java.io.Serializable;

/**
 * 接口返回值结构
 * @author yudian-it
 * @date 2017/11/17
 */
public class ReturnResponse<T> implements Serializable{
    private static final long serialVersionUID = 313975329998789878L;
    /**
     * 返回状态
     * 0. 成功
     * 1. 失败
     */
    private int code;

    /**
     * 返回状态描述
     * XXX成功
     * XXX失败
     */
    private String msg;

    private T content;

    public ReturnResponse(int code, String msg, T content) {
        this.code = code;
        this.msg = msg;
        this.content = content;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getContent() {
        return content;
    }

    public void setContent(T content) {
        this.content = content;
    }
}
