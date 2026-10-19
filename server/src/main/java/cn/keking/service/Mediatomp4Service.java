package cn.keking.service;

import cn.keking.config.ConfigConstants;
import cn.keking.model.FileAttribute;
import cn.keking.utils.FileConvertStatusManager;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Map;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.locks.ReentrantLock;


/**
 * 视频转换服务 - JavaCV最佳方案
 * 支持：1) 超时控制 2) 进程监控 3) 资源清理 4) 进度反馈
 */
@Component
public class Mediatomp4Service {

    private static final Logger logger = LoggerFactory.getLogger(Mediatomp4Service.class);

    private static final String MP4 = "mp4";

    // 转换任务管理器
    private static final Map<String, ConversionTask> activeTasks = new ConcurrentHashMap<>();

    // 使用带监控的线程池
    private static final ExecutorService videoConversionExecutor = Executors.newVirtualThreadPerTaskExecutor();

    // 监控线程池 - 用于超时监控
    private static final ScheduledExecutorService monitorExecutor =
            Executors.newScheduledThreadPool(2, r -> {
                Thread t = new Thread(r, "ffmpeg-monitor-" + System.currentTimeMillis());
                t.setDaemon(true);
                return t;
            });

    /**
     * 转换任务上下文
     */
    private static class ConversionContext {
        final FFmpegFrameGrabber grabber;
        final FFmpegFrameRecorder recorder;
        final AtomicBoolean cancelled;
        final AtomicLong processedFrames;
        final ReentrantLock lock;
        volatile boolean completed;

        ConversionContext(FFmpegFrameGrabber grabber, FFmpegFrameRecorder recorder) {
            this.grabber = grabber;
            this.recorder = recorder;
            this.cancelled = new AtomicBoolean(false);
            this.processedFrames = new AtomicLong(0);
            this.lock = new ReentrantLock();
            this.completed = false;
        }
    }

    /**
     * 转换任务包装
     */
    private static class ConversionTask {
        final String taskId;
        final CompletableFuture<Boolean> future;
        final ConversionContext context;
        final Thread conversionThread;
        volatile ScheduledFuture<?> timeoutFuture;

        ConversionTask(String taskId, CompletableFuture<Boolean> future,
                       ConversionContext context, Thread conversionThread) {
            this.taskId = taskId;
            this.future = future;
            this.context = context;
            this.conversionThread = conversionThread;
        }
    }

    /**
     * 异步转换方法（带任务ID和超时控制）
     */
    public static CompletableFuture<Boolean> convertToMp4Async(
            String filePath, String outFilePath,String cacheName, FileAttribute fileAttribute) {

        String taskId = generateTaskId(filePath);
        // 立即创建初始状态，防止重复执行
        FileConvertStatusManager.startConvert(cacheName);
        CompletableFuture<Boolean> resultFuture = new CompletableFuture<>();

        // 创建转换线程
        Thread conversionThread = new Thread(() -> {
            try {
                boolean result = convertToMp4WithCancellation(filePath, outFilePath,cacheName,
                        fileAttribute, taskId, resultFuture);
                resultFuture.complete(result);
            } catch (Exception e) {
                resultFuture.completeExceptionally(e);
            } finally {
                activeTasks.remove(taskId);
            }
        }, "ffmpeg-convert-" + taskId);

        conversionThread.setDaemon(true);

        // 启动任务
        try {
            // 先进行预检查
            preCheckFiles(filePath, outFilePath, fileAttribute);

            // 启动转换线程
            conversionThread.start();

            // 设置超时监控
            File inputFile = new File(filePath);
            long fileSizeMB = inputFile.length() / (1024 * 1024);
            scheduleTimeoutMonitor(taskId, calculateTimeout(fileSizeMB),cacheName);
            return resultFuture;

        } catch (Exception e) {
            FileConvertStatusManager.markError(cacheName, "转换过程异常: " + e.getMessage());
            resultFuture.completeExceptionally(e);
            cleanupFailedFile(outFilePath);
            return resultFuture;
        }
    }

