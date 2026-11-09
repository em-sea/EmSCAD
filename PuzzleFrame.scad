/*
Script Name: EmSCAD Puzzle Frame
Description: Generates parametric small to extra large puzzle frame segments and corners with optional dovetails, pins, and corner supports.
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
*/

/* [Render Options] */
render_segment = true;
render_corner = true;

/* [Frame Dimensions in mm] */
use_dovetail = true;
frame_profile_type = "curved"; // ["blocks", "beveled", "curved", "stepped"]
segment_length = 10; // 0.1
// Forced to be at least back frame height + dovetail length
corner_length = 0; // 0.1
puzzle_thickness = 1.2; // 0.1
front_frame_height = 10; // 0.1
back_frame_height = 10; // 0.1
frame_thickness = 10; // 0.1
puzzle_inset_height = 3; // 0.1
puzzle_inset_depth = 2; // 0.1
frame_segment_clearance = 0.08; // 0.01

/* [Corner Support] */
corner_support = true;
// Setback for the corner support to allow ties between corners
corner_support_inset = 0.2; // 0.1
corner_support_cutout = 2; // 0.1
corner_support_sides = 6; // [3:1:180]

/* [Pin Options] */
use_pin = true;
pin_punchthrough = true;
// Filament is ~1.75 mm
pin_width = 1.75; // 0.01
pin_sides = 6; // [3:1:120]
pin_head_width = 3;  // 0.01
pin_head_sides = 6; // [3:1:120]
pin_head_inset = 1; // 0.01
pin_clearance = 0.12; // 0.01

/* [Hidden] */
$fn = ($preview) ? 32 : 128;
EPSILON = 0.02;

pin_hole_radius = (pin_width / 2) / cos(180 / pin_sides);
pin_head_hole_radius = (pin_head_width / 2) / cos(180 / pin_head_sides);

frame_core_height = max((use_pin) ? (max(pin_hole_radius * 3, pin_head_hole_radius * 2) + pin_clearance + frame_segment_clearance) * 2 : 0, front_frame_height - puzzle_inset_height - frame_segment_clearance);
frame_core_y_inset = puzzle_inset_depth + puzzle_thickness + frame_segment_clearance;
frame_core_depth = max(0.01, frame_thickness - frame_core_y_inset);

dovetail_width = frame_core_depth * 0.6;
dovetail_neck = frame_core_depth * 0.4;

connector_length = use_dovetail ? max(frame_core_depth * 0.4, (use_pin) ? (max(pin_hole_radius, pin_head_hole_radius) * 2 + pin_clearance + frame_segment_clearance) * 2 : 0) : 0;

corner_arm_length = max(corner_length - back_frame_height, use_dovetail ? (connector_length + frame_segment_clearance) : 0, (corner_support) ? corner_support_cutout * 3 : 0);

module FrameProfile(height_clearance = 0) {
    base_points = [
        [0, 0],
        [frame_thickness, 0],
        [frame_thickness, back_frame_height + height_clearance],
        [puzzle_inset_depth + puzzle_thickness + frame_segment_clearance, back_frame_height + height_clearance],
        [puzzle_inset_depth + puzzle_thickness + frame_segment_clearance, frame_core_height],
        [puzzle_inset_depth, frame_core_height],
        [puzzle_inset_depth, front_frame_height]
    ];

    if (frame_profile_type == "blocks") {
        polygon(concat(base_points, [[0, front_frame_height]]));
    } else if (frame_profile_type == "curved") {
        fn_profile = max(8, $fn);
        front_arc_points = [
            for (i = [fn_profile : -1 : 0])
                [
                    puzzle_inset_depth * (1 - cos((i / fn_profile) * 90)),
                    front_frame_height * sin((i / fn_profile) * 90)
                ]
        ];
        polygon(concat(base_points, front_arc_points));
    } else if (frame_profile_type == "beveled") {
        polygon(concat(base_points, [
            [0, front_frame_height * 0.6],
            [0, 0]
        ]));
    } else if (frame_profile_type == "stepped") {
        polygon(concat(base_points, [
            [puzzle_inset_depth * 0.5, front_frame_height],
            [puzzle_inset_depth * 0.5, front_frame_height * 0.6],
            [0, front_frame_height * 0.6],
            [0, 0]
        ]));
    }
}

