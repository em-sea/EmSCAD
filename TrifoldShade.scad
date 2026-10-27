/*
Script Name: EmSCAD Trifold Shade
Description: Parametric shade for phones and tablets
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
Glossary:
    Panel: One of three main shade parts
    Tab: Bottom panel portion to fold under the phone
    Connector: Smaller tab at the bottom of a tab to insert into a connector slot
    Connector slot: Narrow hole in the center tab that holds a connector
    Hinge: Indentations between the panels and tabs to enable folding
    Frame: Solid margin kept around connectors and slots
    ps_: Prefix for Popsocket cutout variables
*/

/* [General Dimensions (sizes in mm and %)] */
// Total width and length of the shade with tabs
max_size = 220; // [100:1:400]
center_panel_width = 84; // [50:1:200]
left_panel_percent = 75; // [0:1:100]
// Length of the center tab (0 uses the center panel width)
center_tab_length = 0; // [0:1:200]

/* [Popsocket Cutout (mm)] */
// Distance from the fold line to the center of the cutout
ps_top_distance = 84; // [0:1:200]
// Cutout radius (0 disables)
ps_radius = 0; // [0:1:30]
ps_slot_width = 10; // [1:1:30]

/* [Aesthetics & Tolerances (mm or %)] */
connector_width = 15; // [1:1:50]
connector_percent = 40; // [0:1:100]
// Distance of each connector slot from the center tab's side edge (percent of center panel width)
connector_slot_distance = 30; // [0:1:100]
connector_frame = 20; // [1:1:50]
corner_radius = 5; // [1:1:20]
connector_slot_clearance = 0.2; // [0:0.05:1]

/* [Printing Variables] */
// Extrusion line width of nozzle, hinges are 2x
extrusion_width = 0.4; // [0.2:0.01:1.2]
shade_thickness = 0.6; // [0.2:0.1:3]
// First layer height (mm)
first_height = 0.2; // [0.1:0.05:0.6]
// Height of each layer after the first (mm)
layer_height = 0.2; // [0.05:0.05:0.6]
// Layers left under each hinge, counting the first layer
hinge_layers = 1; // [1:1:5]

/* [Hidden] */
$fn = $preview ? 32 : 64;
EPSILON = 0.02;

// Calculated Variables
hinge_width = extrusion_width * 2;
left_panel_width = (max_size - center_panel_width) * left_panel_percent / 100;
right_panel_width = max_size - center_panel_width - left_panel_width;
middle_tab_length = center_tab_length > 0 ? center_tab_length : center_panel_width;
connector_slot_w = shade_thickness * 2;
connector_slot_l = connector_width + shade_thickness;
connector_slot_h = shade_thickness * 2 + (EPSILON * 2);
connector_l = center_panel_width * connector_percent / 100;
longest_tab = max(middle_tab_length, connector_l);
shade_length = max_size - longest_tab;
frame_size = center_panel_width * connector_frame / 100;
slot_x_offset = center_panel_width * connector_slot_distance / 100;
cut_height = shade_thickness + 2 * EPSILON;
top_cut_z = first_height + ((hinge_layers - 1) * layer_height);
large_connector_slot_w = connector_slot_w + (2 * connector_slot_clearance);
large_connector_slot_l = connector_slot_l + (2 * connector_slot_clearance);
right_panel_start_x = left_panel_width + center_panel_width;
lowest_connector = (ps_radius > 0) ? ps_top_distance - ps_radius + frame_size : middle_tab_length;
right_panel_connector_end = right_panel_start_x + min(right_panel_width, lowest_connector) - frame_size;
right_panel_connector_start = max(right_panel_connector_end - connector_width, right_panel_start_x);
left_panel_connector_start = max(left_panel_width - min(left_panel_width, lowest_connector) + frame_size, frame_size);
left_panel_connector_end = min(left_panel_width, left_panel_connector_start + connector_width);

module LeftPanel() {
    difference() {
        union() {
            CubeWithTab(left_panel_width, shade_length, frame_size, corner_radius, "purple", round_top_left = true);
            if (left_panel_connector_end < left_panel_width) {
                translate([left_panel_connector_start, 0, 0])
                    CubeWithTab(connector_width, 0, connector_l, corner_radius, "red", inset = EPSILON);
            }
        }
        if (left_panel_connector_end + connector_width + connector_slot_w < left_panel_width) {
            ConnectorSlot(left_panel_connector_end);
        }
    }
}

