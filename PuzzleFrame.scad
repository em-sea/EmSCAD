/*
 * Script Name: EmSCAD Puzzle Frame
 * Description: Generates interlocking frame segments and corners with dovetail joints and cylindrical filament lock pins for small to extra large puzzles or rigid pictures.
 * Repository: https://github.com/em-sea/EmSCAD/
 * Copyright (C) 2026 em-sea
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

/* [Render Options] */
render_segment = true;
render_corner = true;

/* [Frame Dimensions in mm] */
segment_length = 20;
// forced to be at least back frame height + dovetail length
corner_length = 0;
puzzle_thickness = 1.6;
front_frame_height = 8;
back_frame_height = 12;
frame_thickness = 10;
puzzle_inset_height = 3;
puzzle_inset_depth = 2;

/* [Frame Options] */
frame_profile_type = "curved"; // ["blocks", "beveled", "curved", "stepped"]
corner_support = true;
// setback for the corner support to allow ties between corners
corner_support_inset = 0.2;
use_filament_pin = true;

/* [Tuning] */
clearance = 0.15;
filament_size = 1.75;
filament_clearance = 0.3;

/* [Hidden] */
$fn = ($preview) ? 32 : 128;
EPSILON = 0.02;

frame_core_height = max((use_filament_pin) ? (filament_size + filament_clearance + clearance) * 2 : 0, front_frame_height - puzzle_inset_height - clearance);
frame_core_y_inset = puzzle_inset_depth + puzzle_thickness + clearance;
frame_core_depth = max(0.1, frame_thickness - frame_core_y_inset);

dovetail_width = frame_core_depth * 0.6;
dovetail_neck = frame_core_depth * 0.4;
dovetail_length = max(frame_core_depth * 0.4, (use_filament_pin) ? (filament_size + filament_clearance + clearance) * 2 : 0);

corner_arm_length = max(corner_length - back_frame_height, dovetail_length + clearance);

module FrameProfile(height_clearance = 0) {
    if (frame_profile_type == "blocks") {
        polygon([
            [0, 0],
            [frame_thickness, 0],
            [frame_thickness, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, frame_core_height],
            [puzzle_inset_depth, frame_core_height],
            [puzzle_inset_depth, front_frame_height],
            [0, front_frame_height]
        ]);
    } else if (frame_profile_type == "curved") {
        $fn_profile = max(8, $fn);
        
        front_arc_points = [
            for (i = [$fn_profile : -1 : 0])
                [
                    puzzle_inset_depth * (1 - cos((i / $fn_profile) * 90)),
                    front_frame_height * sin((i / $fn_profile) * 90)
                ]
        ];

        polygon(concat(
            [
                [0, 0],
                [frame_thickness, 0],
                [frame_thickness, back_frame_height + height_clearance],
                [puzzle_inset_depth + puzzle_thickness + clearance, back_frame_height + height_clearance],
                [puzzle_inset_depth + puzzle_thickness + clearance, frame_core_height],
                [puzzle_inset_depth, frame_core_height],
                [puzzle_inset_depth, front_frame_height]
            ],
            front_arc_points
        ));
    } else if (frame_profile_type == "beveled") {
        polygon([
            [0, 0],
            [frame_thickness, 0],
            [frame_thickness, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, frame_core_height],
            [puzzle_inset_depth, frame_core_height],
            [puzzle_inset_depth, front_frame_height],
            [0, front_frame_height * 0.6], // Creates an elegant angled bevel face
            [0, 0]
        ]);
    } else if (frame_profile_type == "stepped") {
        polygon([
            [0, 0],
            [frame_thickness, 0],
            [frame_thickness, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, back_frame_height + height_clearance],
            [puzzle_inset_depth + puzzle_thickness + clearance, frame_core_height],
            [puzzle_inset_depth, frame_core_height],
            [puzzle_inset_depth, front_frame_height],
            [puzzle_inset_depth * 0.5, front_frame_height],
            [puzzle_inset_depth * 0.5, front_frame_height * 0.6],
            [0, front_frame_height * 0.6],
            [0, 0]
        ]);
    }
}

module DovetailTab3D(w_outer, w_neck, length, start_z = 0, height = back_frame_height) {
    translate([0, frame_core_y_inset + frame_core_depth / 2, start_z])
        linear_extrude(height = height)
            polygon([
                [0, -w_neck / 2],
                [-length, -w_outer / 2],
                [-length, w_outer / 2],
                [0, w_neck / 2]
            ]);
}

// Lock in Y, add clearance to inner X
module FilamentPinCutout(clearance_val = clearance) {
    hull() {
        translate([-dovetail_length / 2, -EPSILON, frame_core_height / 2])
            rotate([-90, 0, 0])
                cylinder(h = frame_thickness + EPSILON * 2, d = filament_size + filament_clearance);
        if (clearance_val) 
            translate([-dovetail_length / 2 + clearance_val, -EPSILON, frame_core_height / 2])
                rotate([-90, 0, 0])
                    cylinder(h = frame_thickness + EPSILON * 2, d = filament_size + filament_clearance);
    }
}

module StraightSegment(length, has_start_dovetail = true, has_end_dovetail = true, height_clearance = 0) {
    difference() {
        union() {
            rotate([90, 0, 90])
                linear_extrude(height = length)
                    FrameProfile(height_clearance = height_clearance); 

            if (has_start_dovetail) {
                DovetailTab3D(dovetail_width, dovetail_neck, dovetail_length);
            }
        }

        if (has_start_dovetail && use_filament_pin) {
            FilamentPinCutout();
        }

        if (has_end_dovetail) {
            translate([length + EPSILON, 0, 0]) {
                DovetailTab3D(
                    dovetail_width + clearance, 
                    dovetail_neck + clearance, 
                    dovetail_length + clearance, 
                    start_z = -clearance, 
                    height = back_frame_height + clearance * 2
                );
                if (use_filament_pin) {
                    FilamentPinCutout(clearance_val = 0);
                }
            }
        }
    }
}

module CornerSegment() {
    if (corner_support) {
        difference() {
            translate([0, frame_core_y_inset + frame_core_depth, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = frame_core_depth - corner_support_inset)
                        polygon([
                            [back_frame_height, back_frame_height + clearance],
                            [back_frame_height + corner_arm_length, back_frame_height + clearance],
                            [back_frame_height, back_frame_height + corner_arm_length]
                        ]);
            translate([back_frame_height + (filament_size + filament_clearance) / 2, -EPSILON, back_frame_height + (filament_size + filament_clearance) / 2 + clearance])
                rotate([-90, 0, 0])
                    cylinder(h = frame_thickness + EPSILON * 2, d = filament_size + filament_clearance);
        }
    }
    StraightSegment(
        corner_arm_length + back_frame_height, 
        has_start_dovetail = false, 
        has_end_dovetail = true,
        height_clearance = clearance
    );
    translate([0, 0, back_frame_height + corner_arm_length])
        rotate([0, 90, 0])
            StraightSegment(
                back_frame_height + corner_arm_length, 
                has_start_dovetail = true, 
                has_end_dovetail = false
            );
}

// Do The Things
if (render_segment || $preview) {
    translate([back_frame_height + corner_arm_length + max(dovetail_width, frame_thickness), 0, 0])
        color("DodgerBlue", alpha = (render_segment == false) ? 0.3 : 1)
            StraightSegment(segment_length, has_start_dovetail = true, has_end_dovetail = true);
}

if (render_corner || $preview) {
    color("DeepPink", alpha = (render_corner == false) ? 0.3 : 1)
        CornerSegment();
}
