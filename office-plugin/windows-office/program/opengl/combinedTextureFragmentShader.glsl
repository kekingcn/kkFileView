/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

varying vec2 tex_coord;
varying vec2 alpha_coord;
varying vec2 mask_coord;
#ifdef USE_VERTEX_COLORS
varying vec4 vertex_color;
#endif

uniform sampler2D texture;
uniform sampler2D mask;
uniform sampler2D alpha;

uniform vec4 color;

uniform int type;

#define TYPE_NORMAL       0
#define TYPE_BLEND        1
#define TYPE_MASKED       2
#define TYPE_DIFF         3
#define TYPE_MASKED_COLOR 4

void main()
{
    vec4 texelTexture = texture2D(texture, tex_coord);

    if (type == TYPE_NORMAL)
    {
        gl_FragColor = texelTexture;
    }
    else if (type == TYPE_BLEND)
    {
        vec4 texelMask = texture2D(mask, mask_coord);
        vec4 texelAlpha = texture2D(alpha, alpha_coord);
        gl_FragColor = texelTexture;
        gl_FragColor.a = 1.0 - (1.0 - floor(texelAlpha.r)) * texelMask.r;
    }
    else if (type == TYPE_MASKED)
    {
        vec4 texelMask = texture2D(mask, mask_coord);
        gl_FragColor = texelTexture;
        gl_FragColor.a = 1.0 - texelMask.r;
    }
    else if (type == TYPE_DIFF)
    {
        vec4 texelMask = texture2D(mask, mask_coord);
        float alpha = 1.0 - abs(texelTexture.r - texelMask.r);
        if (alpha > 0.0)
            gl_FragColor = texelMask / alpha;
        gl_FragColor.a = alpha;
    }
    else if (type == TYPE_MASKED_COLOR)
    {
#ifdef USE_VERTEX_COLORS
        gl_FragColor = vertex_color;
#else
        gl_FragColor = color;
#endif
        gl_FragColor.a = 1.0 - texelTexture.r;
    }
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
