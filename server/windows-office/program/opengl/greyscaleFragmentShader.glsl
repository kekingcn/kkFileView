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

void main() {
    vec4 texel = texture2D(sampler, tex_coord);
    gl_FragColor = vec4(vec3(dot(texel.rgb, vec3(0.301, 0.591, 0.108))), 1.0);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
