/*
  Script Name: EmSCAD-Mandala
  Description: Generates stacked geometric layers with customizable styles and cutout options. The preview includes layer numbers, an image underlay to assist with planning, and layer colors.
  Repository: https://github.com/em-sea/EmSCAD/
  Copyright (C) 2026 em-sea
  SPDX-License-Identifier: GPL-3.0-or-later
  Glossary:
    Image: Image to display under the shape during preview to help with tracing
    Thickness: Layer outline size
    Base Height: Outline infill (Optional but VERY needed for most prints)
    Cutout Mode: Only display the infills with no outlines for coloring in a slicer
    Layer: One of the shapes that starts at a radius, has an outline thickness, may cutout the layer below it, begins at the degree in start, and either repeats or specifies sides
    Circle: Number of sides determines shape - 3 is triangle, etc.
    Dot1: Filled dot the size of outline and repeats with sides number
    Dot2: Hollow dot that behaves like Dot1
    Petal1: Petal with narrower shape and solid outline
    Petal2: Petal with wider shape and 2 lined outline with a dashed line in the middle
    Line1: Horizontal line of thickness 1 where the outline defines the length
 Inspirations: Seeing the image in Avatar: Seven Havens inspired me to create a mandala script. I never would have figured out the Bezier Curves needed for petals without https://www.desmos.com/calculator/cahqdxeshd.
*/

/* {Background image for previews] */
image = "";
image_type = "png"; // ["png", "svg"]
image_color = "white";
image_scale_x = 100;
image_height = 5;

/* [Mandala Settings] */
thickness = 1; // [0.1:0.1:10]
base_height = 0.6; // [0:0.1:10]
cutout_mode = false;

/* [Layer 1] */
layer_1_preview_color = "Magenta";
layer_1_style = "circle"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_1_sides = 240;
layer_1_radius = 50; // [0.1:0.1:200]
layer_1_outline = 3; // [0.1:0.1:50]
layer_1_start = 0; // [0:1:180]
layer_1_cut_below = false;

/* [Layer 2] */
layer_2_preview_color = "DarkViolet";
layer_2_style = "petal1"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_2_sides = 3;
layer_2_radius = 50; // [0.1:0.1:200]
layer_2_outline = 2; // [0.1:0.1:50]
layer_2_start = 60;
layer_2_cut_below = false;

/* [Layer 3] */
layer_3_preview_color = "Blue";
layer_3_style = "petal2"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_3_sides = 3;
layer_3_radius = 48; // [0.1:0.1:200]
layer_3_outline = 2; // [0.1:0.1:50]
layer_3_start = 0;
layer_3_cut_below = false;

/* [Layer 4] */
layer_4_preview_color = "DeepPink";
layer_4_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_4_sides = 48;
layer_4_radius = 45; // [0.1:0.1:200]
layer_4_outline = 1; // [0.1:0.1:50]
layer_4_start = 0;
layer_4_cut_below = false;

/* [Layer 5] */
layer_5_preview_color = "Gold";
layer_5_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_5_sides = 4;
layer_5_radius = 45; // [0.1:0.1:200]
layer_5_outline = 1.6; // [0.1:0.1:50]
layer_5_start = 135;
layer_5_cut_below = true;

/* [Layer 6] */
layer_6_preview_color = "DarkOrange";
layer_6_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_6_sides = 4;
layer_6_radius = 50; // [0.1:0.1:200]
layer_6_outline = 1; // [0.1:0.1:50]
layer_6_start = 0;
layer_6_cut_below = false;

/* [Layer 7] */
layer_7_preview_color = "DodgerBlue";
layer_7_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_7_sides = 8;
layer_7_radius = 49.5; // [0.1:0.1:200]
layer_7_outline = 1; // [0.1:0.1:50]
layer_7_start = 0;
layer_7_cut_below = false;

/* [Layer 8] */
layer_8_preview_color = "Navy";
layer_8_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_8_sides = 100;
layer_8_radius = 51; // [0.1:0.1:200]
layer_8_outline = 1; // [0.1:0.1:50]
layer_8_start = 15;
layer_8_cut_below = false;

