use <organizer-drawer_780x470x255-jar_99x48.scad>;
use <../jars/jar-rectangular-99x48.scad>;

function console_shaft_arm_thickness() = vertical_console_slot_depth();
function console_shaft_arm_width() = vertical_console_shaft_diameter() + vertical_console_shaft_minimum_clearance() - 2;
function console_shaft_arm_diagonal() = sqrt(pow(console_shaft_arm_width(), 2) * 2);
function console_shaft_arm_offset_y() = console_shaft_arm_diagonal();
function console_shaft_arm_center_offset_x() = console_shaft_arm_diagonal() - console_shaft_arm_width() / 2;

function console_shaft_minimum_height() = console_shaft_arm_offset_y();

module console_shaft_arm(rx = 0) {
    diagonal = console_shaft_arm_diagonal();
    half_diagonal = console_shaft_arm_diagonal() / 2;

    rotate([rx, 0, 0])
    translate([console_shaft_arm_thickness(), 0, 0])
    rotate([-90, 0, 90])
    linear_extrude(console_shaft_arm_thickness()) {
        difference() {
            union() {
                hull() {
                    circle(console_shaft_arm_width() / 2);
                    translate([diagonal / 2, 0])
                        rotate(45)
                            square([console_shaft_arm_width(), console_shaft_arm_width()]);
                }
                translate([diagonal - console_shaft_arm_width(), half_diagonal]) square([console_shaft_arm_width(), half_diagonal]);
            }

            circle(d = vertical_console_shaft_diameter());
        }
    }
}

function column_thickness() = console_shaft_arm_width();
function column_end_thickness() = column_thickness() - 3;
function column_end_height() = 5;

module column(
    h = 30,
    rx = 0
) {
    h = h - column_end_height();

    end_offset_x = (column_thickness() - column_end_thickness()) / 2;
    end_offset_y = end_offset_x;
    translate([0, column_thickness(), 0]) rotate([rx, 180, 180])
    union() {
        cube([column_thickness(), column_thickness(), h]);
        translate([end_offset_x, end_offset_y, h]) cube([column_end_thickness(), column_end_thickness(), column_end_height()]);
    }
}

module pair_of_columns(
    h = 30,
    rx = 0,
    side_a_offset_x = 0,
    side_b_offset_x = 0,
    offset_y = 0,
    offset_z = 0,
) {

    echo("side_a_offset_x = ", side_a_offset_x);
    union() {
        translate([side_a_offset_x, offset_y, offset_z]) column(h = h, rx = rx);
        translate([side_b_offset_x, offset_y, offset_z]) column(h = h, rx = rx);
    }
}

module base_plate(
    rx = 0
) {
    linear_extrude(column_end_height())
    union() {

    }
}

module console(
    h = 0, // height
    rx = 0, // rotate x
) {
    base_foot_length = organizer_width();

    side_a_offset_x = - side_wall_minimum_thickness();
    side_b_offset_x = organizer_width() - vertical_console_slot_depth() + side_a_offset_x;
    side_b_column_offset_x = side_b_offset_x - column_thickness() + console_shaft_arm_thickness();

    row_1_offset_y = organizer_width() - vertical_console_shaft_diameter() / 2 - side_wall_minimum_thickness() - vertical_console_shaft_distance_from_edge();
    row_1_offset_z = vertical_console_row_1_slot_offset_z() - foot_wall_minimum_thickness();
    row_1_column_height = h;

    column_offset_constant = 6.55; // FIXME: calculate this

    row_1_column_offset_y = row_1_offset_y + column_offset_constant;
    row_1_column_offset_z = row_1_offset_z;

    row_2_offset_y = row_1_offset_y;

    row_2_column_offset_y = row_2_offset_y + column_offset_constant;
    row_2_offset_z = vertical_console_row_2_slot_offset_z() - foot_wall_minimum_thickness();
    row_2_column_offset_z = row_2_offset_z;
    row_2_column_height = h + (row_2_column_offset_z - row_1_column_offset_z) * cos(rx);

    translate([side_a_offset_x, row_1_offset_y, row_1_offset_z]) console_shaft_arm(rx = rx);
    translate([side_b_offset_x, row_1_offset_y, row_1_offset_z]) console_shaft_arm(rx = rx);

    pair_of_columns(h = row_1_column_height, rx = rx, side_a_offset_x = side_a_offset_x, side_b_offset_x = side_b_column_offset_x, offset_y = row_1_column_offset_y, offset_z = row_1_column_offset_z);

    translate([side_a_offset_x, row_2_offset_y, row_2_offset_z]) console_shaft_arm(rx = rx);
    translate([side_b_offset_x, row_2_offset_y, row_2_offset_z]) console_shaft_arm(rx = rx);

    pair_of_columns(h = row_2_column_height, rx = rx, side_a_offset_x = side_a_offset_x, side_b_offset_x = side_b_column_offset_x, offset_y = row_2_column_offset_y, offset_z = row_2_column_offset_z);
}

rotate = 39;
rotate([-rotate, 0, 0]) {
%organizer();
console(h = 10, rx = 39);
}