    /**
     * 带取消支持的同步转换方法（核心改进）
     */
    private static boolean convertToMp4WithCancellation(
            String filePath, String outFilePath,String cacheName, FileAttribute fileAttribute,
            String taskId, CompletableFuture<Boolean> resultFuture) throws Exception {
        FFmpegFrameGrabber frameGrabber = null;
        FFmpegFrameRecorder recorder = null;
        ConversionContext context = null;
        try {
            File sourceFile = new File(filePath);
            if (!sourceFile.exists()) {
                throw new FileNotFoundException("源文件不存在: " + filePath);
            }
            File desFile = new File(outFilePath);
            FileConvertStatusManager.updateProgress(cacheName, "正在启动转换任务", 10);
            // 初始化抓取器
            frameGrabber = new FFmpegFrameGrabber(sourceFile);
            frameGrabber.setOption("stimeout", "10000000"); // 10秒超时
            frameGrabber.start();

            // 创建录制器
            recorder = new FFmpegFrameRecorder(
                    desFile,
                    frameGrabber.getImageWidth(),
                    frameGrabber.getImageHeight(),
                    Math.max(frameGrabber.getAudioChannels(), 0)
            );

            configureRecorder(recorder, frameGrabber);
            recorder.start();
            FileConvertStatusManager.updateProgress(cacheName, "正在启动转换任务", 40);
            // 创建任务上下文
            context = new ConversionContext(frameGrabber, recorder);

            // 注册任务
            ConversionTask task = new ConversionTask(taskId, resultFuture, context,
                    Thread.currentThread());
            activeTasks.put(taskId, task);

            logger.info("开始转换任务 {}: {} -> {}", taskId, filePath, outFilePath);

            // 核心：使用非阻塞方式读取帧
            return processFramesWithTimeout(frameGrabber, recorder, context, taskId,cacheName);

        } catch (Exception e) {
            // 检查是否是取消操作
            if (context != null && context.cancelled.get()) {
                logger.info("转换任务 {} 被取消", taskId);
                throw new CancellationException("转换被用户取消");
            }
            throw e;
        } finally {
            // 标记完成
            if (context != null) {
                context.completed = true;
            }
            // 清理资源
            closeResources(frameGrabber, recorder);
            // 清理失败文件
            if (context != null && context.cancelled.get()) {
                cleanupFailedFile(outFilePath);
            }
        }
    }

