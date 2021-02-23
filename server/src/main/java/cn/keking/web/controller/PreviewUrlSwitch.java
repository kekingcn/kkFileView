package cn.keking.web.controller;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @author: skyline
 * @create: 2021/2/22 16:15
 */
@Component
@ConfigurationProperties(prefix = "preview")
public class PreviewUrlSwitch {

    private List<PreviewPath> paths;

    public PreviewUrlSwitch(List<PreviewPath> paths) {
        this.paths = paths;
    }

    public PreviewUrlSwitch() {
    }

    public List<PreviewPath> getPaths() {
        return paths;
    }

    public void setPaths(List<PreviewPath> paths) {
        this.paths = paths;
    }

    // https://welife.hdec.com:8013/minio/wlc/upload/20210201/a8eba15d7cde1997b73461e96e986a36.png
    // http://172.23.0.75:9000/wlc/upload/20210201/a8eba15d7cde1997b73461e96e986a36.png

    //
    // https://welife.hdec.com:8013/fileview/onlinePreview?url=http://172.23.0.75:9000/wlc/upload/20210201/a8eba15d7cde1997b73461e96e986a36.png
    // 处理url
    public String urlOutToIn(String url) {
        if (paths != null && paths.size() > 0) {
            for (PreviewPath path : paths) {
                if (url.startsWith(path.getOut())) {
                    return url.replaceAll(path.getOut(), path.getIn());
                }
            }
        }
        return url;
    }

    public String urlInToOut(String url) {
        if (paths != null && paths.size() > 0) {
            for (PreviewPath path : paths) {
                if (url.startsWith(path.getIn())) {
                    return url.replaceAll(path.getIn(), path.getOut());
                }
            }
        }
        return url;
    }

    public List<String> urlsInToOut(List<String> urls) {
        List<String> newUrls = new ArrayList<>();
        if (paths != null && paths.size() > 0) {
            for (PreviewPath path : paths) {
                urls.forEach(url -> {
                    if (url.startsWith(path.getIn())) {
                        newUrls.add(url.replaceAll(path.getIn(), path.getOut()));
                    } else {
                        newUrls.add(url);
                    }
                });
            }
            return newUrls;
        } else {
            return urls;
        }
    }
}
