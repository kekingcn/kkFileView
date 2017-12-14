package com.yudianbank.utils;

import com.yudianbank.param.ReturnResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 *  读取类文本文件
 * @author yudian-it
 * @date 2017/12/13
 */
@Component
public class SimTextUtil {
    @Value("${file.dir}")
    String fileDir;
    @Autowired
    DownloadUtils downloadUtils;

    public ReturnResponse<String> readSimText(String url, String fileName, String needEncode){
        ReturnResponse<String> response = downloadUtils.downLoad(url, "txt", fileName, needEncode);
        return response;
    }
}