    /**
     * 带超时控制的帧处理（核心改进）
     */
    private static boolean processFramesWithTimeout(
            FFmpegFrameGrabber grabber, FFmpegFrameRecorder recorder,
            ConversionContext context, String taskId, String cacheName) throws Exception {

        long frameCount = 0;
        long startTime = System.currentTimeMillis();
        long lastFrameTime = startTime;
        int consecutiveNullFrames = 0; // 连续读取到null帧的次数
        final int MAX_CONSECUTIVE_NULL_FRAMES = 10; // 最大连续null帧次数

        // 设置读取超时
        grabber.setTimeout(5000); // 5秒读取超时

        try {
            Frame frame;
            while (!context.cancelled.get()) {
                // 检查超时：如果30秒没有新帧，认为超时
                if (System.currentTimeMillis() - lastFrameTime > 30000) {
                    logger.warn("任务 {} 帧读取超时，可能文件损坏", taskId);
                    throw new TimeoutException("帧读取超时");
                }
                // 尝试抓取帧
                frame = grabber.grabFrame();
                FileConvertStatusManager.updateProgress(cacheName, "正在启动转换任务", 60);
                if (frame == null) {
                    consecutiveNullFrames++;

                    // 检查是否达到最大连续null帧次数
                    if (consecutiveNullFrames >= MAX_CONSECUTIVE_NULL_FRAMES) {
                        // 检查是否真的结束了
                        if (grabber.getLengthInFrames() > 0 &&
                                frameCount >= grabber.getLengthInFrames()) {
                            logger.debug("任务 {} 正常结束，总帧数: {}", taskId, frameCount);
                            break;
                        } else {
                            logger.warn("任务 {} 连续读取到 {} 个null帧，可能文件已结束或损坏",
                                    taskId, consecutiveNullFrames);
                            break;
                        }
                    }

                    // 短暂等待后重试，但避免忙等待
                    try {
                        Thread.sleep(50); // 减少sleep时间
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        if (context.cancelled.get()) {
                            throw new CancellationException("转换被取消");
                        }
                        throw e;
                    }
                    continue;
                }
                FileConvertStatusManager.updateProgress(cacheName, "正在启动转换任务", 80);
                // 成功获取到帧，重置计数器
                consecutiveNullFrames = 0;
                lastFrameTime = System.currentTimeMillis();
                frameCount++;

                // 记录帧
                recorder.record(frame);

                // 更新上下文
                context.processedFrames.set(frameCount);

                // 定期日志输出
                if (frameCount % 500 == 0) {
                    long elapsed = System.currentTimeMillis() - startTime;
                    double fps = (frameCount * 1000.0) / elapsed;
                    logger.debug("任务 {}: 已处理 {} 帧, 平均速度: {} fps",
                            taskId, frameCount, String.format("%.2f", fps));

                    // 检查是否被取消
                    if (context.cancelled.get()) {
                        logger.info("任务 {} 在处理中被取消", taskId);
                        return false;
                    }
                }

                // 检查文件大小增长（防止无限循环）
                if (frameCount % 1000 == 0) {
                    checkProgress(taskId, frameCount, startTime);
                }
            }

            // 完成录制
            recorder.stop();
            recorder.close();
            FileConvertStatusManager.updateProgress(cacheName, "正在启动转换任务", 100);
            long totalTime = System.currentTimeMillis() - startTime;
            double fps = totalTime > 0 ? (frameCount * 1000.0) / totalTime : 0;
            logger.info("任务 {} 转换完成: {} 帧, 耗时: {}ms, 平均速度: {} fps",
                    taskId, frameCount, totalTime, String.format("%.2f", fps));
            FileConvertStatusManager.convertSuccess(cacheName);
            return true;

        } catch (Exception e) {
            // 如果是取消操作，不记录为错误
            if (context.cancelled.get()) {
                logger.info("任务 {} 在处理中被取消", taskId);
                throw new CancellationException("转换被取消");
            }
            throw e;
        }
    }

    /**
     * 安全取消指定的转换任务（不中断线程）
     */
    public static void cancelConversion(String taskId) {
        ConversionTask task = activeTasks.get(taskId);
        if (task != null) {
            logger.info("安全取消转换任务: {}", taskId);

            // 如果已经完成，则直接移除任务并返回
            if (task.context.completed) {
                logger.info("转换任务 {} 已经完成，无需取消", taskId);
                activeTasks.remove(taskId);
                return;
            }

            // 标记为取消（不要中断线程）
            task.context.cancelled.set(true);

            // 重要：不要中断线程！让线程自然结束
            // 中断线程可能导致FFmpeg原生代码崩溃

            // 安全地关闭资源
            safeCloseResources(task.context);

            // 取消超时监控
            if (task.timeoutFuture != null && !task.timeoutFuture.isDone()) {
                task.timeoutFuture.cancel(true);
            }

            // 从活跃任务中移除
            activeTasks.remove(taskId);

            logger.info("转换任务 {} 已安全取消", taskId);
        }
    }

