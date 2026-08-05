/*
 * Script Name: EmSCAD-BOSS (Box Of Slotted Sleeves)
 * Description: Parametric 3D printable object storage box or box void with 
 *              internal modular sleeves following EmSea Coding Standards.
 * Language:    OpenSCAD
 * Output:      Supportless FDM 3D printable STL file
 * Glossary:
 *  Physical Things
 *      Object: Thing being stored (cartridges or cards or whatever)
 *      Sleeve: Thing that holds an object
 *      Sleeve Row: Side-by-side set of sleeves
 *      Sleeve Tabs: Things on the side of a sleeve row to slide into a slot
 *      Sleeve Label: Optional nameplate that clicks into a sleeve
 *      Box: Thing that holds one or more sleeve rows
 *      Void Box: Thing that is the inner shape of the box
 *      Lid: Thing that covers a box and holds sleve sets inside
 *      Lid Rail: Horizontal thing on the side of a box to attach the lid
 *      Detent: Optional thing that sticks out of a lid rail to hold a box closed
 *  The Absence of Things
 *      Object Window: Optional cutout in the front/top of a sleeve
 *      Sleeve Cutout: Optional shape grid cut into every sleeve
 *      Sleeve Slot: Cutout inside the box side to hold a sleeve_tab
 *      Staggered Slot Pockets: Optional staggered indentations behind each sleeve_slot
 *      Box Window: Optional cutout in the front/top of a box
 *      Lid Grip: Optional indentations on the side of the lid
 */

/* [Render Options] */
// Generate the slide-on lid
render_lid = true;
// Generate the main box
render_box = true;
// Generate the internal sleeves
render_sleeve_rows = true;
// Generate one sleeve label template
render_sleeve_label = true;
// Separate the pieces for visualizing vs printing
render_as_separate_pieces = true;
// Create short slices of the pieces for test printing
render_test_versions = false;

/* [Enable Modifications] */
// Generate the box as a negative space cutout tool (e.g. for gridfinity filled base)
enable_void_box = false;
// Enable staggered step-up rows of sleeve_rows
enable_step_up_slots = false;
// Enable Sleeve Label connection points and label template
enable_sleeve_label = true;
// Enable Sleeve Cutouts in each sleeve
enable_sleeve_cutout = false;
// Generate lid rails on the box and cutouts in the lid
enable_lid_rails = true;
// Detent size in rails - only changes the lid
enable_lid_detent = "medium"; // [none, medium, strong]
// Enable front display window on the box to match sleeve window
enable_box_window = true;
// Enable grips on the lid
enable_lid_grips = true;

/* [Define the Object(s)] */
// Objects per sleeve row
num_objects = 2;
// Number of sleeve rows
num_rows = 3;
// Values (mm) used if "Custom" is selected - specify depth with Deck presets
object_preset = "Custom"; // [Nintendo_Switch:"Nintendo Switch (w=21.5, h=32.0,d=4.0, r=0)", GameBoy:"Game Boy (w=57.0, h=65.0, d=8.0, r=1.0)", SD_Card:"SD Card (w=24.2, h=32.2, d=2.1, r=1.0)", Dominion_Deck:"Dominion Deck (w=59.0, h=91.0, d=[custom or 1], r=0)", Pokemon_Deck: "Pokemon Deck (w=63.0, h=88.0, d=[custom or 1], r=0)",CC: "Credit Cards: (w=85.6, h=53.98, d=4, 0)", Custom]
// width = x
custom_object_width = 20.0; // 0.1
// height = z
custom_object_height = 20.0; // 0.1
// depth = y, Preset decks still allow modifications to depth 
custom_object_depth = 4.0; // 0.1
custom_object_radius = 1.0; // 0.1

/* [Define the Sleeve(s)] */
// Percent of object height/z for front display window
object_window_percent = 30; // [0:1:100]
// Height/z (mm) of label
sleeve_label_size = 10; // 0.1
// Make the label plug end thinner to make it more swappable - only changes the label
more_removable_label = false;
// Increase the spacing/x (mm) between individual sleeves
minimum_sleeve_spacing = 0; // 0.1
sleeve_cutout_shape = "hexagon"; // [hexagon, diamond, tear]
// Size (mm) of the cutouts
sleeve_cutout_size = 3.0; // 0.1
// Distance (mm) between individual cutouts
sleeve_cutout_spacing = 1.6;
// Solid border (mm) around cutouts
sleeve_border_size = 2; // 0.1
// Minimum width/x (mm) for a sleeve row tab
custom_tab_width = 0; // 0.1
// Minimum depth/y (mm) for a sleeve row tab
custom_tab_depth = 0; // 0.1

/* [Define the Box] */
// Inset distance/y (mm) from the front for first sleeve row (defaults to sleeve thickness)
first_sleeve_row_inset = 0; // 0.1
// Inset distance/y (mm) from the back for last sleeve row (defaults to sleeve thickness)
last_sleeve_row_inset = 0; // 0.1
// Minimum spacing/y (mm) between sleeve_rows in the box
minimum_row_spacing = 0; // 0.1
// If step_up_slots are enabled, set the height/z of each consecutive row upward as percent of the object height
step_percent = 30.0; // [0:1:100]
// Box corner rounding radius, default and max of box_thickness
box_corner_radius = 0; // 0.1
// Set custom outer width/x (0 uses auto-calculated minimum)
custom_box_outer_width = 0; // 0.1
// Set custom outer depth/y (0 uses auto-calculated minimum)
custom_box_outer_depth = 0; // 0.1
// Set custom outer height/z (0 uses auto-calculated minimum)
custom_box_outer_height = 0; // 0.1

