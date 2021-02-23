package cn.keking.web.controller;

import org.springframework.stereotype.Component;

/**
 * @author: skyline
 * @create: 2021/2/22 16:25
 */
@Component
public class PreviewPath {

    private String in;

    private String out;

    public PreviewPath() {
    }

    public PreviewPath(String in, String out) {
        this.in = in;
        this.out = out;
    }

    public String getIn() {
        return in;
    }

    public void setIn(String in) {
        this.in = in;
    }

    public String getOut() {
        return out;
    }

    public void setOut(String out) {
        this.out = out;
    }
}
