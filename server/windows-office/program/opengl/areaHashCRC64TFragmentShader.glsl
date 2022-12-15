/* -*- Mode: C++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- */
/*
 * This file is part of the LibreOffice project.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

/* TODO Use textureOffset for newest version of GLSL */


#version 130

uniform sampler2D crc_table;
uniform sampler2D sampler;
uniform float xstep;
uniform float ystep;

varying vec2 tex_coord;

const int scale = 4;
const float ratio = 16.0;


ivec2 crc64( ivec2 hval, int color )
{
    int dx = 2 * ((hval[0] ^ color) & 0xff);
    float s = dx / 255.0;
    vec4 table_value_lo = round(texture2D( crc_table, vec2( s, 0.0 ) ) * 255.0);
    s = (dx+1) / 255.0;
    vec4 table_value_hi = round(texture2D( crc_table, vec2( s, 0.0 ) ) * 255.0);

    int tvalue_lo = int(table_value_lo[0]) | (int(table_value_lo[1]) << 8) | (int(table_value_lo[2]) << 16) | (int(table_value_lo[3]) << 24);
    int tvalue_hi = int(table_value_hi[0]) | (int(table_value_hi[1]) << 8) | (int(table_value_hi[2]) << 16) | (int(table_value_hi[3]) << 24);

    hval[1] = tvalue_hi ^ (hval[1] >> 8);
    hval[0] = tvalue_lo ^ ( (hval[1] << 24) | (hval[0] >> 8) );

    return hval;
}


void main(void)
{
    ivec2 Crc = ivec2( 0xffffffff, 0xffffffff );
    vec2 offset = vec2( 0.0, 0.0 );
    vec2 next_coord = tex_coord.st;
    for( int y = 0; y < scale && next_coord.y <= 1.0; ++y )
    {
        for( int x = 0; x < scale && next_coord.x <= 1.0; ++x )
        {
            vec4 pixel = round(texture2D( sampler, next_coord ) * 255.0);

            int r = int(pixel.r); // 0..255
            int g = int(pixel.g); // 0..255
            int b = int(pixel.b); // 0..255
            int a = int(pixel.a); // 0..255

            Crc = crc64( Crc, r );
            Crc = crc64( Crc, g );
            Crc = crc64( Crc, b );
            Crc = crc64( Crc, a );

            offset.x += xstep;
            next_coord = tex_coord.st + offset;
        }
        offset.y += ystep;
        offset.x = 0.0;
        next_coord = tex_coord.st + offset;
    }

    Crc[0] = ~Crc[0];
    Crc[1] = ~Crc[1];

    int Hash = Crc[0] ^ Crc[1];

    float fr = ( Hash        & 0xff) / 255.0;
    float fg = ((Hash >> 8)  & 0xff) / 255.0;
    float fb = ((Hash >> 16) & 0xff) / 255.0;
    float fa = ((Hash >> 24) & 0xff) / 255.0;


     gl_FragColor = vec4(fr, fg, fb, fa);
}

/* vim:set shiftwidth=4 softtabstop=4 expandtab: */