    /**
     * 安全关闭资源（替代forceCloseResources）
     */
    private static void safeCloseResources(ConversionContext context) {
        if (context == null) return;

        context.lock.lock();
        try {
            // 使用独立的线程进行资源关闭，避免阻塞当前线程
            Thread cleanupThread = new Thread(() -> {
                try {
                    // 给转换线程一点时间响应取消标志
                    Thread.sleep(1000);

                    // 关闭recorder
                    if (context.recorder != null) {
                        try {
                            if (!context.completed) {
                                try {
                                    context.recorder.stop();
                                } catch (Exception e) {
                                    // 忽略，可能已经停止
                                }
                            }
                            context.recorder.close();
                        } catch (Exception e) {
                            logger.debug("安全关闭recorder时发生异常", e);
                        }
                    }

                    // 关闭grabber
                    if (context.grabber != null) {
                        try {
                            context.grabber.stop();
                            context.grabber.close();
                        } catch (Exception e) {
                            logger.debug("安全关闭grabber时发生异常", e);
                        }
                    }
                } catch (Exception e) {
                    logger.debug("清理线程异常", e);
                }
            }, "ffmpeg-cleanup-" + context.hashCode());

            cleanupThread.setDaemon(true);
            cleanupThread.start();

        } finally {
            context.lock.unlock();
        }
    }

    /**
     * 配置超时监控
     */
    private static void scheduleTimeoutMonitor(String taskId, long timeoutSeconds,String cacheName) {
        ScheduledFuture<?> timeoutFuture = monitorExecutor.schedule(() -> {
            ConversionTask task = activeTasks.get(taskId);
            if (task != null && !task.context.completed) {
                logger.warn("任务 {} 超时 ({}秒)，开始强制终止", taskId, timeoutSeconds);
                FileConvertStatusManager.markTimeout(cacheName);
                cancelConversion(taskId);
                task.future.completeExceptionally(
                        new TimeoutException("转换超时: " + timeoutSeconds + "秒")
                );
            }
        }, timeoutSeconds, TimeUnit.SECONDS);

        // 保存超时future引用
        ConversionTask task = activeTasks.get(taskId);
        if (task != null) {
            task.timeoutFuture = timeoutFuture;
        }
    }

    /**
     * 计算超时时间（根据文件大小）
     */
    public static int calculateTimeout(long fileSizeMB) {
        // 如果超时功能被禁用，返回一个非常大的值
        if (!ConfigConstants.isMediaTimeoutEnabled()) {
            return Integer.MAX_VALUE;
        }

        // 根据文件大小从配置文件读取超时时间
        if (fileSizeMB < 10) return ConfigConstants.getMediaSmallFileTimeout();    // 小文件
        if (fileSizeMB < 50) return ConfigConstants.getMediaMediumFileTimeout();   // 中等文件
        if (fileSizeMB < 200) return ConfigConstants.getMediaLargeFileTimeout();   // 较大文件
        if (fileSizeMB < 500) return ConfigConstants.getMediaXLFileTimeout();      // 大文件
        if (fileSizeMB < 1024) return ConfigConstants.getMediaXXLFileTimeout();    // 超大文件
        return ConfigConstants.getMediaXXXLFileTimeout();                           // 极大文件
    }

    /**
     * 检查转换进度
     */
    private static void checkProgress(String taskId, long frameCount, long startTime) {
        long elapsed = System.currentTimeMillis() - startTime;
        if (elapsed > 0) {
            double fps = (frameCount * 1000.0) / elapsed;
            if (fps < 1.0) { // 速度太慢，可能有问题
                logger.warn("任务 {} 转换速度过慢: {} fps", taskId, String.format("%.2f", fps));
            }
        }
    }

    /**
     * 生成任务ID
     */
    private static String generateTaskId(String filePath) {
        return "task-" + filePath.hashCode() + "-" + System.currentTimeMillis();
    }

    /**
     * 预检查文件
     */
    private static void preCheckFiles(String filePath, String outFilePath,
                                      FileAttribute fileAttribute) throws Exception {
        File sourceFile = new File(filePath);
        if (!sourceFile.exists()) {
            throw new FileNotFoundException("源文件不存在: " + filePath);
        }

    }

    /**
     * 配置录制器（与原方法保持一致）
     */
    private static void configureRecorder(FFmpegFrameRecorder recorder,
                                          FFmpegFrameGrabber grabber) {
        recorder.setFormat(MP4);
        recorder.setFrameRate(grabber.getFrameRate());
        recorder.setSampleRate(grabber.getSampleRate());
        recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);
        // 手机拍摄的视频旋转角度只存在元数据里，帧本身未旋转，需要原样写入输出文件
        double displayRotation = grabber.getDisplayRotation();
        if (displayRotation != 0 && !Double.isNaN(displayRotation)) {
            recorder.setDisplayRotation(displayRotation);
        }

