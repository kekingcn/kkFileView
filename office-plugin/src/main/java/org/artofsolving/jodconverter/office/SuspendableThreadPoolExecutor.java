//
// JODConverter - Java OpenDocument Converter
// Copyright 2004-2012 Mirko Nasato and contributors
//
// JODConverter is Open Source software, you can redistribute it and/or
// modify it under either (at your option) of the following licenses
//
// 1. The GNU Lesser General Public License v3 (or later)
//    -> http://www.gnu.org/licenses/lgpl-3.0.txt
// 2. The Apache License, Version 2.0
//    -> http://www.apache.org/licenses/LICENSE-2.0.txt
//
package org.artofsolving.jodconverter.office;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

class SuspendableThreadPoolExecutor extends ThreadPoolExecutor {

    private boolean available = false;
    private ReentrantLock suspendLock = new ReentrantLock();
    private Condition availableCondition = suspendLock.newCondition();

    public SuspendableThreadPoolExecutor(ThreadFactory threadFactory) {
        super(1, 1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<Runnable>(), threadFactory);
    }

    @Override
    protected void beforeExecute(Thread thread, Runnable task) {
        super.beforeExecute(thread, task);
        suspendLock.lock();
        try {
            while (!available) {
                availableCondition.await();
            }
        } catch (InterruptedException interruptedException) {
            thread.interrupt();
        } finally {
            suspendLock.unlock();
        }
    }

    public void setAvailable(boolean available) {
        suspendLock.lock();
        try {
            this.available = available;
            if (available) {
                availableCondition.signalAll();
            }
        } finally {
            suspendLock.unlock();
        }
    }

}