/* [Walls and Clearances] */
// Thickness (mm) of the sleeve walls
sleeve_thickness = 0.8;
// Thickness (mm) of the box and top walls
box_thickness = 1.6;
// Physical tolerance (mm) added to objects
object_clearance = 0.4; // [0:0.1:2]
// Physical gap tolerance for sleeve rows into the box
sleeve_clearance = 0.2; // [0:.01:1]
// Physical gap tolerance for the snap on the label on the sleeve
label_clearance = 0.1; // [0:.01:1]
// Physical gap tolerance for the lid onto the box
lid_clearance = 0.2; // [0:.01:1]
// Printer's nozzle diameter - sets some minimum radii and overhangs
nozzle_size = 0.4; // [0.1:.01:1]

/* [Hidden] */
$fs = 0.5;
$fa = 12;
EPSILON = 0.02;
CUTOUT_FN = 16;
CORNER_FN_LARGE = 64;
CORNER_FN_SMALL = 16;
RAD_TOLERANCE = 2.001; // manifold errors are ANNOYING
MATH_SQRT2_2 = 0.70710678; // Don't repeat cos(45°)/sin(45°)

// Validation & Calculation
function SafeVal(v) = max(0.01, v);
function SafeRad(r, w, d) = min(max(r, nozzle_size), w / RAD_TOLERANCE, d / RAD_TOLERANCE);
function SafeBoxRad(r, w, d) = min(max(r, 0), w / RAD_TOLERANCE, d / RAD_TOLERANCE);

assert(num_objects > 0, "Error: num_objects must be greater than 0");
assert(num_rows > 0, "Error: num_rows must be greater than 0");
assert(sleeve_thickness > 0, "Error: sleeve_thickness must be greater than 0");
assert(box_thickness > 0, "Error: box_thickness must be greater than 0");
assert(nozzle_size > 0, "Error: nozzle_size must be greater than 0");

PRESET_DATA = (object_preset == "Nintendo_Switch") ? [21.5, 32.0, 4.0, 0] :
              (object_preset == "GameBoy")         ? [57.0, 65.0, 8.0, 1.0] :
              (object_preset == "SD_Card")         ? [24.2, 32.2, 2.1, 1.0] : 
              (object_preset == "Dominion_Deck")   ? [59.0, 91.0, max(custom_object_depth, 1.0), 0] :
              (object_preset == "Pokemon_Deck")    ? [63.0, 88.0, max(custom_object_depth, 1.0), 0] :
              (object_preset == "CC")              ? [85.6, 53.98, 4, 0] :
                                                     [custom_object_width, custom_object_height, custom_object_depth, custom_object_radius];
                                                     
object_width  = PRESET_DATA[0];
object_height = PRESET_DATA[1];
object_depth  = PRESET_DATA[2];
object_radius = PRESET_DATA[3];

sleeve_inner_width  = SafeVal(object_width + object_clearance);
sleeve_inner_depth  = SafeVal(object_depth + object_clearance);
sleeve_inner_height = SafeVal(object_height + object_clearance);

sleeve_label_height = (enable_sleeve_label) ? min(max(sleeve_label_size, sleeve_thickness * 3), object_height + sleeve_thickness) : 0;
sleeve_label_width  = sleeve_inner_width;
sleeve_label_radius = SafeVal(min(sleeve_label_width / RAD_TOLERANCE, sleeve_label_height / RAD_TOLERANCE));
sleeve_pin_radius   = SafeVal(sleeve_label_radius / 2);

sleeve_front_wall   = (enable_sleeve_label) ? sleeve_thickness * 3 : sleeve_thickness;

sleeve_outer_width  = sleeve_inner_width + 2 * sleeve_thickness;
sleeve_outer_depth  = sleeve_inner_depth + sleeve_thickness + sleeve_front_wall;
sleeve_outer_height = sleeve_inner_height + 2 * sleeve_thickness;

box_radius           = (box_corner_radius > 0) ? min(box_corner_radius, box_thickness) : box_thickness;
object_window_height = min(sleeve_inner_height * object_window_percent / 100, sleeve_inner_height - sleeve_label_height);
sleeve_radius        = SafeRad(object_radius, object_width, object_depth);
border_margin        = max(sleeve_radius + sleeve_thickness, sleeve_border_size);

sleeve_tab_width = max(custom_tab_width, sleeve_thickness * 3, object_width / 8);
sleeve_tab_depth = (custom_tab_depth > 0) ? min(custom_tab_depth, sleeve_outer_depth) : max(sleeve_outer_depth / 3, sleeve_thickness * 3);
step_up_spacing  = max(sleeve_thickness, (2 * sleeve_tab_depth) + (3 * sleeve_clearance) + nozzle_size + box_thickness + sleeve_thickness - sleeve_outer_depth);
custom_row_spacing = (minimum_row_spacing > 0) ? minimum_row_spacing : sleeve_thickness;
sleeve_row_spacing = max(custom_row_spacing, sleeve_clearance + ((enable_step_up_slots==true) ? step_up_spacing : sleeve_thickness));

box_window_height  = max(sleeve_outer_height - object_window_height - border_margin, sleeve_thickness + border_margin);

lid_rail_width  = sleeve_thickness * 0.9;
lid_rail_height = max(sleeve_thickness * 3, (sleeve_outer_height + (lid_clearance * 2) + box_thickness) * 0.15);

