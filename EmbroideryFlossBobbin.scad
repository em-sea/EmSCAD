/*
Script Name: EmSCAD Embroidery Floss Bobbin
Description: Parametric card bobbin to wrap embroidry floss
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
*/

/* [all sizes in mm] */
core_width  = 25;
core_length = 24;
thickness   = 0.8;
thread      = 0.6;
thread_slit = 8;
flange_size = 7.5;

/* [Hidden] */
$fn = 64;
EPSILON     = 0.2;

hole = flange_size * 0.7;

linear_extrude(height = thickness) {
    difference() {
        union() {
            square([core_width, core_length]);
            for (y = [0, core_length]) {
                hull() {
                    translate([-flange_size / 2, y + (y == 0 ? -flange_size/2 + EPSILON : flange_size/2 - EPSILON)]) 
                        circle(d = flange_size);
                    translate([core_width + flange_size / 2, y + (y == 0 ? -flange_size/2 + EPSILON : flange_size/2 - EPSILON)]) 
                        circle(d = flange_size);
                }
            }
        }
        translate([core_width / 2, core_length + hole / 2]) 
            circle(d = hole);

translate([flange_size / 2, -flange_size - EPSILON]) 
    rotate([0, 0, -30]) 
    square([thread, thread_slit]);

translate([core_width, 0]) 
    mirror([1, 0, 0]) 
    translate([flange_size / 2, -flange_size - EPSILON]) 
    rotate([0, 0, -30]) 
    square([thread, thread_slit]);
    }
}
