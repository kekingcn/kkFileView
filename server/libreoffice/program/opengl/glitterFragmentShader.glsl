/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

#define M_PI 3.1415926535897932384626433832795

uniform sampler2D leavingSlideTexture;
uniform sampler2D enteringSlideTexture;
varying vec2 v_texturePosition;
varying vec3 v_normal;

uniform float time;
varying float angle;

void main() {
    vec3 lightVector = vec3(0.0, 0.0, 1.0);
    float light = dot(lightVector, v_normal);

    vec4 fragment;
    if (angle < M_PI)
        fragment = texture2D(leavingSlideTexture, v_texturePosition);
    else
        fragment = texture2D(enteringSlideTexture, v_texturePosition);

    vec4 black = vec4(0.0, 0.0, 0.0, fragment.a);
    gl_FragColor = mix(black, fragment, max(light, 0.0));
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