row_stagger_height    = (enable_step_up_slots) ? sleeve_outer_height * step_percent / 100 : 0;

function CalcRowY(r, spacing) = (r <= 0) ? 0 : (sleeve_outer_depth + spacing) + (r - 1) * (sleeve_outer_depth + spacing);

base_step_x           = (sleeve_outer_width - sleeve_thickness) + minimum_sleeve_spacing;
base_sleeve_row_width = (num_objects > 1) ? ((num_objects - 1) * base_step_x + sleeve_outer_width) : sleeve_outer_width;
min_box_inner_width   = base_sleeve_row_width + (sleeve_clearance * 2);
min_box_side_thickness = box_thickness + sleeve_tab_width + sleeve_clearance;
min_box_outer_width   = min_box_inner_width + (2 * min_box_side_thickness);

front_sleeve_row_inset = (first_sleeve_row_inset > 0) ? first_sleeve_row_inset : sleeve_thickness;
back_sleeve_row_inset = (last_sleeve_row_inset > 0) ? last_sleeve_row_inset : sleeve_thickness;
sleeve_row_insets = front_sleeve_row_inset + back_sleeve_row_inset;

min_box_inner_depth = CalcRowY(num_rows - 1, sleeve_row_spacing) + sleeve_outer_depth + sleeve_row_insets + (sleeve_clearance * 2)+ ((enable_step_up_slots==true) ? sleeve_tab_depth : 0);
min_box_outer_depth = min_box_inner_depth + (2 * box_thickness);

max_stagger_height   = (enable_step_up_slots && num_rows > 2) ? (num_rows - 2) * row_stagger_height : 0;
min_box_inner_height = sleeve_outer_height + (sleeve_clearance * 2) + max_stagger_height;
min_box_outer_height = min_box_inner_height + box_thickness;

box_outer_width    = max(min_box_outer_width, custom_box_outer_width);
box_outer_depth    = max(min_box_outer_depth, custom_box_outer_depth);
box_outer_height   = max(min_box_outer_height, custom_box_outer_height);

extra_box_depth    = box_outer_depth - min_box_outer_depth;
actual_row_spacing = sleeve_row_spacing + ((num_rows > 1) ? (extra_box_depth / (num_rows - 1)) : 0);

detent_length   = max(lid_rail_height * 0.6, 3.0);

function GetRowY(r) = CalcRowY(r, actual_row_spacing);

extra_width         = box_outer_width - min_box_outer_width;
sleeve_spacing      = (custom_box_outer_width == 0) ? minimum_sleeve_spacing : ((num_objects > 1) ? (extra_width / (num_objects - 1)) : 0);
step_x              = (sleeve_outer_width - sleeve_thickness) + sleeve_spacing;
actual_rail_width   = (num_objects > 1) ? sleeve_tab_width : sleeve_tab_width + (extra_width / 2);
box_side_thickness  = box_thickness + actual_rail_width + sleeve_clearance;
box_inner_height    = box_outer_height - box_thickness;
box_inner_depth     = box_outer_depth - (2 * box_thickness);
box_inner_width     = box_outer_width - (2 * box_side_thickness);
detent_setback      = box_thickness + detent_length + box_radius;
sleeve_row_width    = (num_objects > 1) ? ((num_objects - 1) * step_x + sleeve_outer_width) : sleeve_outer_width;
box_x_offset        = (render_as_separate_pieces || render_test_versions) ? (sleeve_tab_width + actual_rail_width) * 2 + sleeve_row_width : 0;

// 2D Modules

module RoundedRectangle2D(width, height, radius) {
    let (
        safe_w = SafeVal(width),
        safe_h = SafeVal(height),
        safe_r = SafeVal(min(radius, safe_w / RAD_TOLERANCE, safe_h / RAD_TOLERANCE))
    ) {
        translate([safe_r, safe_r])
            offset(r = safe_r, $fn = CORNER_FN_LARGE)
            square([safe_w - 2 * safe_r, safe_h - 2 * safe_r]);
    }
}

module RoundedTopRectangle2D(w, d, r) {
    let (s_r = SafeRad(r, w, d)) {
        hull() {
            translate([0, 0]) square([SafeVal(w), s_r]);
            translate([s_r, max(s_r, d - s_r)]) circle(r = s_r, $fn = CORNER_FN_LARGE);
            translate([max(s_r, w - s_r), max(s_r, d - s_r)]) circle(r = s_r, $fn = CORNER_FN_LARGE);
        }
    }
}

module DrawSleeveCutoutShape(shape, r) {
    if (shape == "hexagon") {
        rotate([0, 0, 30]) circle(r = r, $fn = 6);
    } else if (shape == "diamond") {
        rotate([0, 0, 45]) square(r * sqrt(2), center = true);
    } else {
        union() {
            circle(r = r, $fn = CUTOUT_FN);
            polygon([
                [-r * MATH_SQRT2_2, r * MATH_SQRT2_2],
                [0, 0], 
                [r * MATH_SQRT2_2, r * MATH_SQRT2_2],
                [0, SafeVal(r / MATH_SQRT2_2)]
            ]);
        }
    }
}

