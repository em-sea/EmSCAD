/* 
Script Name: EmSCAD-Aperiodic-Monotiles
Description: Scaled parametric tiles with optional decorations, a compact connected storage tray, and/or lid.
Repository: https://github.com/em-sea/EmSCAD/
Copyright (C) 2026 em-sea
SPDX-License-Identifier: GPL-3.0-or-later
Glossary:
    Aperiodic Monotile: shape that can tile the plane endlessly with its reflected copy without repeating the pattern
        Examples: Einstein Hat, Turtle
    Chiral Aperiodic Monotile: reflected copies of the tile are not needed to form a tiling
        Example: Spectre
    Aperiodic Layout: Some shapes can be arranged either aperiodically or repeating
        Examples: Comet and Chevron
Inspiration: Math and logic from https://cs.uwaterloo.ca/~csk/hat/ and https://github.com/christianp/aperiodic-monotile/blob/main/spectre-monotile.scad
*/

/* [Render Resolution] */
fn_detail = 64;

/* [Scale: initial size is 1 and sqrt(3)] */
scale = 6;

/* [Which Shapes] */
generate_chevron = true;
generate_comet = true;
generate_hat = true;
generate_turtle = true;
generate_spectre = true;
spectre_midpoints = 10; // [1:50]

/* [Tile Options] */
tile_layers = 10;
clearance = 0.15; // 0.1
layer_height = 0.2; // 0.01

/* [Groove Options] */
outline_groove_layers = 2;
outline_groove_position = "both"; // [top, bottom, both, none]
outline_groove_width = 0.2;

polygon_groove_layers = 2;
polygon_groove_position = "bottom"; // [top, bottom, both, none]
polygon_groove_width = 0.4;

curve_groove_layers = 2;
curve_groove_position = "top"; // [top, bottom, both, none]
curve_groove_width = 0.8; // 0.1
curve_height = 0.4; // 0.1

object_groove_position = "top"; // [top, bottom, both, none]
object_groove_layers = 2;

/* [Which Storage] */
generate_chevron_storage = true;
generate_comet_storage = true;
generate_hat_storage = true;
generate_turtle_storage = true;
generate_spectre_storage = true;

/* [Storage Configuration] */
storage_wall_thickness = 1.6; // 0.1
storage_floor_thickness = 1.6; // 0.1
storage_height = 20.0; // 0.1
storage_pocket_clearance = 0.3; // 0.1
storage_enclosure = "rounded"; // [minimal, full, rounded]

/* [Lid Options] */
generate_lid = true;
lid_thickness = 1.6; // 0.1
lid_clearance = 0.2; // 0.1
lid_lip_depth = 15.0; // 0.1

/* [Hidden] */
EPSILON = 0.02;

tile_height = layer_height * tile_layers;

outline_groove_depth = layer_height * outline_groove_layers;
polygon_groove_depth = layer_height * polygon_groove_layers;
curve_groove_depth = layer_height * curve_groove_layers;
object_groove_depth = layer_height * object_groove_layers;

storage_layout_chevron = [5.1 * scale, -1.8 * scale, 150];
storage_layout_comet   = [7.1 * scale, -5.5 * scale, 120];
storage_layout_hat     = [6.1 * scale, -7.3 * scale, 0];
storage_layout_turtle  = [8.7 * scale, -1.5 * scale, 300];
storage_layout_spectre = [9.7 * scale, -4.6 * scale, 74];

CHEVRON_ALL_POINTS = scale * [
    [0, 0],
    [0, 2],
    [sqrt(3), 3],
    [2 * sqrt(3), 2],
    [2 * sqrt(3), 0],
    [sqrt(3), 1]
];
CHEVRON_SHAPE_POINTS = [for (i = [0 : 5]) CHEVRON_ALL_POINTS[i]];
CHEVRON_STORAGE_POINTS = [for (i = [1 : 5]) CHEVRON_ALL_POINTS[i]];
CHEVRON_GROOVES = [
    [CHEVRON_ALL_POINTS[1], CHEVRON_ALL_POINTS[5]],
    [CHEVRON_ALL_POINTS[2], CHEVRON_ALL_POINTS[5]],
    [CHEVRON_ALL_POINTS[3], CHEVRON_ALL_POINTS[5]]
];
CHEVRON_CURVES = [
    [30, CHEVRON_ALL_POINTS[3], CHEVRON_ALL_POINTS[5]],
    [30, CHEVRON_ALL_POINTS[5], CHEVRON_ALL_POINTS[1]],
    [30, CHEVRON_ALL_POINTS[4], CHEVRON_ALL_POINTS[2]],
    [30, CHEVRON_ALL_POINTS[2], CHEVRON_ALL_POINTS[0]],
    [30, CHEVRON_ALL_POINTS[3], CHEVRON_ALL_POINTS[1]]
];
CHEVRON_OBJECTS = [];

