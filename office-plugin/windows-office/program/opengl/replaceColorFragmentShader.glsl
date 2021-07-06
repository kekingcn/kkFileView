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
uniform sampler2D sampler;
uniform vec4 search_color;
uniform vec4 replace_color;
uniform float epsilon;

void main() {
    vec4 texel = texture2D(sampler, tex_coord);
    vec4 diff = clamp(abs(texel - search_color) - epsilon, 0.0, 1.0);
    float bump = max(0.0, 1.0 - ceil(diff.x + diff.y + diff.z));
    gl_FragColor = texel + bump * (replace_color - search_color);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