/* [Layer 9] */
layer_9_preview_color = "White";
layer_9_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_9_sides = 100;
layer_9_radius = 88; // [0.1:0.1:200]
layer_9_outline = 1; // [0.1:0.1:50]
layer_9_start = 0;
layer_9_cut_below = true;

/* [Layer 10] */
layer_10_preview_color = "Lime";
layer_10_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_10_sides = 4;
layer_10_radius = 50; // [0.1:0.1:200]
layer_10_outline = 1; // [0.1:0.1:50]
layer_10_start = 0;
layer_10_cut_below = false;

/* [Layer 11] */
layer_11_preview_color = "Crimson";
layer_11_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_11_sides = 150;
layer_11_radius = 94; // [0.1:0.1:200]
layer_11_outline = 1; // [0.1:0.1:50]
layer_11_start = 0;
layer_11_cut_below = false;

/* [Layer 12] */
layer_12_preview_color = "Cyan";
layer_12_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_12_sides = 150;
layer_12_radius = 96; // [0.1:0.1:200]
layer_12_outline = 1; // [0.1:0.1:50]
layer_12_start = 15;
layer_12_cut_below = false;

/* [Layer 13] */
layer_13_preview_color = "DarkSeaGreen";
layer_13_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_13_sides = 4;
layer_13_radius = 105; // [0.1:0.1:200]
layer_13_outline = 13; // [0.1:0.1:50]
layer_13_start = 45;
layer_13_cut_below = false;

/* [Layer 14] */
layer_14_preview_color = "MediumPurple";
layer_14_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_14_sides = 4;
layer_14_radius = 112; // [0.1:0.1:200]
layer_14_outline = 1.2; // [0.1:0.1:50]
layer_14_start = 45;
layer_14_cut_below = false;

/* [Layer 15] */
layer_15_preview_color = "DarkCyan";
layer_15_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_15_sides = 4;
layer_15_radius = 94.7; // [0.1:0.1:200]
layer_15_outline = 4; // [0.1:0.1:50]
layer_15_start = 45;
layer_15_cut_below = true;

/* [Layer 16] */
layer_16_preview_color = "Red";
layer_16_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_16_sides = 4;
layer_16_radius = 94.7; // [0.1:0.1:200]
layer_16_outline = 1.6; // [0.1:0.1:50]
layer_16_start = 45;
layer_16_cut_below = false;

/* [Layer 17] */
layer_17_preview_color = "Chocolate";
layer_17_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_17_sides = 4;
layer_17_radius = 49; // [0.1:0.1:200]
layer_17_outline = 9; // [0.1:0.1:50]
layer_17_start = 45;
layer_17_cut_below = true;

/* [Layer 18] */
layer_18_preview_color = "Yellow";
layer_18_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_18_sides = 4;
layer_18_radius = 50; // [0.1:0.1:200]
layer_18_outline = 1; // [0.1:0.1:50]
layer_18_start = 0;
layer_18_cut_below = false;

/* [Layer 19] */
layer_19_preview_color = "GreenYellow";
layer_19_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_19_sides = 4;
layer_19_radius = 50; // [0.1:0.1:200]
layer_19_outline = 1; // [0.1:0.1:50]
layer_19_start = 0;
layer_19_cut_below = false;

/* [Layer 20] */
layer_20_preview_color = "Black";
layer_20_style = "none"; // ["circle", "dot1", "dot2", "petal1", "petal2", "line1", "none"]
layer_20_sides = 4;
layer_20_radius = 50; // [0.1:0.1:200]
layer_20_outline = 1; // [0.1:0.1:50]
layer_20_start = 0;
layer_20_cut_below = false;

/* [Hidden] */
EPSILON = 0.02;

transparency = ($preview && image) ? 0.4 : 1;

layer_colors = [
    layer_1_preview_color, layer_2_preview_color, layer_3_preview_color, layer_4_preview_color, layer_5_preview_color,
    layer_6_preview_color, layer_7_preview_color, layer_8_preview_color, layer_9_preview_color, layer_10_preview_color,
    layer_11_preview_color, layer_12_preview_color, layer_13_preview_color, layer_14_preview_color, layer_15_preview_color,
    layer_16_preview_color, layer_17_preview_color, layer_18_preview_color, layer_19_preview_color, layer_20_preview_color
];

