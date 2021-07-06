/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*************************************************************************
 *
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * Copyright 2008 by Sun Microsystems, Inc.
 *
 * OpenOffice.org - a multi-platform office productivity suite
 *
 * This file is part of OpenOffice.org.
 *
 * OpenOffice.org is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License version 3
 * only, as published by the Free Software Foundation.
 *
 * OpenOffice.org is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License version 3 for more details
 * (a copy is included in the LICENSE file that accompanied this code).
 *
 * You should have received a copy of the GNU Lesser General Public License
 * version 3 along with OpenOffice.org.  If not, see
 * <http://www.openoffice.org/license.html>
 * for a copy of the LGPLv3 License.
 *
 ************************************************************************/

#version 120

uniform sampler2D leavingSlideTexture;
uniform sampler2D enteringSlideTexture;
uniform sampler2D permTexture;
uniform float time;
varying vec2 v_texturePosition;

float snoise(vec2 P) {

  return texture2D(permTexture, P).r;
}


#define PART 0.5
#define START 0.4
#define END 0.9

void main() {
    float sn = snoise(10.0*v_texturePosition+time*0.07);
    if( time < PART ) {
        float sn1 = snoise(vec2(time*15.0, 20.0*v_texturePosition.y));
        float sn2 = snoise(v_texturePosition);
        if (sn1 > 1.0 - time*time && sn2 < 2.0*time+0.1)
            gl_FragColor = vec4(sn, sn, sn, 1.0);
        else if (time > START )
            gl_FragColor = ((time-START)/(PART - START))*vec4(sn, sn, sn, 1.0) + (1.0 - (time - START)/(PART - START))*texture2D(leavingSlideTexture, v_texturePosition);
        else
            gl_FragColor = texture2D(leavingSlideTexture, v_texturePosition);
    } else if ( time > END ) {
        gl_FragColor = ((1.0 - time)/(1.0 - END))*vec4(sn, sn, sn, 1.0) + ((time - END)/(1.0 - END))*texture2D(enteringSlideTexture, v_texturePosition);
    } else 
        gl_FragColor = vec4(sn, sn, sn, 1.0);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
