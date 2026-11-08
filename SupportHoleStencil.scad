// Script Name: EmSCAD Support Hole Stencil
// Description: Generates a parametric mounting (or painting) stencil with size options for holes, distance, padding, and height.
// Repository: https://github.com/em-sea/EmSCAD/
// Copyright (C) 2026 em-sea
// SPDX-License-Identifier: GPL-3.0-or-later

/* [Options in mm] */
hole_diameter = 8; // [0.1: 0.1:50]
distance_x = 73; // [0.1: 0.1:200]
// Set to 0 if creating 1 row
distance_y = 34; // [0: 0.1:200]
stencil_padding = 2; // [-50: 0.1:50]
stencil_thickness = 0.4; // [0.1: 0.1:50]

$fn = 120;

hole_radius = hole_diameter / 2;

module GenerateOneCutout(start_x = 0, start_y = 0) {
    translate([start_x + hole_radius, start_y + hole_radius]) 
        circle(r = hole_radius);
}

module GenerateAllCutouts() {
    GenerateOneCutout(0, 0);
    GenerateOneCutout(distance_x, 0);
    GenerateOneCutout(distance_x, distance_y);
    GenerateOneCutout(0, distance_y);
}

module GenerateStencil() {
    linear_extrude(h = stencil_thickness)
        difference() {
            offset(r = stencil_padding) hull() 
                GenerateAllCutouts();
            GenerateAllCutouts();
        }
}

GenerateStencil();