function Bezier(p0, p1, p2, p3, t) = 
    pow(1 - t, 3) * p0 + 
    3 * pow(1 - t, 2) * t * p1 + 
    3 * (1 - t) * pow(t, 2) * p2 + 
    pow(t, 3) * p3;

function GetPetalOutline1(radius, sides, outline, steps = 100) = let(
    safe_radius = max(0.01, radius),
    safe_outline = max(0.01, outline),
    petal_width = 2 * safe_radius * sin(180 / sides),
    scale_factor = (petal_width + safe_outline) / 80,
    y_local = 40 * scale_factor,
    x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius,
    p0_left  = [x_local,  40 * scale_factor, 0],
    p1_left  = [42,  45, 0] * scale_factor,
    p2_left  = [59,  1, 0] * scale_factor,
    p3_left  = [79,  0, 0] * scale_factor,
    p0_right = [x_local, -40 * scale_factor, 0],
    p1_right = [42, -45, 0] * scale_factor,
    p2_right = [59, -1, 0] * scale_factor,
    p3_right = [79,  0, 0] * scale_factor,
    left_points  = [ for (i = [0 : steps]) let(pt = Bezier(p0_left, p1_left, p2_left, p3_left, i / steps)) [pt[0], pt[1]] ],
    right_points = [ for (i = [steps : -1 : 0]) let(pt = Bezier(p0_right, p1_right, p2_right, p3_right, i / steps)) [pt[0], pt[1]] ]
) concat(left_points, right_points);

function GetPetalOutline2(radius, sides, outline, steps = 100) = let(
    safe_radius = max(0.01, radius),
    safe_outline = max(0.01, outline),
    petal_width = 2 * safe_radius * sin(180 / sides),
    scale_factor = (petal_width + safe_outline) / 80,
    y_local = 40 * scale_factor,
    x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius,
    p0_left  = [x_local,  40 * scale_factor, 0],
    p1_left  = [45,  57, 0] * scale_factor,
    p2_left  = [65,  14, 0] * scale_factor,
    p3_left  = [90,  0, 0] * scale_factor,
    p0_right = [x_local, -40 * scale_factor, 0],
    p1_right = [45, -57, 0] * scale_factor,
    p2_right = [65, -14, 0] * scale_factor,
    p3_right = [90,  0, 0] * scale_factor,
    left_points  = [ for (i = [0 : steps]) let(pt = Bezier(p0_left, p1_left, p2_left, p3_left, i / steps)) [pt[0], pt[1]] ],
    right_points = [ for (i = [steps : -1 : 0]) let(pt = Bezier(p0_right, p1_right, p2_right, p3_right, i / steps)) [pt[0], pt[1]] ]
) concat(left_points, right_points);

module GetLayer2D(index, style, sides, radius, outline, start) {
    safe_radius = max(0.01, radius);
    safe_outline = max(0.01, outline);
    if ($preview) {
            rotate([0, 0, start+safe_outline]) translate([safe_radius+safe_outline,0]) {
            difference () {
                circle(r=3, $fn = 6);
                text(str(index+1), size=2, valign="center", halign="center");
            }
        }
    }

