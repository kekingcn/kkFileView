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

uniform sampler2D sampler;
uniform sampler2D mask;
uniform sampler2D alpha;

void main()
{
    vec4 texel0, texel1, texel2;

    texel0 = texture2D(sampler, tex_coord);
    texel1 = texture2D(mask, mask_coord);
    texel2 = texture2D(alpha, alpha_coord);
    gl_FragColor = texel0;

    /* Only blend if the alpha texture wasn't fully transparent */
    gl_FragColor.a = 1.0 - (1.0 - floor(texel2.r)) * texel1.r;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
