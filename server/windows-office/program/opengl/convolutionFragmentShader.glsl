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
uniform vec2 offsets[16];
uniform float kernel[16];

varying vec2 tex_coord;

void main(void)
{
    vec4 sum = texture2D(sampler, tex_coord.st) * kernel[0];
    for (int i = 1; i < 16; i++) {
        sum += texture2D(sampler, tex_coord.st - offsets[i]) * kernel[i];
        sum += texture2D(sampler, tex_coord.st + offsets[i]) * kernel[i];
    }
    gl_FragColor = sum;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