        int videoBitrate = grabber.getVideoBitrate();
        if (videoBitrate <= 0) {
            videoBitrate = 2000 * 1000;
        }
        recorder.setVideoBitrate(videoBitrate);

        if (grabber.getAudioChannels() > 0) {
            recorder.setAudioCodec(avcodec.AV_CODEC_ID_AAC);
            recorder.setAudioBitrate(grabber.getAudioBitrate());
            recorder.setAudioChannels(grabber.getAudioChannels());
        }
    }

    /**
     * 安全关闭资源（带异常保护）
     */
    private static void closeResources(FFmpegFrameGrabber grabber,
                                       FFmpegFrameRecorder recorder) {
        // 先关闭recorder
        if (recorder != null) {
            try {
                // 尝试停止，但忽略可能的异常
                try {
                    recorder.stop();
                } catch (Exception e) {
                    // 忽略，可能已经停止
                }
                // 关闭
                recorder.close();
            } catch (Exception e) {
                logger.warn("关闭recorder时发生异常（已忽略）", e);
            }
        }

        // 再关闭grabber
        if (grabber != null) {
            try {
                // 尝试停止，但忽略可能的异常
                try {
                    grabber.stop();
                } catch (Exception e) {
                    // 忽略，可能已经停止
                }
                // 关闭
                grabber.close();
            } catch (Exception e) {
                logger.warn("关闭grabber时发生异常（已忽略）", e);
            }
        }
    }

    /**
     * 清理失败的文件
     */
    private static void cleanupFailedFile(String filePath) {
        try {
            File failedFile = new File(filePath);
            if (failedFile.exists() && failedFile.delete()) {
                logger.debug("已删除失败的转换文件: {}", filePath);
            }
        } catch (Exception e) {
            logger.warn("无法删除失败的转换文件: {}", filePath, e);
        }
    }

    /**
     * 优雅关闭服务（不强制终止）
     */
    public static void shutdown() {
        logger.info("开始优雅关闭视频转换服务...");

        // 标记所有任务为取消，但不强制关闭
        for (String taskId : activeTasks.keySet()) {
            ConversionTask task = activeTasks.get(taskId);
            if (task != null && !task.context.completed) {
                logger.info("标记任务 {} 为取消状态", taskId);
                task.context.cancelled.set(true);
            }
        }

        // 等待所有任务自然结束（最大等待30秒）
        long startTime = System.currentTimeMillis();
        while (!activeTasks.isEmpty() &&
                (System.currentTimeMillis() - startTime) < 30000) {
            try {
                Thread.sleep(1000);
                logger.info("等待 {} 个转换任务自然结束...", activeTasks.size());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }

        // 关闭监控线程池
        if (monitorExecutor != null && !monitorExecutor.isShutdown()) {
            try {
                monitorExecutor.shutdown();
                if (!monitorExecutor.awaitTermination(5, TimeUnit.SECONDS)) {
                    logger.info("监控线程池未完全关闭，但将继续关闭流程");
                }
            } catch (Exception e) {
                logger.warn("关闭监控线程池时发生异常", e);
            }
        }

        // 关闭转换线程池
        if (videoConversionExecutor != null && !videoConversionExecutor.isShutdown()) {
            try {
                videoConversionExecutor.shutdown();
                if (!videoConversionExecutor.awaitTermination(10, TimeUnit.SECONDS)) {
                    logger.info("转换线程池未完全关闭，但将继续关闭流程");
                }
            } catch (Exception e) {
                logger.warn("关闭转换线程池时发生异常", e);
            }
        }

        // 最后清理剩余的活动任务
        if (!activeTasks.isEmpty()) {
            logger.warn("仍有 {} 个转换任务未完成，将强制移除", activeTasks.size());
            activeTasks.clear();
        }

        logger.info("视频转换服务优雅关闭完成");
    }
}