COMET_ALL_POINTS = [
    scale * [1, sqrt(3)],
    scale * [0, 2 * sqrt(3)],
    scale * [1, 3 * sqrt(3)],
    scale * [3, 3 * sqrt(3)],
    scale * [4, 2 * sqrt(3)],
    scale * [3, sqrt(3)],
    scale * [2, 0],
    scale * [0, 0],
    scale * [2, 2 * sqrt(3)]
];
COMET_SHAPE_POINTS = [for (i = [0 : 7]) COMET_ALL_POINTS[i]];
COMET_SHAPE_STORAGE = [for (i = [0 : 5]) COMET_ALL_POINTS[i]];
COMET_GROOVES = [
    [COMET_ALL_POINTS[1], COMET_ALL_POINTS[4]],
    [COMET_ALL_POINTS[2], COMET_ALL_POINTS[5]],
    [COMET_ALL_POINTS[3], COMET_ALL_POINTS[0]],
    [COMET_ALL_POINTS[0], COMET_ALL_POINTS[6]],
    [COMET_ALL_POINTS[5], COMET_ALL_POINTS[0]]
];
COMET_CURVES = [
    [120, COMET_ALL_POINTS[0], COMET_ALL_POINTS[1]],
    [120, COMET_ALL_POINTS[2], COMET_ALL_POINTS[3]],
    [120, COMET_ALL_POINTS[3], COMET_ALL_POINTS[4]],
    [120, COMET_ALL_POINTS[4], COMET_ALL_POINTS[5]],
    [120, COMET_ALL_POINTS[5], COMET_ALL_POINTS[0]],
    [120, COMET_ALL_POINTS[6], COMET_ALL_POINTS[7]],
    [120, COMET_ALL_POINTS[1], COMET_ALL_POINTS[2]]
];
COMET_OBJECTS = [];

HAT_ALL_POINTS = [
    scale * [0, 0],
    scale * [-3 / 2, -sqrt(3) / 2],
    scale * [-1, -sqrt(3)],
    scale * [1, -sqrt(3)],
    scale * [3 / 2, -sqrt(3) / 2],
    scale * [3, -sqrt(3)],
    scale * [9 / 2, -sqrt(3) / 2],
    scale * [4, 0],
    scale * [3, 0],
    scale * [3, sqrt(3)],
    scale * [3 / 2, 3 * sqrt(3) / 2],
    scale * [1, sqrt(3)],
    scale * [0, sqrt(3)],
    scale * [0, -sqrt(3)],
    scale * [3 / 2, sqrt(3) / 2],
    scale * [2, 0]
];
HAT_SHAPE_POINTS = [for (i = [0 : 12]) HAT_ALL_POINTS[i]];
HAT_SHAPE_STORAGE = [for (i = [3 : 13]) HAT_ALL_POINTS[i]];
HAT_GROOVES = [
    [HAT_ALL_POINTS[0], HAT_ALL_POINTS[4]],
    [HAT_ALL_POINTS[0], HAT_ALL_POINTS[9]],
    [HAT_ALL_POINTS[0], HAT_ALL_POINTS[13]],
    [HAT_ALL_POINTS[4], HAT_ALL_POINTS[15]],
    [HAT_ALL_POINTS[5], HAT_ALL_POINTS[8]],
    [HAT_ALL_POINTS[8], HAT_ALL_POINTS[15]],
    [HAT_ALL_POINTS[11], HAT_ALL_POINTS[15]]
];
HAT_CURVES = [
    [60, HAT_ALL_POINTS[13], HAT_ALL_POINTS[1]],
    [60, HAT_ALL_POINTS[4], HAT_ALL_POINTS[13]],
    [60, HAT_ALL_POINTS[8], HAT_ALL_POINTS[6]],
    [60, HAT_ALL_POINTS[4], HAT_ALL_POINTS[8]],
    [60, HAT_ALL_POINTS[12], HAT_ALL_POINTS[14]],
    [60, HAT_ALL_POINTS[14], HAT_ALL_POINTS[10]],
    [60, HAT_ALL_POINTS[14], HAT_ALL_POINTS[4]],
    [60, HAT_ALL_POINTS[8], HAT_ALL_POINTS[14]]
];
HAT_OBJECTS = [];

