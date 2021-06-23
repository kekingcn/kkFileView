/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

uniform sampler2D sampler;
uniform int swidth;
uniform int sheight;
uniform float xscale;
uniform float yscale;
uniform float xoffset;
uniform float yoffset;
uniform float xfrompixelratio;
uniform float yfrompixelratio;
uniform float xtopixelratio;
uniform float ytopixelratio;

varying vec2 tex_coord;

// This mode makes the scaling work like maskedTextureFragmentShader.glsl
// (instead of like plain textureVertexShader.glsl).
#ifdef MASKED
varying vec2 mask_coord;
uniform sampler2D mask;
#endif

#ifdef USE_REDUCED_REGISTER_VARIANT

vec4 getTexel(int x, int y)
{
    vec2 pos = vec2( x * xfrompixelratio + xoffset, y * yfrompixelratio + yoffset );
    vec4 texel = texture2D(sampler, pos);
#ifdef MASKED
    texel.a = 1.0 - texture2D(mask, pos - tex_coord.st + mask_coord.st).r;
#endif
    return texel;
}

void main(void)
{
    // Convert to pixel coordinates again.
    int dx = int(( tex_coord.s - xoffset ) * xtopixelratio );
    int dy = int(( tex_coord.t - yoffset ) * ytopixelratio );

    // Compute the range of source pixels which will make up this destination pixel.
    float fsx1 = min(dx * xscale,   float(swidth - 1));
    float fsx2 = min(fsx1 + xscale, float(swidth - 1));

    float fsy1 = min(dy * yscale,   float(sheight - 1));
    float fsy2 = min(fsy1 + yscale, float(sheight - 1));

    // To whole pixel coordinates.
    int xstart = int(floor(fsx1));
    int xend   = int(floor(fsx2));

    int ystart = int(floor(fsy1));
    int yend   = int(floor(fsy2));

    float xlength = fsx2 - fsx1;
    float ylength = fsy2 - fsy1;

    float xContribution[3];
    xContribution[0] = (1.0 - max(0.0, fsx1 - xstart))     / xlength;
    xContribution[1] =  1.0 / xlength;
    xContribution[2] = (1.0 - max(0.0, (xend + 1) - fsx2)) / xlength;

    float yContribution[3];
    yContribution[0] = (1.0 - max(0.0, fsy1 - ystart))     / ylength;
    yContribution[1] =  1.0 / ylength;
    yContribution[2] = (1.0 - max(0.0, (yend + 1) - fsy2)) / ylength;

    vec4 sumAll = vec4(0.0, 0.0, 0.0, 0.0);
    vec4 texel;
    // First Y pass
    {
        vec4 sumX = vec4(0.0, 0.0, 0.0, 0.0);

        sumX += getTexel(xstart, ystart) * xContribution[0];
        for (int x = xstart + 1; x < xend; ++x)
        {
           sumX += getTexel(x, ystart) * xContribution[1];
        }
        sumX += getTexel(xend, ystart) * xContribution[2];

        sumAll += sumX * yContribution[0];
    }

    // Middle Y Passes
    for (int y = ystart + 1; y < yend; ++y)
    {
        vec4 sumX = vec4(0.0, 0.0, 0.0, 0.0);

        sumX += getTexel(xstart, y) * xContribution[0];
        for (int x = xstart + 1; x < xend; ++x)
        {
            sumX += getTexel(x, y) * xContribution[1];
        }
        sumX += getTexel(xend, y) * xContribution[2];

        sumAll += sumX * yContribution[1];
    }

    // Last Y pass
    {
        vec4 sumX = vec4(0.0, 0.0, 0.0, 0.0);

        sumX += getTexel(xstart, yend) * xContribution[0];
        for (int x = xstart + 1; x < xend; ++x)
        {
            sumX += getTexel(x, yend) * xContribution[1];
        }
        sumX += getTexel(xend, yend) * xContribution[2];

        sumAll += sumX * yContribution[2];
    }

    gl_FragColor = sumAll;
}
#else
void main(void)
{
    // Convert to pixel coordinates again.
    int dx = int(( tex_coord.s - xoffset ) * xtopixelratio );
    int dy = int(( tex_coord.t - yoffset ) * ytopixelratio );

    // How much each column/row will contribute to the resulting pixel.
    // Note: These values are always the same for the same X (or Y),
    // so they could be precalculated in C++ and passed to the shader,
    // but GLSL has limits on the size of uniforms passed to it,
    // so it'd need something like texture buffer objects from newer
    // GLSL versions, and it seems the hassle is not really worth it.
    float xratio[ 16 + 2 ];
    float yratio[ 16 + 2 ];

    // For finding the first and last source pixel.
    int xpixel[ 16 + 2 ];
    int ypixel[ 16 + 2 ];

    int xpos = 0;
    int ypos = 0;

    // Compute the range of source pixels which will make up this destination pixel.
    float fsx1 = dx * xscale;
    float fsx2 = fsx1 + xscale;
    // To whole pixel coordinates.
    int sx1 = int( ceil( fsx1 ) );
    int sx2 = int( floor( fsx2 ) );
    // Range checking.
    sx2 = min( sx2, swidth - 1 );
    sx1 = min( sx1, sx2 );

    // How much one full column contributes to the resulting pixel.
    float width = min( xscale, swidth - fsx1 );

    if( sx1 - fsx1 > 0.001 )
    {   // The first column contributes only partially.
        xpixel[ xpos ] = sx1 - 1;
        xratio[ xpos ] = ( sx1 - fsx1 ) / width;
        ++xpos;
    }
    for( int sx = sx1; sx < sx2; ++sx )
    {   // Columns that fully contribute to the resulting pixel.
        xpixel[ xpos ] = sx;
        xratio[ xpos ] = 1.0 / width;
        ++xpos;
    }
    if( fsx2 - sx2 > 0.001 )
    {   // The last column contributes only partially.
        xpixel[ xpos ] = sx2;
        xratio[ xpos ] = min( min( fsx2 - sx2, 1.0 ) / width, 1.0 );
        ++xpos;
    }

    // The same for Y.
    float fsy1 = dy * yscale;
    float fsy2 = fsy1 + yscale;
    int sy1 = int( ceil( fsy1 ) );
    int sy2 = int( floor( fsy2 ) );
    sy2 = min( sy2, sheight - 1 );
    sy1 = min( sy1, sy2 );

    float height = min( yscale, sheight - fsy1 );

    if( sy1 - fsy1 > 0.001 )
    {
        ypixel[ ypos ] = sy1 - 1;
        yratio[ ypos ] = ( sy1 - fsy1 ) / height;
        ++ypos;
    }
    for( int sy = sy1; sy < sy2; ++sy )
    {
        ypixel[ ypos ] = sy;
        yratio[ ypos ] = 1.0 / height;
        ++ypos;
    }
    if( fsy2 - sy2 > 0.001 )
    {
        ypixel[ ypos ] = sy2;
        yratio[ ypos ] = min( min( fsy2 - sy2, 1.0 ) / height, 1.0 );
        ++ypos;
    }

    int xstart = xpixel[ 0 ];
    int xend = xpixel[ xpos - 1 ];
    int ystart = ypixel[ 0 ];
    int yend = ypixel[ ypos - 1 ];

    vec4 sum = vec4( 0.0, 0.0, 0.0, 0.0 );

    ypos = 0;
    for( int y = ystart; y <= yend; ++y, ++ypos )
    {
        vec4 tmp = vec4( 0.0, 0.0, 0.0, 0.0 );
        xpos = 0;
        for( int x = xstart; x <= xend; ++x, ++xpos )
        {
            vec2 pos = vec2( x * xfrompixelratio + xoffset, y * yfrompixelratio + yoffset );
#ifndef MASKED
            tmp += texture2D( sampler, pos ) * xratio[ xpos ];
#else
            vec4 texel;
            texel = texture2D( sampler, pos );
            texel.a = 1.0 - texture2D( mask, pos - tex_coord.st + mask_coord.st ).r;
            tmp += texel * xratio[ xpos ];
#endif
        }
        sum += tmp * yratio[ ypos ];
    }

    gl_FragColor = sum;
}
#endif
/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
