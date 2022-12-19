/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

uniform vec4   start_color;
uniform vec4   end_color;
uniform vec2   center;
varying vec2   tex_coord;

void main(void)
{
    gl_FragColor = mix(end_color, start_color,
            clamp(distance(tex_coord, center), 0.0, 1.0));
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