TURTLE_ALL_POINTS = [
    scale * [0, 0],
    scale * [1, 0],
    scale * [3 / 2, -sqrt(3) / 2],
    scale * [3, 0],
    scale * [6, -sqrt(3)],
    scale * [6, -2 * sqrt(3)],
    scale * [5, -2 * sqrt(3)],
    scale * [9 / 2, -5 * sqrt(3) / 2],
    scale * [3, -2 * sqrt(3)],
    scale * [3 / 2, -5 * sqrt(3) / 2],
    scale * [1, -2 * sqrt(3)],
    scale * [3 / 2, -3 * sqrt(3) / 2],
    scale * [0, -sqrt(3)],
    scale * [9 / 2, -sqrt(3) / 2],
    scale * [9 / 2, -3 * sqrt(3) / 2],
    scale * [4, -sqrt(3)],
    scale * [2, -sqrt(3)],
    scale * [3, -sqrt(3)]
];
TURTLE_SHAPE_POINTS = [for (i = [0 : 12]) TURTLE_ALL_POINTS[i]];
TURTLE_SHAPE_STORAGE = [for (i = [2 : 12]) TURTLE_ALL_POINTS[i]];
TURTLE_GROOVES = [
    [TURTLE_ALL_POINTS[2], TURTLE_ALL_POINTS[16]],
    [TURTLE_ALL_POINTS[2], TURTLE_ALL_POINTS[12]],
    [TURTLE_ALL_POINTS[13], TURTLE_ALL_POINTS[15]],
    [TURTLE_ALL_POINTS[6], TURTLE_ALL_POINTS[15]],
    [TURTLE_ALL_POINTS[8], TURTLE_ALL_POINTS[11]],
    [TURTLE_ALL_POINTS[11], TURTLE_ALL_POINTS[16]],
    [TURTLE_ALL_POINTS[3], TURTLE_ALL_POINTS[8]],
    [TURTLE_ALL_POINTS[4], TURTLE_ALL_POINTS[8]],
    [TURTLE_ALL_POINTS[15], TURTLE_ALL_POINTS[16]]
];
TURTLE_CURVES = [
    [60, TURTLE_ALL_POINTS[2], TURTLE_ALL_POINTS[0], TURTLE_ALL_POINTS[12]],
    [60, TURTLE_ALL_POINTS[11], TURTLE_ALL_POINTS[2], TURTLE_ALL_POINTS[12]],
    [60, TURTLE_ALL_POINTS[2], TURTLE_ALL_POINTS[17], TURTLE_ALL_POINTS[3]],
    [60, TURTLE_ALL_POINTS[17], TURTLE_ALL_POINTS[13], TURTLE_ALL_POINTS[3]],
    [60, TURTLE_ALL_POINTS[13], TURTLE_ALL_POINTS[14], TURTLE_ALL_POINTS[4]],
    [60, TURTLE_ALL_POINTS[14], TURTLE_ALL_POINTS[5], TURTLE_ALL_POINTS[4]],
    [60, TURTLE_ALL_POINTS[11], TURTLE_ALL_POINTS[9], TURTLE_ALL_POINTS[8]],
    [60, TURTLE_ALL_POINTS[17], TURTLE_ALL_POINTS[11], TURTLE_ALL_POINTS[8]],
    [60, TURTLE_ALL_POINTS[14], TURTLE_ALL_POINTS[17], TURTLE_ALL_POINTS[8]],
    [60, TURTLE_ALL_POINTS[7], TURTLE_ALL_POINTS[14], TURTLE_ALL_POINTS[8]]
];
TURTLE_OBJECTS = [
    [TURTLE_ALL_POINTS[12], 6, 30, 0.25 * scale, 0.2 * scale],
    [TURTLE_ALL_POINTS[8], 6, 30, 0.25 * scale, 0.2 * scale],
    [TURTLE_ALL_POINTS[4], 6, 30, 0.25 * scale, 0.2 * scale],
    [TURTLE_ALL_POINTS[3], 6, 30, 0.25 * scale, 0.2 * scale]
];

SPECTRE_MOVES = [
    [0, 0],
    [1 / 2, sqrt(3) / 2],
    [1, 0],
    [0, 1],
    [sqrt(3) / 2, 1 / 2],
    [1 / 2, -sqrt(3) / 2],
    [-1 / 2, -sqrt(3) / 2],
    [sqrt(3) / 2, -1 / 2],
    [0, -1],
    [0, -1],
    [-sqrt(3) / 2, -1 / 2],
    [-1 / 2, sqrt(3) / 2],
    [-1, 0],
    [0, 1],
    [-sqrt(3) / 2, 1 / 2]
];

