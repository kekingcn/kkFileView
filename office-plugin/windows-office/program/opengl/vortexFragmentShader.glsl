/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 150

uniform sampler2D slideTexture;
uniform sampler2D leavingShadowTexture;
uniform sampler2D enteringShadowTexture;

in vec2 v_texturePosition;
in vec3 v_normal;
in vec4 shadowCoordinate;

void main() {
    const vec2 samplingPoints[9] = vec2[](
        vec2(0, 0),
        vec2(-1, -1),
        vec2(-1, 0),
        vec2(-1, 1),
        vec2(0, 1),
        vec2(1, 1),
        vec2(1, 0),
        vec2(1, -1),
        vec2(0, -1)
    );

    // Compute the shadow...
    float visibility = 1.0;
    const float epsilon = 0.0001;

    // for the leaving slide,
    {
    float depthShadow = texture(leavingShadowTexture, shadowCoordinate.xy).r;
    float shadowRadius = (1.0 / (shadowCoordinate.z - depthShadow)) * 1000.0;
    for (int i = 0; i < 9; ++i) {
        vec2 coordinate = shadowCoordinate.xy + samplingPoints[i] / shadowRadius;
        if (texture(leavingShadowTexture, coordinate).r < shadowCoordinate.z - epsilon) {
            visibility -= 0.05;
        }
    }
    }

    // and for entering slide.
    {
    float depthShadow = texture(enteringShadowTexture, shadowCoordinate.xy).r;
    float shadowRadius = (1.0 / (shadowCoordinate.z - depthShadow)) * 1000.0;
    for (int i = 0; i < 9; ++i) {
        vec2 coordinate = shadowCoordinate.xy + samplingPoints[i] / shadowRadius;
        if (texture(enteringShadowTexture, coordinate).r < shadowCoordinate.z - epsilon) {
            visibility -= 0.05;
        }
    }
    }

    vec3 lightVector = vec3(0.0, 0.0, 1.0);
    float light = max(dot(lightVector, v_normal), 0.0);
    vec4 fragment = texture(slideTexture, v_texturePosition);
    vec4 black = vec4(0.0, 0.0, 0.0, fragment.a);
    gl_FragColor = mix(black, fragment, visibility * light);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
