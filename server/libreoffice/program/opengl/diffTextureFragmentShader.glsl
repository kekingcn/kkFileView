/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

/*precision mediump float;*/
varying vec2 tex_coord;
varying vec2 mask_coord;
uniform sampler2D texture; /* white background */
uniform sampler2D mask;    /* black background */

void main()
{
    float alpha;
    vec4 texel0, texel1;
    texel0 = texture2D(texture, tex_coord);
    texel1 = texture2D(mask, mask_coord);
    alpha = 1.0 - abs(texel0.r - texel1.r);
    if(alpha > 0.0)
        gl_FragColor = texel1 / alpha;
    gl_FragColor.a = alpha;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
