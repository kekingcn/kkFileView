package org.artofsolving.jodconverter.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
public class FileProperties {

    private String filePassword;

    public FileProperties() {
    }

    public Map<String, Object> toMap() {
        Map<String, Object> map = new HashMap();
        if (filePassword != null) {
            map.put("Password", filePassword);
        }

        return map;
    }

    public String getFilePassword() {
        return filePassword;
    }

    public void setFilePassword(String filePassword) {
        this.filePassword = filePassword;
    }

}
