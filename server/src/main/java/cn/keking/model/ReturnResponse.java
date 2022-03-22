package cn.keking.model;

import java.io.Serializable;

/**
 * 接口返回值结构
 *
 * @author yudian-it
 * @date 2017/11/17
 */
public class ReturnResponse<T> implements Serializable {
    private static final long serialVersionUID = 313975329998789878L;

    public static final int SUCCESS_CODE = 0;
    public static final int FAILURE_CODE = 1;
    public static final String SUCCESS_MSG = "SUCCESS";
    public static final String FAILURE_MSG = "FAILURE";

    /**
     * 返回状态
     * 0. 成功
     * 1. 失败
     */
    private int responseCode;

    /**
     * 返回状态描述
     * XXX成功
     * XXX失败
     */
    private String responseMessage;

    private T content;

    public ReturnResponse(int responseCode, String responseMessage, T content) {
        this.responseCode = responseCode;
        this.responseMessage = responseMessage;
        this.content = content;
    }

    public static ReturnResponse<Object> failure(String errMsg) {
        return new ReturnResponse<>(FAILURE_CODE, errMsg, null);
    }

    public static ReturnResponse<Object> failure() {
        return failure(FAILURE_MSG);
    }

    public static ReturnResponse<Object> success(){
        return success(null);
    }

    public static ReturnResponse<Object> success(Object content) {
        return new ReturnResponse<>(SUCCESS_CODE, SUCCESS_MSG, content);
    }

    public boolean isSuccess(){
        return SUCCESS_CODE == responseCode;
    }

    public boolean isFailure(){
        return !isSuccess();
    }

    public int getResponseCode() {
        return responseCode;
    }

    public void setResponseCode(int responseCode) {
        this.responseCode = responseCode;
    }

    public String getResponseMessage() {
        return responseMessage;
    }

    public void setResponseMessage(String responseMessage) {
        this.responseMessage = responseMessage;
    }

    public T getContent() {
        return content;
    }

    public void setContent(T content) {
        this.content = content;
    }
}
