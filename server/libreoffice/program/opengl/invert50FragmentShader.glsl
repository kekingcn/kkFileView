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

void main() {
    vec2 tex_mod = mod(gl_FragCoord, 2).xy;
    bool bLeft = (tex_mod.x > 0.0) && (tex_mod.x < 1.0);
    bool bTop = (tex_mod.y > 0.0) && (tex_mod.y < 1.0);
    // horrors - where is the XOR operator ?
    if ((bTop && bLeft) || (!bTop && !bLeft))
        gl_FragColor = vec4(255,255,255,0);
    else
        gl_FragColor = vec4(0,0,0,0);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
