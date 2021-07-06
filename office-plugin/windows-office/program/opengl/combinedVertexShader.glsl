/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 130

attribute vec2 position;
attribute vec4 extrusion_vectors;
#ifdef USE_VERTEX_COLORS
attribute vec4 vertex_color_in;
#endif

varying float fade_factor; // fade factor for anti-aliasing
varying float multiply;

#ifdef USE_VERTEX_COLORS
varying vec4 vertex_color;
#endif

uniform float line_width;
uniform float feather; // width where we fade the line

uniform mat4 mvp;

#define TYPE_NORMAL 0
#define TYPE_LINE   1

uniform int type;

void main()
{
   vec2 extrusion_vector = extrusion_vectors.xy;

   float render_thickness = 0.0;

   if (type == TYPE_LINE)
   {
      // miter factor to additionally lengthen the distance of vertex (needed for miter)
      // if 1.0 - miter_factor has no effect
      float miter_factor = 1.0 / abs(extrusion_vectors.z);
      // fade factor is always -1.0 or 1.0 -> we transport that info together with length
      fade_factor = sign(extrusion_vectors.z);
#ifdef USE_VERTEX_COLORS
      float the_feather = (1.0 + sign(extrusion_vectors.w)) / 4.0;
      float the_line_width = abs(extrusion_vectors.w);
#else
      float the_feather = feather;
      float the_line_width = line_width;
#endif
      render_thickness = (the_line_width * miter_factor + the_feather * 2.0 * miter_factor);

      // Calculate the multiplier so we can transform the 0->1 fade factor
      // to take feather and line width into account.

      float start = mix(0.0, (the_line_width / 2.0) - the_feather, the_feather * 2.0);
      float end   = mix(1.0, (the_line_width / 2.0) + the_feather, the_feather * 2.0);

      multiply = 1.0 / (1.0 - (start / end));
   }

   // lengthen the vertex in direction of the extrusion vector by line width.
   vec4 final_position = vec4(position + (extrusion_vector * (render_thickness / 2.0) ), 0.0, 1.0);

   gl_Position = mvp * final_position;

#ifdef USE_VERTEX_COLORS
   vertex_color = vertex_color_in / 255.0;
#endif
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