    if (style == "circle") {
        if (safe_outline >= 3) {
            union() {
                difference() {
                    rotate([0, 0, start]) circle(r = safe_radius, $fn = sides);
                    rotate([0, 0, start]) circle(r = safe_radius - 1, $fn = sides);
                }
                difference() {
                    rotate([0, 0, start]) circle(r = safe_radius - safe_outline + 1, $fn = sides);
                    rotate([0, 0, start]) circle(r = safe_radius - safe_outline, $fn = sides);
                }
            }
        } else {
            difference() {
                rotate([0, 0, start]) circle(r = safe_radius, $fn = sides);
                rotate([0, 0, start]) circle(r = safe_radius - safe_outline, $fn = sides);
            }
        }
    } else if (style == "dot1") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) circle(r = safe_outline, $fn = 32);
            }
        }
    } else if (style == "dot2") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0])
                        difference() {
                            circle(r = safe_outline, $fn = 32);
                            circle(r = max(0.01, safe_outline - 1), $fn = 32);
                        }
            }
        }
    } else if (style == "petal1") {
        petal_outline = GetPetalOutline1(safe_radius, sides, safe_outline, 100);
        petal_width = 2 * safe_radius * sin(180 / sides);
        scale_factor = (petal_width + safe_outline) / 80;
        y_local = 40 * scale_factor;
        x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius;

        union() {
            for (i = [0 : sides - 1]) {
                theta = start + i * (360 / sides);
                alpha1 = theta - 180 / sides;
                alpha2 = theta + 180 / sides;
                R = 500;
                intersection() {
                    rotate([0, 0, theta])
                        translate([safe_radius, 0, 0])
                            difference() {
                                difference() {
                                    polygon(points = petal_outline);
                                    offset(delta = -safe_outline) polygon(points = petal_outline);
                                }
                                translate([x_local - EPSILON, -50 * scale_factor])
                                    square([safe_outline + (2 * EPSILON), 100 * scale_factor]);
                            }
                    polygon(points = [
                        [0, 0],
                        [R * cos(alpha1), R * sin(alpha1)],
                        [R * cos(alpha2), R * sin(alpha2)]
                    ]);
                }
            }
        }
    } else if (style == "petal2") {
        safe_petal_outline = max(4, outline);
        petal_outline = GetPetalOutline2(safe_radius, sides, safe_petal_outline, 100);
        petal_width = 2 * safe_radius * sin(180 / sides);
        scale_factor = (petal_width + safe_petal_outline) / 80;
        y_local = 40 * scale_factor;
        x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius;

        union() {
            for (i = [0 : sides - 1]) {
                theta = start + i * (360 / sides);
                alpha1 = theta - 180 / sides;
                alpha2 = theta + 180 / sides;
                R = 500;
                intersection() {
                    rotate([0, 0, theta])
                        translate([safe_radius, 0, 0])
                            difference() {
                                union() {
                                    difference() {
                                        polygon(points = petal_outline);
                                        offset(delta = -1) polygon(points = petal_outline);
                                    }
                                    difference() {
                                        offset(delta = -(safe_petal_outline - 1)) polygon(points = petal_outline);
                                        offset(delta = -safe_petal_outline) polygon(points = petal_outline);
                                    }
                                    intersection() {
                                        difference() {
                                            offset(delta = -(safe_petal_outline / 2 - 0.5)) polygon(points = petal_outline);
                                            offset(delta = -(safe_petal_outline / 2 + 0.5)) polygon(points = petal_outline);
                                        }
                                        union() {
                                            for (x = [x_local : 2.5 : 100 * scale_factor]) {
                                                translate([x, 0])
                                                    hull() {
                                                        translate([-0.25, -50 * scale_factor]) circle(r = 0.5, $fn = 16);
                                                        translate([ 0.25, -50 * scale_factor]) circle(r = 0.5, $fn = 16);
                                                        translate([-0.25,  50 * scale_factor]) circle(r = 0.5, $fn = 16);
                                                        translate([ 0.25,  50 * scale_factor]) circle(r = 0.5, $fn = 16);
                                                    }
                                            }
                                        }
                                    }
                                }
                                translate([x_local - EPSILON, -50 * scale_factor])
                                    square([safe_petal_outline + (2 * EPSILON), 100 * scale_factor]);
                            }
                    polygon(points = [
                        [0, 0],
                        [R * cos(alpha1), R * sin(alpha1)],
                        [R * cos(alpha2), R * sin(alpha2)]
                    ]);
                }
            }
        }
    } else if (style == "line1") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) square([safe_outline, 1], center = true);
            }
        }
    }
}

module GetLayerSolid2D(style, sides, radius, outline, start) {
    safe_radius = max(0.01, radius);
    safe_outline = max(0.01, outline);
    if (style == "circle") {
        rotate([0, 0, start]) circle(r = safe_radius, $fn = sides);
    } else if (style == "dot1" || style == "dot2") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) circle(r = safe_outline, $fn = 32);
            }
        }
    } else if (style == "petal1" || style == "petal2") {
        active_outline = (style == "petal2") ? max(4, outline) : safe_outline;
        petal_outline = (style == "petal2") ? 
            GetPetalOutline2(safe_radius, sides, active_outline, 100) : 
            GetPetalOutline1(safe_radius, sides, active_outline, 100);
        union() {
            for (i = [0 : sides - 1]) {
                theta = start + i * (360 / sides);
                alpha1 = theta - 180 / sides;
                alpha2 = theta + 180 / sides;
                R = 500;
                intersection() {
                    rotate([0, 0, theta])
                        translate([safe_radius, 0, 0]) polygon(points = petal_outline);
                    polygon(points = [
                        [0, 0],
                        [R * cos(alpha1), R * sin(alpha1)],
                        [R * cos(alpha2), R * sin(alpha2)]
                    ]);
                }
            }
        }
    } else if (style == "line1") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) square([safe_outline, 1], center = true);
            }
        }
    }
}

