package cn.keking.utils;

import cn.keking.config.ConfigConstants;
import cn.keking.service.cache.CacheService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * @auther: chenjh
 * @since: 2019/6/11 7:45
 */
@Component
@ConditionalOnExpression("'${cache.clean.enabled:false}'.equals('true')")
public class ShedulerClean {

    private final Logger logger = LoggerFactory.getLogger(ShedulerClean.class);

    private final CacheService cacheService;

    public ShedulerClean(CacheService cacheService) {
        this.cacheService = cacheService;
    }

    private final String fileDir = ConfigConstants.getFileDir();

    //默认每晚3点执行一次
    @Scheduled(cron = "${cache.clean.cron:0 0 3 * * ?}")
    public void clean() {
        logger.info("Cache clean start");
        cacheService.cleanCache();
        DeleteFileUtil.deleteDirectory(fileDir);
        logger.info("Cache clean end");
    }
}
