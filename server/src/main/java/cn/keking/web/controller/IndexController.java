package cn.keking.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 *  页面跳转
 * @author yudian-it
 * @date 2017/12/27
 */
@Controller
public class IndexController {

    @GetMapping( "/index")
    public String go2Index(){
        return "index";
    }

    @GetMapping( "/record")
    public String go2Record(){
        return "record";
    }

    @GetMapping( "/comment")
    public String go2Comment(){
        return "comment";
    }

    @GetMapping( "/")
    public String root() {
        return "redirect:/index";
    }
}
