/*
Script Name: EmSCAD-Monogram
Description: Generate up to 3 letters with separate font, size, shift, and rotation to help visualize possible monograms.
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
*/

/* [Letter 1] */
letter1_char = "A";
letter1_size = 40; // 0.1
letter1_height = 1.6; // 0.1
letter1_x = 0; // [-100:0.1:100]
letter1_y = 0; // [-100:0.1:100]
letter1_rotation = 0; // [0:1:360]
letter1_color = "red";
letter1_font_style = "Arial:style=Black";

/* [Letter 2] */
letter2_char = "B";
letter2_size = 50; // 0.1
letter2_height = 1.2; // 0.1
letter2_x = 0; // [-100:0.1:100]
letter2_y = 0; // [-100:0.1:100]
letter2_rotation = 45; // [0:1:360]
letter2_color = "purple";
letter2_font_style = "Arial:style=Black";

/* [Letter 3] */
letter3_char = "C";
letter3_size = 64; // 0.1
letter3_height = 0.8; // 0.1
letter3_x = 0; // [-100:0.1:100]
letter3_y = 0; // [-100:0.1:100]
letter3_rotation = 90; // [0:1:360]
letter3_color = "blue";
letter3_font_style = "Arial:style=Black";

/* [Baseplate] */
baseplate_size = 75; // 0.1
baseplate_height = 0.4; // 0.1
base_color = "white";

/* [Hidden] */
$fn = 60;
EPSILON = 0.02;

module MakeLetter(char, size, h, x, y, rotate, col, z_offset, font) {
    translate([x, y, z_offset])
        color(col) 
            linear_extrude(height = h)
                rotate([0, 0, rotate]) 
                    text(text = char, size = size, font = font, halign = "center", valign = "center");
}

// Do The Thing
if (baseplate_size)
    color(base_color) 
        linear_extrude(height = baseplate_height)
            circle(r = max(0.01, baseplate_size / 2));

if (letter1_size) MakeLetter(letter1_char, letter1_size, letter1_height, letter1_x, letter1_y, letter1_rotation, letter1_color, EPSILON, letter1_font_style);
if (letter2_size) MakeLetter(letter2_char, letter2_size, letter2_height, letter2_x, letter2_y, letter2_rotation, letter2_color, EPSILON * 2, letter2_font_style);
if (letter3_size) MakeLetter(letter3_char, letter3_size, letter3_height, letter3_x, letter3_y, letter3_rotation, letter3_color, EPSILON * 3, letter3_font_style);
