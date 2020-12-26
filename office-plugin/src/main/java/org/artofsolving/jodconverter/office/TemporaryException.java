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

import java.math.BigDecimal;

/**
 * Represents an error condition that can be temporary, i.e. that could go
 * away by simply retrying the same operation after an interval.  
 */
class TemporaryException extends Exception {

    private static final long serialVersionUID = 7237380113208327295L;

    public TemporaryException(Throwable cause) {
        super(cause);
    }

    public static void main(String[] args) {
        System.out.println(new BigDecimal("7412611111110.99"));
    }
}