module CutoutGrid2D(width, height, r, spacing) {
    if (r > 0.01) {
        let (
            is_hex = (sleeve_cutout_shape == "hexagon"),
            D = is_hex ? (r * sqrt(3) + spacing) : (2 * r + spacing),
            x_step = SafeVal(D),
            y_step = SafeVal(is_hex ? (D * sqrt(3) / 2) : (sleeve_cutout_shape == "diamond") ? r + spacing : spacing + 1.75 * r),
            cols = ceil(width / x_step),
            rows = ceil(height / y_step)
        ) {
            for (row = [0 : rows]) {
                for (col = [0 : cols]) { 
                    let (x_offset = (row % 2 != 0) ? (x_step / 2) : 0) {
                        translate([(col * x_step) + x_offset, row * y_step])
                            DrawSleeveCutoutShape(sleeve_cutout_shape, r);
                    }
                }
            }
        }
    }
}

module MaskedCutoutGrid2D(width, height, count) {
    let (safe_border = max(border_margin, sleeve_radius)) {
        intersection() {
            CutoutGrid2D(width, height, sleeve_cutout_size, sleeve_cutout_spacing);
            union() {
                for (i = [0 : count - 1]) {
                    translate([i * step_x + safe_border, border_margin])
                        square([SafeVal(sleeve_outer_width - safe_border * 2), SafeVal(height - border_margin * 2)]);
                }
            }
        }
    }
}

module KeepoutRegions2D(height, count) {
    let(
        w_h_area = object_window_height > 0,
        l_h_area = sleeve_label_height > 0
    ) {
        if (w_h_area || l_h_area) {
            for (i = [0 : count - 1]) {
                let( x_base = i * step_x ) {
                    if (w_h_area) {
                        translate([ x_base + sleeve_thickness - border_margin, height - object_window_height - border_margin ])
                            square([SafeVal(sleeve_inner_width + border_margin * 2), SafeVal(object_window_height + border_margin * 2)]);
                    }
                    if (l_h_area) {
                        translate([ x_base + sleeve_thickness - sleeve_border_size, height - object_window_height - sleeve_label_height - sleeve_border_size ])
                            square([SafeVal(sleeve_inner_width + sleeve_border_size * 2), SafeVal(sleeve_label_height + sleeve_border_size * 2)]);
                    }
                }
            }
        }
    }
}

module CombinedCutoutMask2D(width, height, count, apply_keepout = true) {
    if (apply_keepout) {
        difference() {
            MaskedCutoutGrid2D(width, height, count);
            KeepoutRegions2D(height, count);
        }
    } else {
        MaskedCutoutGrid2D(width, height, count);
    }
}

// 3D Modules

module RoundedBox(width, depth, height, r) {
    if (height > EPSILON) {
        let (s_r = SafeBoxRad(r, width, depth)) {
            if (s_r <= 0.01) {
                cube([SafeVal(width), SafeVal(depth), SafeVal(height)]);
            } else {
                linear_extrude(height = SafeVal(height))
                    translate([s_r, s_r])
                    offset(r = s_r, $fn = CORNER_FN_LARGE)
                    square([SafeVal(width - 2 * s_r), SafeVal(depth - 2 * s_r)]);
            }
        }
    }
}

module RoundedSleeveBlock(w, d, h, r, count = 1, step = 0, spacing = 0) {
    linear_extrude(height = SafeVal(h)) {
        if (count > 1 && spacing > 0.01) {
            union() {
                for(i = [0 : count - 1]) {
                    translate([i * step, 0]) RoundedTopRectangle2D(w, d, r);
                }
                square([SafeVal((count - 1) * step + w), sleeve_front_wall]);
            }
        } else {
            let (total_width = (count > 1) ? ((count - 1) * step + w) : w) {
                RoundedTopRectangle2D(total_width, d, r);
            }
        }
    }
}

module SingleTab(x_offset, is_right, z_start, z_end, safe_width, safe_depth, xy_off, original_z_off) {
    let(
        tab_h = z_end - z_start,
        z_off = min(original_z_off, tab_h / 2.01),
        safe_tab_h = SafeVal(tab_h - 2 * z_off)
    ) {
        translate([x_offset, 0, z_start])
            hull() {
                translate([0, 0, z_off]) cube([actual_rail_width + EPSILON, sleeve_tab_depth, safe_tab_h]);
                translate([is_right ? 0 : xy_off, xy_off, 0]) cube([safe_width, safe_depth, EPSILON]);
                translate([is_right ? 0 : xy_off, xy_off, tab_h - EPSILON]) cube([safe_width, safe_depth, EPSILON]);
            }
    }
}

module RailGeometry(x_offset, is_right, safe_height, safe_width, safe_depth, z_off, xy_off, outer_height) {
    let(
        segment_h = outer_height / 5,
        tab_bounds = [[0, segment_h], [segment_h * 2, segment_h * 3], [segment_h * 4, outer_height]]
    ) {
        for (bounds = tab_bounds) {
            SingleTab(x_offset, is_right, bounds[0], bounds[1], safe_width, safe_depth, xy_off, z_off);
        }
    }
}

