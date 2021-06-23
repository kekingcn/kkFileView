/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

attribute vec4 position;
attribute vec2 tex_coord_in;
attribute vec2 mask_coord_in;
attribute vec2 alpha_coord_in;
#ifdef USE_VERTEX_COLORS
attribute vec4 vertex_color_in;
#endif

varying vec2 tex_coord;
varying vec2 mask_coord;
varying vec2 alpha_coord;
#ifdef USE_VERTEX_COLORS
varying vec4 vertex_color;
#endif

uniform mat4 mvp;
uniform mat4 transform;

uniform int type;

void main()
{
   gl_Position = mvp * transform * position;
   tex_coord = tex_coord_in;
   mask_coord = mask_coord_in;
   alpha_coord = alpha_coord_in;
#ifdef USE_VERTEX_COLORS
   vertex_color = vertex_color_in / 255.0;
#endif
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
