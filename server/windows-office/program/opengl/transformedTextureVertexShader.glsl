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
uniform vec2 viewport;
uniform mat4 transform;
uniform mat4 mvp;
varying vec2 tex_coord;
varying vec2 mask_coord;

void main() {
    vec4 pos = mvp * transform * position;
    gl_Position = pos;
    tex_coord = tex_coord_in;
    mask_coord = mask_coord_in;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