module DrawDetent(x, z, is_right, is_cutout = false) {
    let(
        max_w = lid_rail_width / 2,
        max_h = lid_rail_height / 2,
        max_l = (box_outer_depth - 2 * box_radius) / 2,
        actual_detent_w = max_w * ((is_cutout) || (enable_lid_detent == "strong") ? 1 : 0.5 ),
        actual_detent_l = min(detent_length, max_l),
        base_detent_h = SafeVal(lid_rail_height - 2 * lid_rail_width),
        detent_h = min(base_detent_h, max_h),
        
        detent_y = box_outer_depth - detent_setback,
        detent_z = z - (lid_rail_height / 2) - (detent_h / 2),
        
        base_x = is_right ? (x + lid_rail_width) : (x - lid_rail_width),
        tip_dir = is_right ? -1 : 1 
    ) {
        if (is_cutout) {
            let(
                c = lid_clearance,
                start_x = is_right ? (base_x - actual_detent_w - c) : (base_x - EPSILON - c),
                cut_w = actual_detent_w + c * 2 + EPSILON
            ) {
                translate([start_x, detent_y - c, detent_z - c])
                    cube([SafeVal(cut_w), SafeVal(actual_detent_l + 2 * c), SafeVal(detent_h + 2 * c)]);
            }
        } else {
            let(
                wall_x = is_right ? (base_x + lid_clearance) : (base_x - lid_clearance),
                tip_x = wall_x + (tip_dir * actual_detent_w)
            ) {
                color("fuchsia") 
                hull() {
                    translate([is_right ? wall_x - EPSILON : wall_x, detent_y, detent_z])
                        cube([EPSILON * 2, SafeVal(actual_detent_l), SafeVal(detent_h)]);
                    translate([is_right ? tip_x : tip_x - EPSILON, detent_y + actual_detent_l * 0.15, detent_z + detent_h * 0.15])
                        cube([EPSILON, SafeVal(actual_detent_l * 0.7), SafeVal(detent_h * 0.7)]);
                }
            }
        }
    }
}

module DrawPairedDetents(x_left, x_right, z_offset, is_cutout = false) {
    DrawDetent(x_left, z_offset, false, is_cutout);
    DrawDetent(x_right, z_offset, true, is_cutout);
}

module DrawRail(x, z, is_right, clearance = 0, y_start = undef, length = undef) {
    let(
        rail_dir = is_right ? (lid_rail_width + EPSILON) : (-lid_rail_width - EPSILON),
        actual_y = is_undef(y_start) ? box_radius : y_start,
        actual_length = is_undef(length) ? SafeVal(box_outer_depth - 2 * box_radius) : length,
        rail_profile = [[0, lid_rail_height], [rail_dir, lid_rail_height - lid_rail_width], [rail_dir, lid_rail_width], [0, 0]]
    ) {
        translate([x, actual_y, z - EPSILON])
            rotate([-90, 0, 0])
            color("purple") linear_extrude(height = actual_length + EPSILON) {
                if (clearance > 0) {
                    intersection() {
                        offset(delta = clearance) polygon(points = rail_profile);
                        translate([is_right ? 0 : -clearance + rail_dir * 2, -clearance])
                            square([abs(rail_dir) + 10 * clearance, lid_rail_height + 2 * clearance]);
                    }
                } else {
                    polygon(points = rail_profile);
                }
            }
    }
}

module DrawPairedRails(x_left, x_right, z_offset, clearance = 0, y_start = undef, length = undef) {
    DrawRail(x_left, z_offset, false, clearance, y_start, length);
    DrawRail(x_right, z_offset, true, clearance, y_start, length);
}

module LidSideSupportTriangle(thick, depth, height) {
    rotate([90, 0, 90])
        linear_extrude(height = SafeVal(thick))
        polygon([[0, 0], [SafeVal(depth), SafeVal(height)], [0, SafeVal(height)]]);
}

module LidFlap(x_offset, side_flap_height, down_reach, lid_side_wall, lid_inner_depth) {
    translate([x_offset, -EPSILON, -side_flap_height - down_reach])
        cube([SafeVal(lid_side_wall), lid_inner_depth + 2 * EPSILON, SafeVal(side_flap_height + down_reach + EPSILON)]);
}

// Voids

module SleeveSlotCutouts(y_pos, z_pos, h_pos) {
    let(
        cut_size = [actual_rail_width + sleeve_clearance * 2 + EPSILON, sleeve_tab_depth + sleeve_clearance * 2, h_pos],
        rail_x = [box_side_thickness - actual_rail_width - sleeve_clearance, box_side_thickness + box_inner_width - EPSILON]
    ) {
        for (x = rail_x) {
            translate([x, y_pos, z_pos]) cube(cut_size);
        }
    }
}

module SupportFreePocket(w, d, h) {
    let(
        hook_w = d * 0.3,
        hook_h = min(h * 0.2, 1.5),
        roof_h = h + d
    ) {
        rotate([90, 0, 90])
        linear_extrude(height = SafeVal(w))
        polygon([
            [0, hook_h],
            [nozzle_size, hook_h],
            [hook_w, 0],
            [SafeVal(d + box_thickness), 0],
            [SafeVal(d + box_thickness), SafeVal(h)],
            [0, SafeVal(roof_h)]
        ]);
    }
}

module SleeveSlotIndents(y_pos, z_pos, row) {
    let (
        indent_y = y_pos + sleeve_tab_depth,
        segment_h = sleeve_outer_height / 5,
        stagger_z = row * row_stagger_height,
        indent_z_levels = [z_pos + stagger_z, z_pos + segment_h * 2 + stagger_z, z_pos + segment_h * 4 + stagger_z],
        indent_depth = sleeve_tab_depth + sleeve_clearance * 2,
        pocket_w = actual_rail_width + sleeve_clearance * 2 + EPSILON,
        rail_x = [box_side_thickness - actual_rail_width - sleeve_clearance, box_side_thickness + box_inner_width - EPSILON]
    ) {
        for (indent_z = indent_z_levels) {
            for (x = rail_x) {
                translate([x, indent_y - EPSILON, indent_z])
                    SupportFreePocket(pocket_w, indent_depth, segment_h);
            }
        }
    }
}

