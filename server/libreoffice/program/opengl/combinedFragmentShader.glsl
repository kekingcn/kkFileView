/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

varying float fade_factor; // 0->1 fade factor used for AA
varying float multiply;

#ifdef USE_VERTEX_COLORS
varying vec4 vertex_color;
#endif

uniform vec4 color;

#define TYPE_NORMAL 0
#define TYPE_LINE   1

uniform int type;

void main()
{
#ifdef USE_VERTEX_COLORS
    vec4 result = vertex_color;
#else
    vec4 result = color;
#endif

    if (type == TYPE_LINE)
    {
        float dist = (1.0 - abs(fade_factor)) * multiply;
        float alpha = clamp(dist, 0.0, 1.0);
        result.a = result.a * alpha;
    }

    gl_FragColor = result;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
