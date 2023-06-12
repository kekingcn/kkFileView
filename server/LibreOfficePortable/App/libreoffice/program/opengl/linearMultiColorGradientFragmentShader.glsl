/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

uniform int       i_nColors;
uniform sampler1D t_colorArray4d;
uniform sampler1D t_stopArray1d;
uniform mat3x2    m_transform;
varying vec2      v_textureCoords2d;

int max(int x, int y)
{
    if(x > y)
        return x;
    return y;
}

int findBucket(float t)
{
    int nMinBucket=0;
    while( nMinBucket < i_nColors &&
            texture1D(t_stopArray1d, nMinBucket).s < t )
        ++nMinBucket;
    return max(nMinBucket-1,0);
}

void main(void)
{
    float fAlpha =
        clamp( (m_transform * vec3(v_textureCoords2d,1)).s,
                0.0, 1.0 );

    int nMinBucket = findBucket( fAlpha );

    float fLerp =
        (fAlpha-texture1D(t_stopArray1d, nMinBucket).s) /
        (texture1D(t_stopArray1d, nMinBucket+1).s -
         texture1D(t_stopArray1d, nMinBucket).s);

    gl_FragColor = mix(texture1D(t_colorArray4d, nMinBucket),
            texture1D(t_colorArray4d, nMinBucket+1),
            fLerp);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
