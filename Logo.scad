/*
Script Name: EmSCAD-Logo
Description: Generate the em-sea logo at scale.
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
*/

/* [Logo Size in mm] */
width = 25; // 0.1
height = 0.2; // 0.1

/* [Hidden] */
$fn = 60;
EPSILON = 0.02;

length = width;

module EMCLogo(w, l, h) {
    linear_extrude(height = h) {
        scale([w / 300, l / 300]) {
            polygon([[0, 300], [0, 193], [10, 186], [10, 290], [290, 290], [290, 240], [300, 240], [300, 300]]);
            polygon([[113, 226], [285, 190], [285, 110], [113, 74], [113, 115], [275, 115], [275, 185], [113, 185]]);
            polygon([[0, 0], [0, 107], [10, 114], [10, 10], [290, 10], [290, 60], [300, 60], [300, 0]]);
        }
    }
}

// Do The Thing
EMCLogo(width, length, height);