module RightPanel() {
    difference() {
        union() {
            translate([right_panel_start_x, 0, 0])
                CubeWithTab(right_panel_width, shade_length, frame_size, corner_radius, "yellow", round_top_right = true);
            if (right_panel_connector_start < right_panel_connector_end) {
                translate([right_panel_connector_start, 0, 0])
                    CubeWithTab(connector_width, 0, connector_l, corner_radius, "orange", inset = EPSILON);
            }
        }
        if (right_panel_start_x + frame_size < right_panel_connector_start) {
            ConnectorSlot(right_panel_connector_start - connector_slot_w);
        }
    }
}

module CenterPanel() {
    translate([left_panel_width, 0, 0]) {
        difference() {
            CubeWithTab(center_panel_width, shade_length, middle_tab_length, corner_radius, "lightseagreen");
            if (ps_radius > 0) {
                PopsocketCutout();
            }
            if (left_panel_connector_end < left_panel_width) {
                CenterConnectorSlot(slot_x_offset, -left_panel_width + left_panel_connector_end - large_connector_slot_l);
            }
            if (right_panel_connector_start < right_panel_connector_end) {
                CenterConnectorSlot(center_panel_width - slot_x_offset, -right_panel_connector_start + right_panel_start_x - large_connector_slot_l);
            }
        }
    }
}

module PopsocketCutout() {
    translate([center_panel_width / 2, -ps_top_distance, -EPSILON]) {
        cylinder(r = ps_radius, h = cut_height);
        translate([-(ps_slot_width / 2), -max_size, 0])
            cube([ps_slot_width, max_size, cut_height]);
    }
}

module ConnectorSlot(x) {
    translate([x, -connector_l - EPSILON, -EPSILON])
        cube([connector_slot_w, connector_l + EPSILON, cut_height]);
}

module CenterConnectorSlot(x, y) {
    translate([x, y, -EPSILON])
        cube([large_connector_slot_w, large_connector_slot_l, connector_slot_h]);
}

module ApplyHingeCuts() {
    ApplyHingeSlits();
    ApplyTabSeparationCuts();
}

module ApplyHingeSlits() {
    HingeSlit(0, -hinge_width / 2, max_size, hinge_width);
    HingeSlit(left_panel_width - hinge_width / 2, 0, hinge_width, max_size);
    HingeSlit(right_panel_start_x - hinge_width / 2, 0, hinge_width, max_size);
}

module ApplyTabSeparationCuts() {
    TabSeparationCut(left_panel_width - hinge_width / 2);
    TabSeparationCut(right_panel_start_x - hinge_width / 2);
}

module HingeSlit(x, y, w, l) {
    translate([x, y - EPSILON, top_cut_z])
        cube([w, l + (2 * EPSILON), shade_thickness + EPSILON]);
}

module TabSeparationCut(x) {
    translate([x, -max_size, -EPSILON])
        cube([hinge_width, max_size + EPSILON, cut_height]);
}

module CubeWithTab(w, l, tab_l, r, c, round_top_left = false, round_top_right = false, inset = 0) {
    color(c) translate([0, 0, inset])
        linear_extrude(height = shade_thickness - inset * 2) {
            PanelBody(w, l, r, round_top_left, round_top_right);
            PanelTab(w, tab_l, r);
        }
}

module PanelBody(w, l, r, round_top_left, round_top_right) {
    if (l > 0) {
        safe_body_r = max(0.01, min(r, w / 2, l / 2));
        hull() {
            square([w, EPSILON]);
            if (round_top_left) {
                translate([safe_body_r, l - safe_body_r]) circle(r = safe_body_r);
            } else {
                translate([0, l - EPSILON]) square([EPSILON, EPSILON]);
            }
            if (round_top_right) {
                translate([w - safe_body_r, l - safe_body_r]) circle(r = safe_body_r);
            } else {
                translate([w - EPSILON, l - EPSILON]) square([EPSILON, EPSILON]);
            }
        }
    }
}

module PanelTab(w, tab_l, r) {
    if (tab_l > 0) {
        safe_tab_r = max(0.01, min(r, w / 2, tab_l / 2));
        hull() {
            translate([0, -EPSILON]) square([w, EPSILON]);
            translate([safe_tab_r, -tab_l + safe_tab_r]) circle(r = safe_tab_r);
            translate([w - safe_tab_r, -tab_l + safe_tab_r]) circle(r = safe_tab_r);
        }
    }
}

difference() {
    union() {
        LeftPanel();
        CenterPanel();
        RightPanel();
    }
    ApplyHingeCuts();
}
