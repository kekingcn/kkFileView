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
layout(triangle_strip, max_vertices=11) out;

uniform float shadow;
uniform mat4 u_projectionMatrix;
uniform mat4 orthoProjectionMatrix;
uniform mat4 orthoViewMatrix;

in vec2 g_texturePosition[];
in vec3 g_normal[];
in mat4 modelViewMatrix[];
in mat4 transform[];
in float nTime[];
in float startTime[];
in float endTime[];

out vec2 v_texturePosition;
out vec3 v_normal;
out vec4 shadowCoordinate;

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

void emitHexagonVertex(int index, vec3 translation, float fdsq)
{
    mat4 projectionMatrix;
    mat4 shadowMatrix;

    if (shadow < 0.5) {
        projectionMatrix = u_projectionMatrix;
        shadowMatrix = orthoProjectionMatrix * orthoViewMatrix;
    } else {
        projectionMatrix = orthoProjectionMatrix * orthoViewMatrix;
        shadowMatrix = mat4(0.0);
    }

    mat4 normalMatrix = transpose(inverse(modelViewMatrix[index]));

    vec4 pos = gl_in[index].gl_Position + vec4(translation, 0.0);

    // Apply our transform operations.
    pos = transform[index] * pos;

    v_normal = normalize(vec3(normalMatrix * transform[index] * vec4(g_normal[index], 0.0)));
    v_normal.z *= fdsq;

    gl_Position = projectionMatrix * modelViewMatrix[index] * pos;
    shadowCoordinate = translationMatrix(vec3(0.5, 0.5, 0.5)) * scaleMatrix(vec3(0.5, 0.5, 0.5)) * shadowMatrix * modelViewMatrix[index] * pos;
    v_texturePosition = g_texturePosition[index];
    EmitVertex();
}

void main()
{
    const vec4 invalidPosition = vec4(-256.0, -256.0, -256.0, -256.0);
    const vec3 noTranslation = vec3(0.0, 0.0, 0.0);

    if (gl_in[0].gl_Position == invalidPosition)
        return;

    // Draw “walls” to the hexagons.
    if (nTime[0] > startTime[0] && nTime[0] <= endTime[0]) {
        const vec3 translation = vec3(0.0, 0.0, -0.02);

        emitHexagonVertex(2, noTranslation, 0.3);
        emitHexagonVertex(2, translation, 0.3);

        for (int i = 0; i < 3; ++i) {
            emitHexagonVertex(i, noTranslation, 0.3);
            emitHexagonVertex(i, translation, 0.3);
        }

        EndPrimitive();
    }

    // Draw the main quad part.
    for (int i = 0; i < 3; ++i) {
        emitHexagonVertex(i, noTranslation, 1.0);
    }

    EndPrimitive();
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
