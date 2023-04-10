package cn.keking.config;

import cn.keking.service.cache.CacheService;
import cn.keking.utils.KkFileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @auther: chenjh
 * @since: 2019/6/11 7:45
 */
@Component
@ConditionalOnExpression("'${cache.clean.enabled:false}'.equals('true')")
public class SchedulerCleanConfig {

    private final Logger logger = LoggerFactory.getLogger(SchedulerCleanConfig.class);

    private final CacheService cacheService;

    public SchedulerCleanConfig(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    private final String fileDir = ConfigConstants.getFileDir();

    private int hour;

    @Value("${cache.clean.hour:0}")
    public void setHour(String hour) {
        this.hour = Integer.parseInt(hour);
    }

    //默认每晚3点执行一次
    @Scheduled(cron = "${cache.clean.cron:0 0 3 * * ?}")
    public void clean() {
        logger.info("Cache clean start");
        cacheService.cleanCache();
        KkFileUtils.cleanDirectory(fileDir, hour * 3600000L);
        logger.info("Cache clean end");
    }
}
