use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;

function side_wall_minimum_thickness() = 2;
function foot_wall_minimum_thickness() = side_wall_minimum_thickness();
function organizer_width() = jar_width() + side_wall_minimum_thickness() * 2;
function side_length() = jar_height() + side_wall_minimum_thickness();
function side_height() = jar_round_edge_radius();

function row_attachment_slot_length() = 10;
function row_attachment_slot_width() = 2;
function row_attachment_slot_depth() = 3;
function row_attachment_distance_from_edge() = 2;

module row_attachment_slot() {
    diff_workaround = 0.1;

    offset_x = row_attachment_distance_from_edge();
    offset_y = - diff_workaround;
    offset_z = side_length() / 2 - row_attachment_slot_length() / 2;
    depth = row_attachment_slot_depth() + diff_workaround;

    translate([offset_x, offset_y, offset_z]) cube([row_attachment_slot_width(), depth, row_attachment_slot_length()]);

    other_side_offset_x = organizer_width() - row_attachment_distance_from_edge() - row_attachment_slot_width();
    translate([other_side_offset_x, offset_y, offset_z]) cube([row_attachment_slot_width(), depth, row_attachment_slot_length()]);
}

function row_attachment_pin_wall_thickness() = side_wall_minimum_thickness();
function row_attachment_pin_loose_fit() = 0.05;
function row_attachment_pin_width() = row_attachment_distance_from_edge() * 4 - row_attachment_pin_loose_fit();

module row_attachment_pin() {
    length = row_attachment_slot_length() - row_attachment_pin_loose_fit();
    depth = row_attachment_slot_depth() - row_attachment_pin_loose_fit();
    width = row_attachment_slot_width() - row_attachment_pin_loose_fit();

    linear_extrude(length) {
        union() {
            square([row_attachment_pin_width(), row_attachment_pin_wall_thickness()]);
            translate([0, - depth]) square([width, depth]);
            translate([row_attachment_pin_width() - width, - depth]) square([width, depth]);
        }
    }
}

// aligned with the actual organizer row attachment slot for easier previewing
module row_attachment_pin_aligned() {
    pin_offset_x = organizer_width() - row_attachment_pin_width() / 2 - side_wall_minimum_thickness();
    pin_offset_y = organizer_width() - row_attachment_pin_wall_thickness();
    pin_offset_z = side_length() / 2 - row_attachment_slot_length() / 2 - foot_wall_minimum_thickness();
    translate([pin_offset_x, pin_offset_y, pin_offset_z])
        row_attachment_pin();
}

function vertical_console_slot_depth() = 1;
function vertical_console_slot_diff_workaround() = 0.1;
function vertical_console_shaft_diameter() = 5;
function vertical_console_shaft_distance_from_edge() = 1;
function vertical_console_shaft_minimum_clearance() = 5;
function vertical_console_shaft_cutaway_radius() = vertical_console_shaft_distance_from_edge() + vertical_console_shaft_diameter() + vertical_console_shaft_minimum_clearance();

module vertical_console_cutaway() {
    shaft_offset_y = vertical_console_shaft_distance_from_edge() + vertical_console_shaft_diameter() / 2;
    diff_workaround = 0.1;

    rotate([0, 90, 0])
    linear_extrude(vertical_console_slot_depth() + diff_workaround)
    difference() {
        circle(r = vertical_console_shaft_cutaway_radius());
        translate([0, shaft_offset_y]) circle(d = vertical_console_shaft_diameter());
        translate([0, - vertical_console_shaft_cutaway_radius() - diff_workaround]) square(vertical_console_shaft_cutaway_radius() * 2, center = true);
    }
}

function column_attachment_slot_width() = 5;
function column_attachment_slot_depth() = 3;
function column_attachment_pin_loose_fit() = 0.05;
function vertical_console_cutaway_row_attachment_slont_clearance() = 2;

module organizer_side(ol = 0) {
    diff_workaround = 0.1;

    vertical_console_slot_offset_z = side_length() / 2 + vertical_console_shaft_cutaway_radius() + row_attachment_slot_length() / 2 + vertical_console_cutaway_row_attachment_slont_clearance();
    vertical_console_slot1_offset_x = - vertical_console_slot_diff_workaround();
    vertical_console_slot2_offset_x = organizer_width() - vertical_console_slot_depth();

    difference() {
        linear_extrude(side_length())
        difference() {
            square([organizer_width(), side_height() + side_wall_minimum_thickness()]);
            translate([jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
            translate([jar_width() - jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
            translate([side_wall_minimum_thickness() + jar_round_edge_radius(), side_wall_minimum_thickness()]) square([jar_width() - 2 * jar_round_edge_radius(), side_height()]);
        }

        if (ol > 0) {
            offset_z = side_length() - ol - foot_wall_minimum_thickness();
            translate([- diff_workaround, - diff_workaround, offset_z]) cube([column_attachment_slot_width() + diff_workaround, column_attachment_slot_depth() + diff_workaround, foot_wall_minimum_thickness()]);

            offset_x = organizer_width() - column_attachment_slot_width() + diff_workaround;
            translate([offset_x, - diff_workaround, offset_z]) cube([column_attachment_slot_width() + diff_workaround, column_attachment_slot_depth() + diff_workaround, foot_wall_minimum_thickness()]);
        }

        row_attachment_slot();
        translate([vertical_console_slot1_offset_x, 0, vertical_console_slot_offset_z]) vertical_console_cutaway();
        translate([vertical_console_slot2_offset_x, 0, vertical_console_slot_offset_z]) vertical_console_cutaway();
    }
}

module organizer_foot(lf = 0, ol = 0, fp = false) {
    pin_width = column_attachment_slot_width() - column_attachment_pin_loose_fit();
    pin_depth = column_attachment_slot_depth() - column_attachment_pin_loose_fit();
    pin_thickness = foot_wall_minimum_thickness() - column_attachment_pin_loose_fit();

    pin_offset_y = organizer_width() + lf;
    pin_offset_x = organizer_width() - pin_width;
    pin_offset_z = column_attachment_pin_loose_fit() / 2;

    union() {
        cube([organizer_width(), organizer_width() + lf, foot_wall_minimum_thickness()]);
        if (fp) {
            translate([0, pin_offset_y, pin_offset_z]) cube([pin_width, pin_depth, pin_thickness]);
            translate([pin_offset_x, pin_offset_y, pin_offset_z]) cube([pin_width, pin_depth, pin_thickness]);
        }
    }
}

module organizer(
    ol = 0, // overlap - used to determine where the foot of the next organizer will attach to the side of the current one
    lf = 0, // loose fit - distance between two organizers so it is easy to slide in jar into overlapping organizers
    fp = false, // add attachment pins to foot
) {
    translate([jar_width() + side_wall_minimum_thickness(), jar_width() + side_wall_minimum_thickness(), -side_wall_minimum_thickness()])
    rotate([0, 0, 180])
    difference() {
        union() {
            organizer_side(ol);
            organizer_foot(lf = lf, ol = ol, fp = fp);
        }
    }
}

organizer(lf = 3, ol = 18, fp = true);