SPECTRE_LABELS = 1.5 * scale * [
    [0, 0],
    [0.5, sqrt(3)/2],
    [1.5, sqrt(3)/2],
    [1.5, 1 + sqrt(3)/2],
    [1.5 + sqrt(3)/2, 1.5 + sqrt(3)/2],
    [2 + sqrt(3)/2, 1.5],
    [1.5 + sqrt(3)/2, 1.5 - sqrt(3)/2],
    [1.5 + sqrt(3), 1 - sqrt(3)/2],
    [1.5 + sqrt(3), -sqrt(3)/2],
    [1.5 + sqrt(3), -(1 + sqrt(3)/2)],
    [1.5 + sqrt(3)/2, -(1.5 + sqrt(3)/2)],
    [1 + sqrt(3)/2, -1.5],
    [sqrt(3)/2, -1.5],
    [sqrt(3)/2, -0.5],
    [4/3, -1],
    [1.75+sqrt(3)/4, 1.25+sqrt(3)/4],
    [1, 0+sqrt(2)],
    [1.75+3*sqrt(3)/4, 1.25-sqrt(3)/4],
    [1.25+3*sqrt(3)/4, -1.25-sqrt(3)/4],
    [0.25+sqrt(3)/4, sqrt(3)/4-.25],
    [1+sqrt(3)/2, 0.5]
];

function GetCurvedPoints(moves, steps) = let(
    points = [for (i = 0, p = moves[0]; i < len(moves) - 1; i = i + 1, p = p + moves[i]) p],
    curve_amount = 0.1
) [
    for (i = [0 : len(points) - 1])
        let(
            a_pt = points[i],
            b_pt = points[(i + 1) % len(points)],
            d = b_pt - a_pt,
            n = [d[1], -d[0]] / norm(d)
        )
        for (j = [0 : steps - 1])
            let(t = j / steps)
            (t * b_pt + (1 - t) * a_pt + n * sin(-360 * t) * curve_amount) * scale
];

SPECTRE_SHAPE_POINTS = 1.5 * GetCurvedPoints(SPECTRE_MOVES, spectre_midpoints);
SPECTRE_SHAPE_STORAGE = [for (i = [2 * spectre_midpoints : 13 * spectre_midpoints]) SPECTRE_SHAPE_POINTS[i]];
SPECTRE_GROOVES = [];
SPECTRE_CURVES = [
    [30, SPECTRE_LABELS[4], SPECTRE_LABELS[15]],
    [30, SPECTRE_LABELS[12], SPECTRE_LABELS[14]],
    [30, SPECTRE_LABELS[0], SPECTRE_LABELS[19]],
    [30, SPECTRE_LABELS[10], SPECTRE_LABELS[18]],
    [30, SPECTRE_LABELS[20], SPECTRE_LABELS[2]],
    [30, SPECTRE_LABELS[6], SPECTRE_LABELS[20]]
];
SPECTRE_OBJECTS = [
    [SPECTRE_LABELS[8], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[10], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[12], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[0], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[2], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[17], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[6], 64, 0, 0.25 * scale],
    [SPECTRE_LABELS[4], 64, 0, 0.25 * scale]
];

function GetArcPoints(p0, p1, angle) = 
    let(
        v = p1 - p0,
        L = norm(v)
    )
    (L < 0.0001 || abs(angle) < 0.001) ? [p0, p1] :
    let(
        M = (p0 + p1) / 2,
        u = v / L,
        n = [-u[1], u[0]],
        half_angle = abs(angle) / 2,
        s = (L / 2) / tan(half_angle),
        C = M + s * sign(angle) * n,
        V0 = p0 - C,
        steps_actual = max(10, ceil(abs(angle) / 5))
    ) [
        for (j = [0 : steps_actual])
            let(
                t = j / steps_actual,
                theta_t = t * angle,
                dx = V0[0] * cos(theta_t) - V0[1] * sin(theta_t),
                dy = V0[0] * sin(theta_t) + V0[1] * cos(theta_t)
            )
            C + [dx, dy]
    ];

function MinX(points) = min([for (p = points) p[0]]);
function MinY(points) = min([for (p = points) p[1]]);
function MaxX(points) = max([for (p = points) p[0]]);
function MaxY(points) = max([for (p = points) p[1]]);
function GetWidth(points) = MaxX(points) - MinX(points);
function GetLength(points) = MaxY(points) - MinY(points);