module GetFinalShape2D() {
    union() {
        for (idx = [0 : len(layers) - 1]) {
            if (layers[idx][0] != "none") {
                GetLayerSolid2D(layers[idx][0], layers[idx][1], layers[idx][2], layers[idx][3], layers[idx][4]);
            }
        }
    }
}

module GetLayerCutter2D(style, sides, radius, outline, start) {
    safe_radius = max(0.01, radius);
    safe_outline = max(0.01, outline);
    if (style == "circle") {
        difference() {
            rotate([0, 0, start]) circle(r = safe_radius, $fn = sides);
            rotate([0, 0, start]) circle(r = safe_radius - safe_outline, $fn = sides);
        }
    } else if (style == "dot1" || style == "dot2") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) circle(r = safe_outline, $fn = 32);
            }
        }
    } else if (style == "petal1") {
        petal_outline = GetPetalOutline1(safe_radius, sides, safe_outline, 100);
        petal_width = 2 * safe_radius * sin(180 / sides);
        scale_factor = (petal_width + safe_outline) / 80;
        y_local = 40 * scale_factor;
        x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius;

        union() {
            for (i = [0 : sides - 1]) {
                theta = start + i * (360 / sides);
                alpha1 = theta - 180 / sides;
                alpha2 = theta + 180 / sides;
                R = 500;
                intersection() {
                    rotate([0, 0, theta])
                        translate([safe_radius, 0, 0])
                            difference() {
                                difference() {
                                    polygon(points = petal_outline);
                                    offset(delta = -safe_outline) polygon(points = petal_outline);
                                }
                                translate([x_local - EPSILON, -50 * scale_factor])
                                    square([safe_outline + (2 * EPSILON), 100 * scale_factor]);
                            }
                    polygon(points = [
                        [0, 0],
                        [R * cos(alpha1), R * sin(alpha1)],
                        [R * cos(alpha2), R * sin(alpha2)]
                    ]);
                }
            }
        }
    } else if (style == "petal2") {
        safe_petal_outline = max(3, outline);
        petal_outline = GetPetalOutline2(safe_radius, sides, safe_petal_outline, 100);
        petal_width = 2 * safe_radius * sin(180 / sides);
        scale_factor = (petal_width + safe_petal_outline) / 80;
        y_local = 40 * scale_factor;
        x_local = sqrt(max(0, safe_radius * safe_radius - y_local * y_local)) - safe_radius;

        union() {
            for (i = [0 : sides - 1]) {
                theta = start + i * (360 / sides);
                alpha1 = theta - 180 / sides;
                alpha2 = theta + 180 / sides;
                R = 500;
                intersection() {
                    rotate([0, 0, theta])
                        translate([safe_radius, 0, 0])
                            difference() {
                                difference() {
                                    polygon(points = petal_outline);
                                    offset(delta = -safe_petal_outline) polygon(points = petal_outline);
                                }
                                translate([x_local - EPSILON, -50 * scale_factor])
                                    square([safe_petal_outline + (2 * EPSILON), 100 * scale_factor]);
                            }
                    polygon(points = [
                        [0, 0],
                        [R * cos(alpha1), R * sin(alpha1)],
                        [R * cos(alpha2), R * sin(alpha2)]
                    ]);
                }
            }
        }
    } else if (style == "line1") {
        union() {
            for (i = [0 : sides - 1]) {
                rotate([0, 0, start + i * (360 / sides)])
                    translate([safe_radius, 0, 0]) square([safe_outline, 1], center = true);
            }
        }
    }
}

