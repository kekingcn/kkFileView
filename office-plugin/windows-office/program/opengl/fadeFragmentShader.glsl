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
    vec4 leavingFragment = texture2D(leavingSlideTexture, v_texturePosition);
    vec4 enteringFragment = texture2D(enteringSlideTexture, v_texturePosition);
    gl_FragColor = mix(leavingFragment, enteringFragment, time);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