module ObjectSleeveCavity() {
    let(front_offset = sleeve_front_wall - sleeve_thickness) {
        union() {
            translate([sleeve_thickness, sleeve_thickness + front_offset, sleeve_thickness])
                RoundedBox(sleeve_inner_width, sleeve_inner_depth, sleeve_outer_height + EPSILON, sleeve_radius);
                
            if (object_window_height > 0) {
                translate([sleeve_thickness, -EPSILON, sleeve_outer_height - object_window_height])
                    cube([sleeve_inner_width, SafeVal(object_depth / 2 + sleeve_thickness + front_offset), object_window_height + EPSILON * 2]);
            }

            if (enable_sleeve_label) {
                let(label_z = sleeve_outer_height - object_window_height - sleeve_label_height) {
                    translate([sleeve_thickness, sleeve_thickness + EPSILON, label_z]) {
                        rotate([90, 0, 0])
                            linear_extrude(height = sleeve_thickness + label_clearance)
                            RoundedRectangle2D(sleeve_inner_width, sleeve_label_height, sleeve_label_radius);

                        translate([sleeve_inner_width / 2, sleeve_thickness + 2 * EPSILON, sleeve_label_height / 2])
                            rotate([90, 0, 0]) {
                                cylinder(h = sleeve_thickness * 2, r1 = sleeve_pin_radius + label_clearance, r2 = sleeve_pin_radius + nozzle_size + label_clearance, $fn = CORNER_FN_SMALL); 
                                translate([0, 0, -sleeve_thickness])
                                    cylinder(h = sleeve_thickness + EPSILON, r = sleeve_pin_radius + nozzle_size * 2 + label_clearance, $fn = CORNER_FN_SMALL);
                            }
                    }
                }
            }
        }
    }
}

// The Things

module SleeveRow(count = num_objects) {
    let(
        local_total_width = (count > 1) ? ((count - 1) * step_x + sleeve_outer_width) : sleeve_outer_width,
        z_off = min(1.0, sleeve_outer_height / 4),
        xy_off = min(0.5, sleeve_tab_depth / 4, actual_rail_width / 4),
        safe_height = SafeVal(sleeve_outer_height - 2 * z_off),
        safe_width = SafeVal(actual_rail_width + EPSILON - xy_off),
        safe_depth = SafeVal(sleeve_tab_depth - 2 * xy_off)
    ) {
        render(convexity = 6)
        difference() {
            union() {
                difference() {
                    RoundedSleeveBlock(sleeve_outer_width, sleeve_outer_depth, sleeve_outer_height, box_radius, count, step_x, sleeve_spacing);
                    union() {
                        for (i = [0 : count - 1]) {
                            translate([i * step_x, 0, 0]) ObjectSleeveCavity();
                        }
                        if (enable_sleeve_cutout && sleeve_cutout_size > 0.01) {
                            translate([0, sleeve_front_wall + EPSILON, 0])
                                rotate([90, 0, 0])
                                linear_extrude(height = sleeve_front_wall + 2 * EPSILON)
                                CombinedCutoutMask2D(local_total_width, sleeve_outer_height, count, true);

                            translate([0, sleeve_outer_depth + EPSILON, 0])
                                rotate([90, 0, 0])
                                linear_extrude(height = sleeve_thickness + 2 * EPSILON)
                                CombinedCutoutMask2D(local_total_width, sleeve_outer_height, count, false);
                        }
                    }
                }

                RailGeometry(-actual_rail_width, false, safe_height, safe_width, safe_depth, z_off, xy_off, sleeve_outer_height);
                RailGeometry(local_total_width - EPSILON, true, safe_height, safe_width, safe_depth, z_off, xy_off, sleeve_outer_height);
            }
        }
    }
}

module BoxCutout() {
    if (enable_box_window) {
        translate([box_side_thickness - EPSILON, -box_thickness * 2 - EPSILON, box_thickness + box_window_height])
            cube([box_inner_width + 2 * EPSILON, box_thickness * 3 + EPSILON * 2, box_inner_height + EPSILON]);
    }

    translate([box_side_thickness, box_thickness, box_thickness])
        cube([box_inner_width, box_inner_depth + nozzle_size, SafeVal(box_inner_height + EPSILON)]);
        
    for (r = [0 : num_rows - 1]) {
        let (y_offset = box_thickness + front_sleeve_row_inset + sleeve_clearance + GetRowY(r)) {
            SleeveSlotCutouts(y_offset - sleeve_clearance, box_thickness - EPSILON, box_inner_height + 2 * EPSILON);
            
            if (enable_step_up_slots && r > 0) {
                SleeveSlotIndents(y_offset - sleeve_clearance+nozzle_size, box_thickness - EPSILON, r);
            }
        }
    }
}

module StorageBox() {
    if (enable_void_box) {
        difference() {
            color("lavender", 0.4) BoxCutout();
            translate([-EPSILON, -EPSILON, box_outer_height - EPSILON]) 
                cube([box_outer_width + 2 * EPSILON, box_outer_depth + 2 * EPSILON, box_outer_height + EPSILON]);
        }
    } else {
        difference() {
            union() {
                color("lavender") RoundedBox(box_outer_width, box_outer_depth, box_outer_height, box_radius);
                if (enable_lid_rails) {
                    DrawPairedRails(EPSILON, box_outer_width - EPSILON, box_outer_height);
                    DrawPairedRails(EPSILON, box_outer_width - EPSILON, lid_rail_height);
                }
            }
            BoxCutout();
            
            if (enable_lid_rails) {
                DrawPairedDetents(EPSILON, box_outer_width - EPSILON, box_outer_height, is_cutout = true);
            }
        }
    }
}

