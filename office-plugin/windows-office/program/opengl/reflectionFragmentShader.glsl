/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

uniform sampler2D slideTexture;
varying float v_isShadow;
varying vec2 v_texturePosition;
varying vec3 v_normal;

void main() {
    vec3 lightVector = vec3(0.0, 0.0, 1.0);
    float light = max(dot(lightVector, v_normal), 0.0);
    vec4 fragment = texture2D(slideTexture, v_texturePosition);
    vec4 black = vec4(0.0, 0.0, 0.0, fragment.a);
    fragment = mix(black, fragment, light);

    if (v_isShadow > 0.5) {
        if (v_texturePosition.y > 1.0 - 0.3)
            gl_FragColor = mix(fragment, vec4(0.0, 0.0, 0.0, 0.0), (1.0 - v_texturePosition.y) / 0.3);
        else
            discard;
    } else {
        gl_FragColor = fragment;
    }
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
