package cn.keking.service.cache.impl;

import cn.keking.service.cache.CacheService;
import org.junit.jupiter.api.Test;
import org.redisson.api.RMapCache;
import org.redisson.api.RedissonClient;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

/**
 * CacheServiceRedisImpl 回归测试。
 *
 * 背景：cache.type=redis 时预览单张图片，compressFileKey 为 null，
 * 修复前会把 null 直接传给 Redisson，抛出 NullPointerException: map key can't be null。
 */
class CacheServiceRedisImplTests {

    @Test
    void shouldReturnEmptyListWhenKeyIsNull() {
        RedissonClient redissonClient = mock(RedissonClient.class);
        CacheServiceRedisImpl cacheService = new CacheServiceRedisImpl(redissonClient);

        List<String> result = cacheService.getImgCache(null);

        assertNotNull(result);
        assertTrue(result.isEmpty());
        // 判空后不应再访问 Redis —— 修复前这里会调用 getMapCache 并抛出 NPE
        verifyNoInteractions(redissonClient);
    }

    @Test
    void shouldReturnEmptyListWhenKeyIsEmpty() {
        RedissonClient redissonClient = mock(RedissonClient.class);
        CacheServiceRedisImpl cacheService = new CacheServiceRedisImpl(redissonClient);

        List<String> result = cacheService.getImgCache("");

        assertNotNull(result);
        assertTrue(result.isEmpty());
        verifyNoInteractions(redissonClient);
    }

    @Test
    void shouldReadFromRedisWhenKeyIsPresent() {
        RedissonClient redissonClient = mock(RedissonClient.class);
        @SuppressWarnings("unchecked")
        RMapCache<String, List<String>> mapCache = mock(RMapCache.class);
        when(redissonClient.<String, List<String>>getMapCache(CacheService.FILE_PREVIEW_IMGS_KEY))
                .thenReturn(mapCache);
        when(mapCache.get("zip-key")).thenReturn(List.of("a.png", "b.png"));

        CacheServiceRedisImpl cacheService = new CacheServiceRedisImpl(redissonClient);

        List<String> result = cacheService.getImgCache("zip-key");

        assertEquals(List.of("a.png", "b.png"), result);
    }
}
