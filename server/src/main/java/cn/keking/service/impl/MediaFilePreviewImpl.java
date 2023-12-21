package cn.keking.service.impl;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.model.FileType;
import cn.keking.model.ReturnResponse;
import cn.keking.service.FileHandlerService;
import cn.keking.service.FilePreview;
import cn.keking.utils.DownloadUtils;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;

import java.io.File;

/**
 * @author : kl
 * @authorboke : kailing.pub
 * @create : 2018-03-25 上午11:58
 * @description:
 **/
@Service
public class MediaFilePreviewImpl implements FilePreview {

    private final FileHandlerService fileHandlerService;
    private final OtherFilePreviewImpl otherFilePreview;
    private static final String mp4 = "mp4";

    public MediaFilePreviewImpl(FileHandlerService fileHandlerService, OtherFilePreviewImpl otherFilePreview) {
        this.fileHandlerService = fileHandlerService;
        this.otherFilePreview = otherFilePreview;
    }

    @Override
    public String filePreviewHandle(String url, Model model, FileAttribute fileAttribute) {
        String fileName = fileAttribute.getName();
        String suffix = fileAttribute.getSuffix();
        String cacheName = fileAttribute.getCacheName();
        String outFilePath = fileAttribute.getOutFilePath();
        boolean forceUpdatedCache = fileAttribute.forceUpdatedCache();
        FileType type = fileAttribute.getType();
        String[] mediaTypesConvert = FileType.MEDIA_CONVERT_TYPES;  //获取支持的转换格式
        boolean mediaTypes = false;
        for (String temp : mediaTypesConvert) {
            if (suffix.equals(temp)) {
                mediaTypes = true;
                break;
            }
        }
        if (!url.toLowerCase().startsWith("http") || checkNeedConvert(mediaTypes)) {  //不是http协议的 //   开启转换方式并是支持转换格式的
            if (forceUpdatedCache || !fileHandlerService.listConvertedFiles().containsKey(cacheName) || !ConfigConstants.isCacheEnabled()) {  //查询是否开启缓存
                ReturnResponse<String> response = DownloadUtils.downLoad(fileAttribute, fileName);
                if (response.isFailure()) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, response.getMsg());
                }
                String filePath = response.getContent();
                String convertedUrl = null;
                try {
                    if (mediaTypes) {
                        convertedUrl = convertToMp4(filePath, outFilePath, fileAttribute);
                    } else {
                        convertedUrl = outFilePath;  //其他协议的  不需要转换方式的文件 直接输出
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (convertedUrl == null) {
                    return otherFilePreview.notSupportedFile(model, fileAttribute, "视频转换异常，请联系管理员");
                }
                if (ConfigConstants.isCacheEnabled()) {
                    // 加入缓存
                    fileHandlerService.addConvertedFile(cacheName, fileHandlerService.getRelativePath(outFilePath));
                }
                model.addAttribute("mediaUrl", fileHandlerService.getRelativePath(outFilePath));
            } else {
                model.addAttribute("mediaUrl", fileHandlerService.listConvertedFiles().get(cacheName));
            }
            return MEDIA_FILE_PREVIEW_PAGE;
        }
        if (type.equals(FileType.MEDIA)) {  // 支持输出 只限默认格式
            model.addAttribute("mediaUrl", url);
            return MEDIA_FILE_PREVIEW_PAGE;
        }
        return otherFilePreview.notSupportedFile(model, fileAttribute, "系统还不支持该格式文件的在线预览");
    }

    /**
     * 检查视频文件转换是否已开启，以及当前文件是否需要转换
     *
     * @return
     */
    private boolean checkNeedConvert(boolean mediaTypes) {
        //1.检查开关是否开启
        if ("true".equals(ConfigConstants.getMediaConvertDisable())) {
            return mediaTypes;
        }
        return false;
    }

    private static String convertToMp4(String filePath, String outFilePath, FileAttribute fileAttribute) throws Exception {
        FFmpegFrameGrabber frameGrabber = FFmpegFrameGrabber.createDefault(filePath);
        Frame captured_frame;
        FFmpegFrameRecorder recorder = null;
        try {
            File desFile = new File(outFilePath);
            //判断一下防止重复转换
            if (desFile.exists()) {
                return outFilePath;
            }
            if (fileAttribute.isCompressFile()) { //判断 是压缩包的创建新的目录
                int index = outFilePath.lastIndexOf("/");  //截取最后一个斜杠的前面的内容
                String folder = outFilePath.substring(0, index);
                File path = new File(folder);
                //目录不存在 创建新的目录
                if (!path.exists()) {
                    path.mkdirs();
                }
            }
            frameGrabber.start();
            recorder = new FFmpegFrameRecorder(outFilePath, frameGrabber.getImageWidth(), frameGrabber.getImageHeight(), frameGrabber.getAudioChannels());
            // recorder.setImageHeight(640);
            // recorder.setImageWidth(480);
            recorder.setFormat(mp4);
            recorder.setFrameRate(frameGrabber.getFrameRate());
            recorder.setSampleRate(frameGrabber.getSampleRate());
            //视频编码属性配置 H.264 H.265 MPEG
            recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);
            //设置视频比特率,单位:b
            recorder.setVideoBitrate(frameGrabber.getVideoBitrate());
            recorder.setAspectRatio(frameGrabber.getAspectRatio());
            // 设置音频通用编码格式
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            //设置音频比特率,单位:b (比特率越高，清晰度/音质越好，当然文件也就越大 128000 = 182kb)
            recorder.setAudioBitrate(frameGrabber.getAudioBitrate());
            recorder.setAudioOptions(frameGrabber.getAudioOptions());
            recorder.setAudioChannels(frameGrabber.getAudioChannels());
            recorder.start();
            while (true) {
                captured_frame = frameGrabber.grabFrame();
                if (captured_frame == null) {
                    System.out.println("转码完成:" + filePath);
                    break;
                }
                recorder.record(captured_frame);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (recorder != null) {   //关闭
                recorder.stop();
                recorder.close();
            }
            frameGrabber.stop();
            frameGrabber.close();
        }
        return outFilePath;
    }

}