module DovetailTab3D(outer_width, neck_width, length, start_z = 0, height = back_frame_height) {
    translate([0, frame_core_y_inset + frame_core_depth / 2, start_z])
        linear_extrude(height = height)
            polygon([
                [0, -neck_width / 2],
                [-length, -outer_width / 2],
                [-length, outer_width / 2],
                [0, neck_width / 2]
            ]);
}

// Lock in Y, add frame_segment_clearance to inner X
module FilamentPinCutout(clearance_value = frame_segment_clearance) {
    pin_depth = pin_punchthrough ? (frame_thickness + EPSILON * 2) : (frame_thickness - (puzzle_inset_depth / 2) + EPSILON);
    pin_start_y = pin_punchthrough ? -EPSILON : puzzle_inset_depth / 2;

    hull() {
        translate([-connector_length / 2, pin_start_y, frame_core_height / 2])
            rotate([-90, 0, 0])
                cylinder(h = pin_depth, d = pin_hole_radius * 2 + pin_clearance, $fn = pin_sides);

        if (clearance_value) {
            translate([-connector_length / 2 + clearance_value, pin_start_y, frame_core_height / 2])
                rotate([-90, 0, 0])
                    cylinder(h = pin_depth, d = pin_hole_radius * 2 + pin_clearance, $fn = pin_sides);
        }
    }
    translate([-connector_length / 2, frame_thickness - pin_head_inset, frame_core_height / 2])
        rotate([-90, 0, 0])
            cylinder(h = pin_head_inset + EPSILON, d = pin_head_width + pin_clearance, $fn = pin_head_sides);
}

module StraightSegment(length, has_start_dovetail = true, has_end_dovetail = true, height_clearance = 0) {
    real_start_conn = use_dovetail && has_start_dovetail;
    real_end_conn = use_dovetail && has_end_dovetail;

    difference() {
        rotate([90, 0, 90])
            linear_extrude(height = length)
                FrameProfile(height_clearance = height_clearance); 

        if (real_end_conn) {
            translate([length + EPSILON, 0, 0]) {
                DovetailTab3D(
                    dovetail_width + frame_segment_clearance, 
                    dovetail_neck + frame_segment_clearance, 
                    connector_length + frame_segment_clearance, 
                    start_z = -frame_segment_clearance, 
                    height = back_frame_height + frame_segment_clearance * 2
                );
                if (use_pin) {
                    FilamentPinCutout(clearance_value = 0);
                }
            }
        }
    }

    if (real_start_conn) {
        difference() {
            DovetailTab3D(dovetail_width, dovetail_neck, connector_length);
            if (use_pin) {
                FilamentPinCutout();
            }
        }
    }
}

module CornerSegment() {
    if (corner_support) {
        cutout_distance = max(0, corner_arm_length / 4);
        difference() {
            translate([0, frame_core_y_inset + frame_core_depth, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = frame_core_depth)
                        polygon([
                            [back_frame_height, back_frame_height + frame_segment_clearance],
                            [back_frame_height + corner_arm_length, back_frame_height + frame_segment_clearance],
                            [back_frame_height, back_frame_height + corner_arm_length]
                        ]);
            translate([back_frame_height + cutout_distance, frame_core_y_inset - EPSILON, back_frame_height + cutout_distance]) {
                rotate([-90, 0, 0])
                    cylinder(h = frame_thickness + EPSILON * 2, d = corner_support_cutout, $fn = corner_support_sides);
                cube([corner_arm_length, corner_support_inset, corner_arm_length]);
            }
        }
    }
    StraightSegment(
        corner_arm_length + back_frame_height, 
        has_start_dovetail = false, 
        has_end_dovetail = true,
        height_clearance = frame_segment_clearance
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
    translate([back_frame_height + corner_arm_length + max(dovetail_width, frame_thickness) + 5, 0, 0])
        color("DodgerBlue", alpha = (render_segment == false) ? 0.3 : 1)
            StraightSegment(segment_length, has_start_dovetail = true, has_end_dovetail = true);
}

if (render_corner || $preview) {
    color("DeepPink", alpha = (render_corner == false) ? 0.3 : 1)
        CornerSegment();
}
