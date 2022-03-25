package cn.keking.service.cache;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public interface CacheDBService
{
    static final int QUEUE_SIZE = 500000;
    final BlockingQueue<String> blockingQueue = new ArrayBlockingQueue<>(QUEUE_SIZE);
}