chevron_width = GetWidth(CHEVRON_SHAPE_POINTS);
comet_width = GetWidth(COMET_SHAPE_POINTS);
hat_width = GetWidth(HAT_SHAPE_POINTS);
turtle_width = GetWidth(TURTLE_SHAPE_POINTS);
spectre_width = GetWidth(SPECTRE_SHAPE_POINTS);

pos_chevron = 0;
pos_comet = pos_chevron + (generate_chevron ? chevron_width + storage_wall_thickness * 3 : 0);
pos_hat = pos_comet + (generate_comet ? comet_width + storage_wall_thickness * 3 : 0);
pos_turtle = pos_hat + (generate_hat ? hat_width + storage_wall_thickness * 3 : 0);
pos_spectre = pos_turtle + (generate_turtle ? turtle_width + storage_wall_thickness * 3 : 0);

storage_configs = [
    [generate_chevron_storage, storage_layout_chevron, CHEVRON_SHAPE_POINTS, CHEVRON_STORAGE_POINTS, CHEVRON_ALL_POINTS, [-MinX(CHEVRON_ALL_POINTS), -MinY(CHEVRON_ALL_POINTS)], 1],
    [generate_comet_storage, storage_layout_comet, COMET_SHAPE_POINTS, COMET_SHAPE_STORAGE, COMET_ALL_POINTS, [-MinX(COMET_ALL_POINTS), -MinY(COMET_ALL_POINTS)], 2],
    [generate_hat_storage, storage_layout_hat, HAT_SHAPE_POINTS, HAT_SHAPE_STORAGE, HAT_ALL_POINTS, [-HAT_ALL_POINTS[1][0], -HAT_ALL_POINTS[13][1]], 3],
    [generate_turtle_storage, storage_layout_turtle, TURTLE_SHAPE_POINTS, TURTLE_SHAPE_STORAGE, TURTLE_ALL_POINTS, [0, -TURTLE_ALL_POINTS[9][1]], 4],
    [generate_spectre_storage, storage_layout_spectre, SPECTRE_SHAPE_POINTS, SPECTRE_SHAPE_STORAGE, SPECTRE_SHAPE_POINTS, [-MinX(SPECTRE_SHAPE_POINTS), -MinY(SPECTRE_SHAPE_POINTS)], 5]
];

function GetTransformedStoragePoints() = [
    for (cfg = storage_configs)
        if (cfg[0])
            let(
                layout = cfg[1],
                points = cfg[2],
                origin_offset = cfg[5],
                lx = layout[0],
                ly = layout[1],
                rot = layout[2]
            )
            for (p = points)
                let(
                    tp = p + origin_offset,
                    rp = [tp[0] * cos(rot) - tp[1] * sin(rot), tp[0] * sin(rot) + tp[1] * cos(rot)] + [lx, ly]
                )
                rp
];

trans_storage_points = GetTransformedStoragePoints();

function AllStorageX() = [for (p = trans_storage_points) p[0]];
function AllStorageY() = [for (p = trans_storage_points) p[1]];

storage_min_x = len(AllStorageX()) > 0 ? min(AllStorageX()) : 0;
storage_max_x = len(AllStorageX()) > 0 ? max(AllStorageX()) : 0;
storage_min_y = len(AllStorageY()) > 0 ? min(AllStorageY()) : 0;
storage_max_y = len(AllStorageY()) > 0 ? max(AllStorageY()) : 0;

storage_center_x = (storage_min_x + storage_max_x) / 2;
storage_center_y = (storage_min_y + storage_max_y) / 2;

tile_configs = [
    [generate_chevron, pos_chevron, -MinX(CHEVRON_SHAPE_POINTS), -MinY(CHEVRON_SHAPE_POINTS), CHEVRON_SHAPE_POINTS, CHEVRON_ALL_POINTS, CHEVRON_GROOVES, CHEVRON_CURVES, CHEVRON_OBJECTS],
    [generate_comet, pos_comet, -MinX(COMET_SHAPE_POINTS), -MinY(COMET_SHAPE_POINTS), COMET_SHAPE_POINTS, COMET_ALL_POINTS, COMET_GROOVES, COMET_CURVES, COMET_OBJECTS],
    [generate_hat, pos_hat, -HAT_ALL_POINTS[1][0], -HAT_ALL_POINTS[13][1], HAT_SHAPE_POINTS, HAT_ALL_POINTS, HAT_GROOVES, HAT_CURVES, HAT_OBJECTS],
    [generate_turtle, pos_turtle, 0, -TURTLE_ALL_POINTS[9][1], TURTLE_SHAPE_POINTS, TURTLE_ALL_POINTS, TURTLE_GROOVES, TURTLE_CURVES, TURTLE_OBJECTS],
    [generate_spectre, pos_spectre, -MinX(SPECTRE_SHAPE_POINTS), -MinY(SPECTRE_SHAPE_POINTS), SPECTRE_SHAPE_POINTS, SPECTRE_LABELS, SPECTRE_GROOVES, SPECTRE_CURVES, SPECTRE_OBJECTS]
];

