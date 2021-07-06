/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/* TODO Use textureOffset for newest version of GLSL */

#version 130

uniform sampler2D sampler;
uniform int xscale;
uniform int yscale;
uniform float xstep;
uniform float ystep;
uniform float ratio; // = 1.0/(xscale*yscale)

varying vec2 tex_coord;

// This mode makes the scaling work like maskedTextureFragmentShader.glsl
// (instead of like plain textureVertexShader.glsl).
#ifdef MASKED
varying vec2 mask_coord;
uniform sampler2D mask;
#endif

/*
 Just make the resulting color the average of all the source pixels
 (which is an area (xscale)x(yscale) ).
*/
void main(void)
{
    vec4 sum = vec4( 0.0, 0.0, 0.0, 0.0 );
    vec2 offset = vec2( 0.0, 0.0 );
    for( int y = 0; y < yscale; ++y )
    {
        for( int x = 0; x < xscale; ++x )
        {
#ifndef MASKED
            sum += texture2D( sampler, tex_coord.st + offset );
#else
            vec4 texel;
            texel = texture2D( sampler, tex_coord.st + offset );
            texel.a = 1.0 - texture2D( mask, mask_coord.st + offset ).r;
            sum += texel;
#endif
            offset.x += xstep;
        }
        offset.y += ystep;
        offset.x = 0.0;
    }
    sum *= ratio;
    gl_FragColor = sum;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
