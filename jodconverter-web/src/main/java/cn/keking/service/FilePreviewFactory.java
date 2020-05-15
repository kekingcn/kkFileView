package cn.keking.service;

import cn.keking.model.FileAttribute;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * Created by kl on 2018/1/17.
 * Content :
 */
@Service
public class FilePreviewFactory {

    private final ApplicationContext context;

    public FilePreviewFactory(ApplicationContext context) {
        this.context = context;
    }

    public FilePreview get(FileAttribute fileAttribute) {
        Map<String, FilePreview> filePreviewMap = context.getBeansOfType(FilePreview.class);
        return filePreviewMap.get(fileAttribute.getType().getInstanceName());
    }
}
