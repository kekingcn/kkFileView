/* -*- Mode: C; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#version 150

#define M_PI 3.1415926535897932384626433832795

in vec3 a_position;

uniform mat4 u_projectionMatrix;
uniform mat4 u_modelViewMatrix;
uniform mat4 u_sceneTransformMatrix;
uniform mat4 u_primitiveTransformMatrix;
uniform mat4 u_operationsTransformMatrix;

uniform float time;
uniform float selectedTexture;
uniform float shadow;
uniform mat4 orthoProjectionMatrix;
uniform mat4 orthoViewMatrix;

// Workaround for Intel's Windows driver, to prevent optimisation breakage.
uniform float zero;

out mat4 projectionMatrix;
out mat4 modelViewMatrix;
out mat4 shadowMatrix;

mat4 identityMatrix(void)
{
    return mat4(1.0, 0.0, 0.0, 0.0,
                0.0, 1.0, 0.0, 0.0,
                0.0, 0.0, 1.0, 0.0,
                0.0, 0.0, 0.0, 1.0);
}

mat4 translationMatrix(vec3 axis)
{
    return mat4(1.0,    0.0,    0.0,    0.0,
                0.0,    1.0,    0.0,    0.0,
                0.0,    0.0,    1.0,    0.0,
                axis.x, axis.y, axis.z, 1.0);
}

mat4 scaleMatrix(vec3 axis)
{
    return mat4(axis.x, 0.0,    0.0,    0.0,
                0.0,    axis.y, 0.0,    0.0,
                0.0,    0.0,    axis.z, 0.0,
                0.0,    0.0,    0.0,    1.0);
}

mat4 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

void main( void )
{
    mat4 nmodelViewMatrix = u_modelViewMatrix * u_operationsTransformMatrix * u_sceneTransformMatrix * u_primitiveTransformMatrix;
    mat4 transformMatrix = identityMatrix();

    // TODO: use the aspect ratio of the slide instead.
    mat4 slideScaleMatrix = scaleMatrix(vec3(0.75, 1, 1));
    mat4 invertSlideScaleMatrix = scaleMatrix(1.0 / vec3(0.75, 1, 1));

    // These ugly zero comparisons are a workaround for Intel's Windows driver optimisation bug.
    if (selectedTexture > 0.5) {
        // Leaving texture
        if (zero < 1.0)
            transformMatrix = invertSlideScaleMatrix * transformMatrix;
        if (zero < 2.0)
            transformMatrix = rotationMatrix(vec3(0.0, 0.0, 1.0), -pow(time, 3) * M_PI) * transformMatrix;
        if (zero < 3.0)
            transformMatrix = slideScaleMatrix * transformMatrix;
        if (zero < 4.0)
            transformMatrix = scaleMatrix(vec3(1 + pow(2 * time, 2.1), 1 + pow(2 * time, 2.1), 0)) * transformMatrix;
        if (zero < 5.0)
            transformMatrix = translationMatrix(vec3(0, 0, 6 * time)) * transformMatrix;
    } else {
        // Entering texture
        if (zero < 1.0)
            transformMatrix = invertSlideScaleMatrix * transformMatrix;
        if (zero < 2.0)
            transformMatrix = rotationMatrix(vec3(0.0, 0.0, 1.0), pow(0.8 * (time - 1.0), 2.0) * M_PI) * transformMatrix;
        if (zero < 3.0)
            transformMatrix = slideScaleMatrix * transformMatrix;
        if (zero < 4.0)
            transformMatrix = translationMatrix(vec3(0, 0, 28 * (sqrt(time) - 1))) * transformMatrix;
    }

    if (shadow < 0.5) {
        projectionMatrix = u_projectionMatrix;
        shadowMatrix = orthoProjectionMatrix * orthoViewMatrix;
    } else {
        projectionMatrix = orthoProjectionMatrix * orthoViewMatrix;
        shadowMatrix = mat4(0.0);
    }

    modelViewMatrix = nmodelViewMatrix * transformMatrix;
    gl_Position = vec4(a_position, 1.0);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