module SlideOnLid() {
    let(
        lid_inner_width = box_outer_width + 2 * lid_clearance,
        lid_inner_depth = box_outer_depth + lid_clearance,
        lid_side_wall = box_thickness + lid_rail_width + lid_clearance,
        lid_outer_width = lid_inner_width + 2 * lid_side_wall,
        down_reach = (max_stagger_height - lid_clearance > 0.01) ? max_stagger_height : 0,
        side_flap_height = lid_rail_height * 1.5,
        flap_height_total = (enable_box_window) ? box_outer_height - box_window_height + lid_clearance : side_flap_height,
        support_depth = SafeVal(min(flap_height_total * 0.8, lid_inner_depth - 1)),
        lowest_z = min(-flap_height_total, -side_flap_height - down_reach),
        y_quarter = lid_inner_depth / 4
    ) {
        union() {
            intersection() {
                union() {
                    difference() {
                        union() {
                            translate([-lid_side_wall - lid_clearance, -EPSILON, 0])
                                cube([lid_outer_width, lid_inner_depth + EPSILON * 2, box_thickness]);
                            LidFlap(-lid_side_wall - lid_clearance, side_flap_height, down_reach, lid_side_wall, lid_inner_depth);
                            LidFlap(box_outer_width + lid_clearance, side_flap_height, down_reach, lid_side_wall, lid_inner_depth);
                            translate([-lid_side_wall - lid_clearance, -box_thickness, -max(0.01, side_flap_height + down_reach, flap_height_total)])
                                cube([lid_outer_width, box_thickness + EPSILON, max(0.01, side_flap_height + down_reach, flap_height_total) + box_thickness]);
                            translate([-lid_side_wall - lid_clearance - EPSILON, -EPSILON, -flap_height_total])
                                LidSideSupportTriangle(box_thickness + EPSILON * 2, support_depth + EPSILON, flap_height_total - down_reach);
                            translate([box_outer_width + lid_side_wall + lid_clearance - box_thickness - EPSILON, -EPSILON, -flap_height_total])
                                LidSideSupportTriangle(box_thickness + EPSILON * 2, support_depth + EPSILON, flap_height_total - down_reach);
                        }

                        if (enable_lid_rails) {
                            if (down_reach > 0.01) {
                                DrawPairedRails(0, box_outer_width, -lid_clearance - down_reach, lid_clearance, -EPSILON, lid_inner_depth + 2 * EPSILON);
                            }
                            DrawPairedRails(0, box_outer_width, -lid_clearance, lid_clearance, -EPSILON, lid_inner_depth + 2 * EPSILON);
                        }

                        if (enable_lid_grips) {
                            let(
                                d1 = SafeVal(box_thickness * 3),
                                d1_inner = SafeVal(d1 - box_thickness),
                                taper_depth = box_thickness * 0.6,
                                lid_h = down_reach + lid_side_wall,
                                lid_h_inner = SafeVal(lid_h - box_thickness)
                            ) {
                                hull() {
                                    translate([-lid_side_wall - lid_clearance - EPSILON*2, y_quarter - d1 / 2, -lid_h])
                                        cube([EPSILON * 2, SafeVal(d1), SafeVal(lid_h)]);
                                    translate([-lid_side_wall - lid_clearance + taper_depth, y_quarter - d1_inner / 2, -lid_h + box_thickness / 2])
                                        cube([EPSILON, SafeVal(d1_inner), SafeVal(lid_h_inner)]);
                                }
                                hull() {
                                    translate([box_outer_width + lid_clearance + lid_side_wall + EPSILON, y_quarter - d1 / 2, -lid_h])
                                        cube([EPSILON * 2, SafeVal(d1), SafeVal(lid_h)]);
                                    translate([box_outer_width + lid_clearance + lid_side_wall - taper_depth +  EPSILON, y_quarter - d1_inner / 2, -lid_h + box_thickness / 2])
                                        cube([EPSILON, SafeVal(d1_inner), SafeVal(lid_h_inner)]);
                                }
                            }
                        }
                    }

                    if (down_reach > 0.01) {
                        if (sleeve_spacing > sleeve_radius) {
                            for (i = [0 : num_objects - 1]) {
                                let(
                                    strut_width = SafeVal(sleeve_outer_width - lid_clearance * 2),
                                    strut_x = box_side_thickness + i * step_x + lid_clearance
                                ) translate([strut_x, -box_thickness / 2, -down_reach + lid_clearance])
                                    RoundedBox(strut_width, box_inner_depth + box_thickness / 2, down_reach - lid_clearance + EPSILON, sleeve_radius);
                            }
                        } else {
                            let(
                                strut_width = SafeVal(box_inner_width - lid_clearance * 2),
                                strut_x = box_side_thickness + lid_clearance
                            ) translate([strut_x, -box_thickness / 2, -down_reach + lid_clearance])
                                RoundedBox(strut_width, box_inner_depth + box_thickness / 2, down_reach - lid_clearance + EPSILON, sleeve_radius);
                        }
                    }
                }

                translate([-lid_side_wall - lid_clearance - EPSILON * 2, -box_thickness - EPSILON * 2, lowest_z - 2])
                    RoundedBox(lid_outer_width + EPSILON * 4, lid_inner_depth + box_thickness + EPSILON * 4, SafeVal(box_thickness - lowest_z + 4), box_radius);
            }

            if (enable_lid_rails && enable_lid_detent != "none") {
                DrawPairedDetents(0, box_outer_width, -lid_clearance, is_cutout = false);
            }
        }
    }
}

