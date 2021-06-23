/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 150

layout(triangles) in;
layout(triangle_strip, max_vertices=27) out;

in mat4 projectionMatrix[];
in mat4 modelViewMatrix[];
in mat4 shadowMatrix[];

uniform float hexagonSize;
uniform sampler2D permTexture;

out vec2 texturePosition;
out float fuzz;
out vec2 v_center;
out vec3 normal;
out vec4 shadowCoordinate;

const float expandFactor = 0.0318;

float snoise(vec2 p)
{
    return texture(permTexture, p).r;
}

mat4 identityMatrix(void)
{
    return mat4(1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0);
}

mat4 scaleMatrix(vec3 axis)
{
    mat4 matrix = identityMatrix();
    matrix[0][0] = axis.x;
    matrix[1][1] = axis.y;
    matrix[2][2] = axis.z;
    return matrix;
}

mat4 translationMatrix(vec3 axis)
{
    mat4 matrix = identityMatrix();
    matrix[3] = vec4(axis, 1.0);
    return matrix;
}

void emitHexagonVertex(vec3 center, vec2 translation)
{
    vec4 pos = vec4(center + hexagonSize * expandFactor * vec3(translation, 0.0), 1.0);
    gl_Position = projectionMatrix[0] * modelViewMatrix[0] * pos;
    shadowCoordinate = translationMatrix(vec3(0.5, 0.5, 0.5)) * scaleMatrix(vec3(0.5, 0.5, 0.5)) * shadowMatrix[0] * modelViewMatrix[0] * pos;
    texturePosition = vec2((pos.x + 1), (1 - pos.y)) / 2;
    EmitVertex();
}

void main()
{
    const vec2 translateVectors[6] = vec2[](
        vec2(-3, -2),
        vec2(0, -4),
        vec2(3, -2),
        vec2(3, 2),
        vec2(0, 4),
        vec2(-3, 2)
    );

    vec3 center = gl_in[0].gl_Position.xyz;

    v_center = (1 + center.xy) / 2;
    fuzz = snoise(center.xy);

    // Draw “walls” to the hexagons.
    if (hexagonSize < 1.0) {
        vec3 rearCenter = vec3(center.xy, -0.3);
        normal = vec3(0.0, 0.0, 0.3);
        emitHexagonVertex(center, translateVectors[5]);
        emitHexagonVertex(rearCenter, translateVectors[5]);

        for (int i = 0; i < 6; ++i) {
            emitHexagonVertex(center, translateVectors[i]);
            emitHexagonVertex(rearCenter, translateVectors[i]);
        }

        EndPrimitive();
    }

    // Draw the main hexagon part.
    normal = vec3(0.0, 0.0, 1.0);
    emitHexagonVertex(center, translateVectors[5]);

    for (int i = 0; i < 6; ++i) {
        emitHexagonVertex(center, translateVectors[i]);
        emitHexagonVertex(center, vec2(0.0, 0.0));
    }

    EndPrimitive();
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
