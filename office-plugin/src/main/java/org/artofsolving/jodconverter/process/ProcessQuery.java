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

public class ProcessQuery {

    private final String command;
    private final String argument;

    public ProcessQuery(String command, String argument) {
        this.command = command;
        this.argument = argument;
    }

    public String getCommand() {
        return command;
    }

    public String getArgument() {
        return argument;
    }

}