module SnapFitLabel() {
    if (enable_sleeve_label) {
        union() {
            linear_extrude(height = sleeve_thickness)
                offset(delta = -sleeve_clearance * 2)
                RoundedRectangle2D(sleeve_label_width, sleeve_label_height, sleeve_label_radius);
                
            translate([sleeve_label_width / 2, sleeve_label_height / 2, sleeve_thickness - EPSILON]) {
                let(bulge = more_removable_label ? (nozzle_size * 0.5) : nozzle_size) {
                    difference() {
                        union() {
                            cylinder(h = sleeve_thickness, r = sleeve_pin_radius, $fn = CORNER_FN_SMALL);
                            translate([0, 0, sleeve_thickness - EPSILON])
                                cylinder(h = sleeve_thickness / 2 + EPSILON * 2, r1 = sleeve_pin_radius, r2 = sleeve_pin_radius + bulge, $fn = CORNER_FN_SMALL);
                            translate([0, 0, sleeve_thickness * 1.5])
                                cylinder(h = sleeve_thickness / 2, r1 = sleeve_pin_radius + bulge, r2 = sleeve_pin_radius - nozzle_size, $fn = CORNER_FN_SMALL);
                        }
                        translate([-sleeve_label_width / 2, -sleeve_thickness / 2, -EPSILON])
                            cube([sleeve_label_width, sleeve_thickness, sleeve_thickness * 3]);
                    }
                }
            }
        }
    }
}

// Do The Things

if (render_sleeve_rows) {
    translate([0, 0, (render_test_versions ? -sleeve_outer_height + object_window_height + max(sleeve_thickness * 2, sleeve_label_height) : 0)]) {
        for(row = [0 : num_rows - 1]) {
            let(
                in_secondary = (enable_step_up_slots && row > 0),
                active_y = render_as_separate_pieces ? 
                    (row * (sleeve_thickness * 2 + sleeve_outer_depth)):
                    (box_thickness + front_sleeve_row_inset + sleeve_clearance + GetRowY(row))+(in_secondary?sleeve_tab_depth*1.5:0),
                active_z = (render_test_versions) ? 0 : render_as_separate_pieces ? 0 : (box_thickness + (in_secondary ? (row * row_stagger_height) : 0)),
                active_x = (render_test_versions) ? box_side_thickness : render_as_separate_pieces ? box_side_thickness : (box_x_offset + box_side_thickness)
            ) {
                translate([active_x, active_y, active_z]) {
                    difference() {
                        color(c = [(row / num_rows), (row / num_rows), 0.8], alpha = (render_as_separate_pieces) ? 1.0 : 1.0 - (row / num_rows))
                            SleeveRow();
                        if (render_test_versions) {
                            translate([-base_sleeve_row_width / 2, -sleeve_outer_depth / 2, -object_window_height - max(sleeve_thickness * 2, sleeve_label_height)]) 
                                cube([base_sleeve_row_width * 2, sleeve_outer_depth * 2, sleeve_outer_height]);
                            translate([-base_sleeve_row_width / 2, -sleeve_outer_depth / 2, sleeve_outer_height - object_window_height + sleeve_thickness]) 
                                cube([base_sleeve_row_width * 2, sleeve_outer_depth * 2, sleeve_outer_height]);
                        }
                    }
                }
            }
        }
    }
}

if (render_sleeve_label && sleeve_label_height > 0) {
    if (render_as_separate_pieces || render_test_versions) {
        color("red") translate([box_side_thickness + sleeve_thickness + sleeve_clearance, -sleeve_tab_width - sleeve_label_size, 0]) 
            SnapFitLabel();
    } else {
        color("red") translate([box_side_thickness + sleeve_thickness + sleeve_inner_width, box_thickness + front_sleeve_row_inset + sleeve_clearance, box_thickness + sleeve_outer_height - object_window_height - sleeve_label_height])
            rotate([-90, 180, 0])
            SnapFitLabel();
    }
}

if (render_box) {
    if (render_test_versions) {
        translate([box_x_offset, 0, -box_outer_height + box_radius + lid_rail_height]) {
            difference() {
                StorageBox();
                translate([-box_outer_width / 2, -box_outer_depth / 2, -box_radius - lid_rail_height]) 
                    cube([box_outer_width * 2, box_outer_depth * 2, box_outer_height]);
            }
        }
    } else {
        translate([box_x_offset, 0, 0]) StorageBox();
    }
}

if (!enable_void_box && render_lid) {
    if (render_test_versions) {
        translate([-box_thickness * 4, 0, box_thickness]) {
            rotate([0, 180, 0]) {
                difference() {
                    color("purple") SlideOnLid();
                    color("orange") translate([-box_outer_width / 2, -box_outer_depth / 2, -lid_rail_height - box_thickness - box_outer_height]) 
                        cube([box_outer_width * 2, box_outer_depth * 2, box_outer_height]);
                }
            }
                
        }
    } else if (render_as_separate_pieces) {
        translate([-box_thickness * 4, 0, box_thickness]) 
            rotate([0, 180, 0])
            SlideOnLid();
    } else {
        translate([box_x_offset, 0, box_outer_height]) 
            color("yellow", 0.4) SlideOnLid();
    }
}
