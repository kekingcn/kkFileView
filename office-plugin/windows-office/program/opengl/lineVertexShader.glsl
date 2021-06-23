/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

attribute vec2 position;
attribute vec4 extrusion_vectors;

varying float fade_factor; // fade factor for anti-aliasing

uniform float line_width;
uniform float feather; // width where we fade the line

uniform mat4 mvp;

void main()
{
   vec2 extrusion_vector = extrusion_vectors.xy;
   // miter factor to additionally lengthen the distance of vertex (needed for miter)
   // if 1.0 - miter_factor has no effect
   float miter_factor = 1.0f / abs(extrusion_vectors.z);
   // fade factor is always -1.0 or 1.0 -> we transport that info together with length
   fade_factor = sign(extrusion_vectors.z);

   float rendered_thickness = (line_width + feather * 2.0) * miter_factor;

   // lengthen the vertex in direction of the extrusion vector by line width.
   vec4 position = vec4(position + (extrusion_vector * (rendered_thickness / 2.0) ), 0.0, 1.0);

   gl_Position = mvp * position;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