module GetLayerFinal2D(idx) {
    if (layers[idx][0] != "none") {
        difference() {
            GetLayer2D(idx, layers[idx][0], layers[idx][1], layers[idx][2], layers[idx][3], layers[idx][4]);
            union() {
                for (higher_idx = [idx + 1 : len(layers) - 1]) {
                    if (layers[higher_idx][5] == true || layers[higher_idx][0] == "petal2") {
                        GetLayerCutter2D(layers[higher_idx][0], layers[higher_idx][1], layers[higher_idx][2], layers[higher_idx][3], layers[higher_idx][4]);
                    }
                }
            }
        }
    }
}

layers = [
    [layer_1_style, layer_1_sides, layer_1_radius, layer_1_outline, layer_1_start, layer_1_cut_below],
    [layer_2_style, layer_2_sides, layer_2_radius, layer_2_outline, layer_2_start, layer_2_cut_below],
    [layer_3_style, layer_3_sides, layer_3_radius, layer_3_outline, layer_3_start, layer_3_cut_below],
    [layer_4_style, layer_4_sides, layer_4_radius, layer_4_outline, layer_4_start, layer_4_cut_below],
    [layer_5_style, layer_5_sides, layer_5_radius, layer_5_outline, layer_5_start, layer_5_cut_below],
    [layer_6_style, layer_6_sides, layer_6_radius, layer_6_outline, layer_6_start, layer_6_cut_below],
    [layer_7_style, layer_7_sides, layer_7_radius, layer_7_outline, layer_7_start, layer_7_cut_below],
    [layer_8_style, layer_8_sides, layer_8_radius, layer_8_outline, layer_8_start, layer_8_cut_below],
    [layer_9_style, layer_9_sides, layer_9_radius, layer_9_outline, layer_9_start, layer_9_cut_below],
    [layer_10_style, layer_10_sides, layer_10_radius, layer_10_outline, layer_10_start, layer_10_cut_below],
    [layer_11_style, layer_11_sides, layer_11_radius, layer_11_outline, layer_11_start, layer_11_cut_below],
    [layer_12_style, layer_12_sides, layer_12_radius, layer_12_outline, layer_12_start, layer_12_cut_below],
    [layer_13_style, layer_13_sides, layer_13_radius, layer_13_outline, layer_13_start, layer_13_cut_below],
    [layer_14_style, layer_14_sides, layer_14_radius, layer_14_outline, layer_14_start, layer_14_cut_below],
    [layer_15_style, layer_15_sides, layer_15_radius, layer_15_outline, layer_15_start, layer_15_cut_below],
    [layer_16_style, layer_16_sides, layer_16_radius, layer_16_outline, layer_16_start, layer_16_cut_below],
    [layer_17_style, layer_17_sides, layer_17_radius, layer_17_outline, layer_17_start, layer_17_cut_below],
    [layer_18_style, layer_18_sides, layer_18_radius, layer_18_outline, layer_18_start, layer_18_cut_below],
    [layer_19_style, layer_19_sides, layer_19_radius, layer_19_outline, layer_19_start, layer_19_cut_below],
    [layer_20_style, layer_20_sides, layer_20_radius, layer_20_outline, layer_20_start, layer_20_cut_below]
];

if (image && $preview) {
    if (image_type == "png") color(image_color) scale([1, 1, 0.1])
        surface(file = image, center = true, invert = true);
    if (image_type == "svg") translate([0,0,-image_height-EPSILON]) color(image_color) linear_extrude(height = image_height)
        resize([image_scale_x,0], auto=true) import(image, center = true, convexity = 2);
}
if (base_height > 0) {
    color("white", alpha = transparency) {
        linear_extrude(height = base_height) {
            if (cutout_mode) {
                difference() {
                    GetFinalShape2D();
                    union() {
                        for (idx = [0 : len(layers) - 1]) {
                            GetLayerFinal2D(idx);
                        }
                    }
                }
            } else {
                GetFinalShape2D();
            }
        }
    }
}

if (!cutout_mode) {
    translate([0, 0, base_height]) {
        for (idx = [0 : len(layers) - 1]) {
            color(($preview) ? layer_colors[idx % len(layer_colors)] : "black") {
                linear_extrude(height = thickness) {
                    GetLayerFinal2D(idx);
                }
            }
        }
    }
}
