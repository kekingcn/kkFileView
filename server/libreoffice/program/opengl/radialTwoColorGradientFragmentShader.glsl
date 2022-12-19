/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

uniform vec4   v_startColor4d;
uniform vec4   v_endColor4d;
uniform mat3x2 m_transform;
varying vec2   v_textureCoords2d;
const vec2     v_center2d = vec2(0,0);

void main(void)
{
    gl_FragColor = mix(v_startColor4d,
            v_endColor4d,
            1.0 - distance(
                vec2(
                    m_transform * vec3(v_textureCoords2d,1)),
                v_center2d));
    }

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
