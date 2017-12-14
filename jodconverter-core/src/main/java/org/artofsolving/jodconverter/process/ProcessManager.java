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
package org.artofsolving.jodconverter.process;

import java.io.IOException;

public interface ProcessManager {

    public static final long PID_NOT_FOUND = -2;
    public static final long PID_UNKNOWN = -1;

    void kill(Process process, long pid) throws IOException;

    /**
     * @param query
     * @return the pid if found, {@link #PID_NOT_FOUND} if not,
     *   or {@link #PID_UNKNOWN} if this implementation is unable to find out
     * @throws IOException
     */
    long findPid(ProcessQuery query) throws IOException;

}
