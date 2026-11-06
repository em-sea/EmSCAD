// Script Name: EmSCAD Annulus Stencil
// Description: A customizable annulus stencil with upper and lower curved and optional side icons.
// Repository: https://github.com/em-sea/EmSCAD/
// Copyright (C) 2026 em-sea
// SPDX-License-Identifier: GPL-3.0-or-later


/* [Text] */
top_text = "NO FOOD";
bottom_text = "IN SINK";
side_text = "Y";

/* [Sizes in mm] */
outer_size = 111; // 0.1
inner_size = 77; // 0.1
height = 1; // 0.1
top_bottom_margin = 3; // 0.1
side_margin = -0.8; // 0.1
letter_spacing = 1.15; // 0.01
character_width_ratio = 1.25; // 0.01

/* [Fonts] */
font_type = "Allerta Stencil:style=Regular";
side_font = "Stencil Icons:style=Regular";

/* [Hidden] */
EPSILON = 0.02;
$fn = ($preview) ? 32 : 128;

top_bottom_text_size = (outer_size / 2 - inner_size / 2) - top_bottom_margin;
side_text_size = (outer_size / 2 - inner_size / 2) - side_margin;

text_radius = (outer_size / 2 + inner_size / 2) / 2;

function GetCharWidthMultiplier(c) = 
    (c == "I") ? 0.55 : 
    (c == " ") ? 0.4  : 1.0;

module CurvedText(txt, radius, size, height, is_bottom = false) {
    base_char_angle = (size * letter_spacing / radius) * (180 / PI);
    
    char_angles = [for (i = [0 : len(txt) - 1]) base_char_angle * GetCharWidthMultiplier(txt[i])];
    total_angle = [for (a = char_angles) a] * [for (a = char_angles) 1]; // sum of angles
    
    start_angle = is_bottom ? (270 - (total_angle / 2)) : (90 + (total_angle / 2));
    
    for (i = [0 : len(txt) - 1]) {
        offset_sum = (i == 0) ? 0 : [for (j = [0 : i - 1]) char_angles[j]] * [for (j = [0 : i - 1]) 1];
        current_char_center_offset = offset_sum + (char_angles[i] / 2);
        
        angle = is_bottom ? (start_angle + current_char_center_offset) : (start_angle - current_char_center_offset);
        text_rot = is_bottom ? 90 : -90;
        
        char_scale_factor = GetCharWidthMultiplier(txt[i]) < 1.0 ? character_width_ratio * 0.8 : character_width_ratio;
        
        rotate([0, 0, angle])
            translate([radius, 0, 0])
                rotate([0, 0, text_rot])
                    scale([char_scale_factor, 1, 1]) 
                        linear_extrude(h = height)
                            offset(r = max(0.01, 0.2)) 
                                text(txt[i], size = size, valign = "center", halign = "center", font = font_type);
    }
}

module GenerateStencil () {
    difference() {
        cylinder(h = height, d = outer_size);
        
        translate([0, 0, -EPSILON]) {
            cylinder(h = height + (2 * EPSILON), d = inner_size);
            
            CurvedText(
                txt = top_text, 
                radius = text_radius, 
                size = top_bottom_text_size, 
                height = height + (2 * EPSILON)
            );
            
            CurvedText(
                txt = bottom_text, 
                radius = text_radius, 
                size = top_bottom_text_size, 
                height = height + (2 * EPSILON),
                is_bottom = true
            );
            
            translate([-text_radius, 0, 0])
                linear_extrude(h = height + (2 * EPSILON))
                    offset(r = max(0.01, 0.1)) 
                        text(side_text, size = side_text_size * 0.75, valign = "center", halign = "center", font = side_font);
            
            translate([text_radius, 0, 0])
                linear_extrude(h = height + (2 * EPSILON))
                    offset(r = max(0.01, 0.1)) 
                        text(side_text, size = side_text_size * 0.75, valign = "center", halign = "center", font = side_font);
        }
    }
}


// Do The Thing
GenerateStencil();
