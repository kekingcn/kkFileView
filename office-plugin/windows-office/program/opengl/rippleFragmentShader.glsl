/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 120

#define M_PI 3.1415926535897932384626433832795

uniform sampler2D leavingSlideTexture;
uniform sampler2D enteringSlideTexture;
uniform float time;
uniform vec2 center;
uniform float slideRatio;

varying vec2 v_texturePosition;

// This function returns the distance between two points, taking into account the slide ratio.
float betterDistance(vec2 p1, vec2 p2)
{
    p1.x *= slideRatio;
    p2.x *= slideRatio;
    return distance(p1, p2);
}

void main()
{
    const float w = 0.5;
    const float v = 0.1;

    // Distance from this fragment to the center, in slide coordinates.
    float dist = betterDistance(center, v_texturePosition);

    // We want the ripple to span all of the slide at the end of the transition.
    float t = time * (sqrt(2.0) * (slideRatio < 1.0 ? 1.0 / slideRatio : slideRatio));

    // Interpolate the distance to the center in function of the time.
    float mixed = smoothstep(t*w-v, t*w+v, dist);

    // Get the displacement offset from the current pixel, for fragments that have been touched by the ripple already.
    vec2 offset = (v_texturePosition - center) * (sin(dist * 64.0 - time * 16.0) + 0.5) / 32.0;
    vec2 wavyTexCoord = mix(v_texturePosition + offset, v_texturePosition, time);

    // Get the final position we will sample from.
    vec2 pos = mix(wavyTexCoord, v_texturePosition, mixed);

    // Sample from the textures and mix that together.
    vec4 leaving = texture2D(leavingSlideTexture, pos);
    vec4 entering = texture2D(enteringSlideTexture, pos);
    gl_FragColor = mix(entering, leaving, mixed);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
