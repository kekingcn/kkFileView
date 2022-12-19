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
varying vec2 tex_coord;
uniform mat4 mvp;

void main() {
   gl_Position = mvp * position;
   tex_coord = tex_coord_in;
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
