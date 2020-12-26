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

class PooledOfficeManagerSettings extends ManagedOfficeProcessSettings {

    public static final long DEFAULT_TASK_EXECUTION_TIMEOUT = 120000L;
    public static final int DEFAULT_MAX_TASKS_PER_PROCESS = 200;

    private long taskExecutionTimeout = DEFAULT_TASK_EXECUTION_TIMEOUT;
    private int maxTasksPerProcess = DEFAULT_MAX_TASKS_PER_PROCESS;

    public PooledOfficeManagerSettings(UnoUrl unoUrl) {
        super(unoUrl);
    }

    public long getTaskExecutionTimeout() {
        return taskExecutionTimeout;
    }

    public void setTaskExecutionTimeout(long taskExecutionTimeout) {
        this.taskExecutionTimeout = taskExecutionTimeout;
    }

    public int getMaxTasksPerProcess() {
        return maxTasksPerProcess;
    }

    public void setMaxTasksPerProcess(int maxTasksPerProcess) {
        this.maxTasksPerProcess = maxTasksPerProcess;
    }

}