module ClearedPolygon(points) {
    offset(r = -clearance, $fn = fn_detail) {
        polygon(points);
    }
}

module RoundedBox(points, radius = 3) {
    min_x = min([for (p = points) p[0]]);
    max_x = max([for (p = points) p[0]]);
    min_y = min([for (p = points) p[1]]);
    max_y = max([for (p = points) p[1]]);
    
    translate([min_x, min_y])
        offset(r = max(0.01, radius), $fn = fn_detail)
            square([max_x - min_x, max_y - min_y]);
}

module OutlineGroove2D(points) {
    difference() {
        offset(r = -clearance - (EPSILON / 2), $fn = fn_detail) {
            polygon(points);
        }
        offset(r = -clearance - outline_groove_width, $fn = fn_detail) {
            polygon(points);
        }
    }
}

module PolygonGroove2D(interior_grooves) {
    for (groove = interior_grooves) {
        hull() {
            translate(groove[0]) circle(r = max(0.01, (polygon_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
            translate(groove[1]) circle(r = max(0.01, (polygon_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
        }
    }
}

module ArtGroove2D(curve_grooves) {
    for (art = curve_grooves) {
        if (len(art) == 3 || len(art) == 4) {
            angle = art[0];
            p0 = art[1];
            p1 = art[2];
            arc_pts = GetArcPoints(p0, p1, angle);
            
            for (k = [0 : len(arc_pts) - 2]) {
                hull() {
                    translate(arc_pts[k]) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                    translate(arc_pts[k + 1]) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                }
            }
            
            if (len(art) == 4) {
                p2 = art[3];
                hull() {
                    translate(p2) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                    translate(arc_pts[0]) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                }
                hull() {
                    translate(p2) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                    translate(arc_pts[len(arc_pts) - 1]) circle(r = max(0.01, (curve_groove_width / 2) - (EPSILON / 2)), $fn = max(16, fn_detail / 2));
                }
            }
        }
    }
}

module ObjectGroove2D(object_grooves) {
    for (obj = object_grooves) {
        if (len(obj) == 4) {
            translate(obj[0]) {
                rotate([0, 0, obj[2]]) {
                    circle(r = max(0.01, obj[3] - (EPSILON / 2)), $fn = obj[1]);
                }
            }
        } else if (len(obj) >= 5) {
            translate(obj[0]) {
                rotate([0, 0, obj[2]]) {
                    offset(r = -EPSILON / 2, $fn = max(16, fn_detail / 2)) {
                        polygon([
                            for (i = [0 : 2 * obj[1] - 1])
                                let(
                                    angle = i * 360 / (2 * obj[1]),
                                    r = (i % 2 == 0) ? obj[3] : obj[4]
                                )
                                [r * cos(angle), r * sin(angle)]
                        ]);
                    }
                }
            }
        }
    }
}

module ArtTriangle2D(art, points) {
    angle = art[0];
    p0 = art[1];
    p1 = art[2];
    p2 = art[3];
    
    arc_pts = GetArcPoints(p0, p1, angle);
    
    intersection() {
        ClearedPolygon(points);
        polygon([for (pt = arc_pts) pt, p2]);
    }
}

module AperiodicTile(start_x = 0, start_y = 0, points = [], label_data = [], interior_grooves = [], curve_grooves = [], object_grooves = []) {
    has_3pt_curves = len([for (g = curve_grooves) if (len(g) == 4) g]) > 0;
    tile_actual_height = (curve_height > 0 && has_3pt_curves) ? tile_height + curve_height : tile_height;
    curve_inset = max(outline_groove_depth, polygon_groove_depth);
    
    translate([start_x, start_y, 0]) {
        difference() {
            union() {
                color("lightgrey") difference() {
                    linear_extrude(height = tile_height, convexity = 10) {
                        ClearedPolygon(points);
                    }
                    if ((polygon_groove_position == "top" || polygon_groove_position == "both") && len(interior_grooves) > 0) {
                        translate([0, 0, tile_actual_height - polygon_groove_depth - EPSILON]) {
                            linear_extrude(height = polygon_groove_depth + (EPSILON * 2), convexity = 10) {
                                PolygonGroove2D(interior_grooves);
                            }
                        }
                    }
                }
                if (curve_groove_position == "top" || curve_groove_position == "both") {
                    for (i = [0 : len(curve_grooves) - 1]) {
                        if (len(curve_grooves[i]) == 4) {
                            translate([0, 0, tile_height - curve_inset]) {
                                color("yellow") linear_extrude(height = curve_height + curve_inset, convexity = 10) {
                                    ArtTriangle2D(curve_grooves[i], points);
                                }
                            }
                        }
                    }
                }
            }
            
            if (outline_groove_position == "top" || outline_groove_position == "both") {
                translate([0, 0, tile_actual_height - outline_groove_depth - EPSILON]) {
                    color("darkcyan") linear_extrude(height = outline_groove_depth + (EPSILON * 2), convexity = 10) {
                        OutlineGroove2D(points);
                    }
                }
            }
            
            if ((curve_groove_position == "top" || curve_groove_position == "both") && len(curve_grooves) > 0) {
                translate([0, 0, tile_actual_height - curve_groove_depth - EPSILON]) {
                    color("crimson") linear_extrude(height = curve_groove_depth + (EPSILON * 2), convexity = 10) {
                        ArtGroove2D(curve_grooves);
                    }
                }
            }
            
            if ((object_groove_position == "top" || object_groove_position == "both") && len(object_grooves) > 0) {
                translate([0, 0, tile_actual_height - object_groove_depth - EPSILON]) {
                    color("blue") linear_extrude(height = object_groove_depth + (EPSILON * 2), convexity = 10) {
                        ObjectGroove2D(object_grooves);
                    }
                }
            }
            
            if (outline_groove_position == "bottom" || outline_groove_position == "both") {
                translate([0, 0, -EPSILON]) {
                    color("darkgreen") linear_extrude(height = outline_groove_depth + (EPSILON * 2), convexity = 10) {
                        OutlineGroove2D(points);
                    }
                }
            }
            
            if ((polygon_groove_position == "bottom" || polygon_groove_position == "both") && len(interior_grooves) > 0) {
                translate([0, 0, -EPSILON]) {
                    color("cyan") linear_extrude(height = polygon_groove_depth + (EPSILON * 2), convexity = 10) {
                        PolygonGroove2D(interior_grooves);
                    }
                }
            }
            
            if ((curve_groove_position == "bottom" || curve_groove_position == "both") && len(curve_grooves) > 0) {
                translate([0, 0, -EPSILON]) {
                    color("black") linear_extrude(height = curve_groove_depth + (EPSILON * 2), convexity = 10) {
                        ArtGroove2D(curve_grooves);
                    }
                }
            }

            if ((object_groove_position == "bottom" || object_groove_position == "both") && len(object_grooves) > 0) {
                translate([0, 0, -EPSILON]) {
                    color("navy") linear_extrude(height = object_groove_depth + (EPSILON * 2), convexity = 10) {
                        ObjectGroove2D(object_grooves);
                    }
                }
            }
        }
        
        if ($preview && len(label_data) > 0) {
            color("Orange") {
                for (item = [0 : len(label_data) - 1]) {
                    pt = label_data[item];
                    txt = str(item);
                    translate([pt[0], pt[1], tile_actual_height]) {
                        linear_extrude(height = 0.2) {
                            text(txt, size = 0.5 * scale, halign = "center", valign = "center");
                        }
                    }
                }
            }
        }
    }
}

module Base2DOutline() {
    if (storage_enclosure == "rounded") {
        translate([storage_min_x, storage_min_y])
            offset(r = storage_wall_thickness, $fn = fn_detail)
                square([storage_max_x - storage_min_x, storage_max_y - storage_min_y]);
    } else {
        hull() {
            for (cfg = storage_configs) {
                if (cfg[0]) {
                    translate([cfg[1][0], cfg[1][1]])
                        rotate([0, 0, cfg[1][2]])
                            translate(cfg[5])
                                offset(r = storage_wall_thickness, $fn = fn_detail) {
                                    ClearedPolygon(cfg[2]);
                                }
                }
            }
        }
    }
}

module StorageItemTransform(layout, origin_offset) {
    translate([layout[0], layout[1], 0])
        rotate([0, 0, layout[2]])
            translate(origin_offset)
                children();
}

module StoragePocketBase(layout, floor_points, origin_offset) {
    StorageItemTransform(layout, origin_offset) {
        linear_extrude(height = storage_floor_thickness, convexity = 10)
            offset(r = storage_wall_thickness, $fn = fn_detail)
                ClearedPolygon(floor_points);
    }
}

module StoragePocketBody(layout, floor_points, wall_points, origin_offset) {
    StorageItemTransform(layout, origin_offset) {
        translate([0, 0, storage_floor_thickness - EPSILON])
            linear_extrude(height = storage_height - storage_floor_thickness, convexity = 10)
                offset(r = storage_wall_thickness, $fn = fn_detail) {
                    if (storage_enclosure == "full") {
                        ClearedPolygon(floor_points);
                    } else if (storage_enclosure == "minimal") {
                        ClearedPolygon(wall_points);
                    } else {
                        RoundedBox(floor_points, radius = 3);
                    }
                }
    }
}

module StoragePocketCutout(layout, floor_points, origin_offset) {
    StorageItemTransform(layout, origin_offset) {
        translate([0, 0, storage_floor_thickness - EPSILON])
            linear_extrude(height = storage_height + EPSILON, convexity = 10)
                offset(r = storage_pocket_clearance, $fn = fn_detail)
                    ClearedPolygon(floor_points);
    }
}

module StorageHullGroup() {
    if (storage_enclosure == "rounded") {
        linear_extrude(height = storage_floor_thickness, convexity = 10) {
            translate([storage_min_x, storage_min_y])
                offset(r = storage_wall_thickness, $fn = fn_detail)
                    square([storage_max_x - storage_min_x, storage_max_y - storage_min_y]);
        }
        translate([0, 0, storage_floor_thickness - EPSILON]) {
            linear_extrude(height = storage_height - storage_floor_thickness + EPSILON, convexity = 10) {
                translate([storage_min_x, storage_min_y])
                    offset(r = storage_wall_thickness, $fn = fn_detail)
                        square([storage_max_x - storage_min_x, storage_max_y - storage_min_y]);
            }
        }
    } else {
        hull() {
            for (cfg = storage_configs) {
                if (cfg[0]) {
                    StoragePocketBase(cfg[1], cfg[2], cfg[5]);
                }
            }
        }
        hull() {
            for (cfg = storage_configs) {
                if (cfg[0]) {
                    StoragePocketBody(cfg[1], cfg[2], cfg[3], cfg[5]);
                }
            }
        }
    }
}

module Lid2DOutline() {
    offset(r = lid_clearance + lid_thickness, $fn = fn_detail)
        Base2DOutline();
}

module LidLip() {
    linear_extrude(height = lid_lip_depth + lid_thickness, convexity = 10) {
        difference() {
            offset(r = lid_clearance + (lid_thickness), $fn = fn_detail)
                Base2DOutline();
            offset(r = lid_clearance, $fn = fn_detail)
                Base2DOutline();
        }
    }
}

module ConnectedStorageTray() {
    difference() {
        StorageHullGroup();
        for (cfg = storage_configs) {
            if (cfg[0]) {
                StoragePocketCutout(cfg[1], cfg[2], cfg[5]);
            }
        }
        translate([storage_center_x - scale, storage_center_y - scale, 0]) {
            EMCLogo(scale * 2, scale * 2, outline_groove_depth);
        }
    }
}

module ConnectedStorageLid() {
    union() {
        linear_extrude(height = lid_thickness, convexity = 10)
            Lid2DOutline();
        LidLip();
    }
}

module EMCLogo(w, l, h) {
    linear_extrude(height = h) {
        scale([w / 300, l / 300]) {
            polygon([[0,300],[0,193],[10,186],[10,290],[290,290],[290,240],[300,240],[300,300]]);
            polygon([[113,226],[285,190],[285,110],[113,74],[113,115],[275,115],[275,185],[113,185]]);
            polygon([[0,0],[0,107],[10,114],[10,10],[290,10],[290,60],[300,60],[300,0]]);
        }
    }
}

for (cfg = tile_configs) {
    if (cfg[0]) {
        translate([cfg[1], 0, 0])
            AperiodicTile(start_x = cfg[2], start_y = cfg[3], points = cfg[4], label_data = cfg[5], interior_grooves = cfg[6], curve_grooves = cfg[7], object_grooves = cfg[8]);
    }
}

if (generate_chevron_storage || generate_comet_storage || generate_hat_storage || generate_turtle_storage || generate_spectre_storage) {
    translate([0, -scale * 3, 0]) ConnectedStorageTray();
}

if (generate_lid) {
    translate([storage_max_x + scale * 4, -scale * 3 - lid_thickness, 0]) ConnectedStorageLid();
}
