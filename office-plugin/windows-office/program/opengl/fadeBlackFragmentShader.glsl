/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

uniform sampler2D leavingSlideTexture;
uniform sampler2D enteringSlideTexture;
uniform float time;
varying vec2 v_texturePosition;

void main() {
#ifdef use_white
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0);
#else
    vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
#endif
    vec4 texel;
    float amount;
    if (time < 0.5) {
        texel = texture2D(leavingSlideTexture, v_texturePosition);
        amount = time * 2;
    } else {
        texel = texture2D(enteringSlideTexture, v_texturePosition);
        amount = (1.0 - time) * 2;
    }
    gl_FragColor = mix(texel, color, amount);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
