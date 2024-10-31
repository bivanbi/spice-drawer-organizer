use <organizer-drawer_780x470x255-jar_99x48.scad>;
use <../jars/jar-rectangular-99x48.scad>;

function console_shaft_arm_thickness() = vertical_console_slot_depth();
function console_shaft_arm_width() = vertical_console_shaft_diameter() + vertical_console_shaft_minimum_clearance() - 2;
function console_shaft_arm_diagonal() = sqrt(pow(console_shaft_arm_width(), 2) * 2);
function console_shaft_arm_offset_y() = console_shaft_arm_diagonal();
function console_shaft_arm_center_offset_x() = console_shaft_arm_diagonal() - console_shaft_arm_width() / 2;

function console_shaft_minimum_height() = console_shaft_arm_offset_y();
function console_shaft_loose_fit_diameter() = vertical_console_shaft_diameter() + 0.2;

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

            circle(d = console_shaft_loose_fit_diameter());
        }
    }
}

function column_thickness() = console_shaft_arm_width();
function column_end_thickness() = column_thickness() - 3;
function column_end_height() = 5;

module console_column(
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

function crosslink_thickness() = column_thickness();

module pair_of_columns_crosslink(
    h = 30,
    rx = 0,
    side_a_offset_x = 0,
    side_b_offset_x = 0,
    offset_y = 0,
    offset_z = 0,
) {
    x = organizer_width();
    h = h - column_end_height();

    echo("x = ", x);
    echo("h = ", h);

    translate([0, column_thickness(), 0]) rotate([rx, 180, 180]) {
        if (h <= column_thickness()) {
            echo("h <= column_thickness()");
            cube([x, crosslink_thickness(), h]);
        } else {
            color("red") translate([0, crosslink_thickness(), 0]) rotate([90, 0, 0])
            linear_extrude(crosslink_thickness()) {
                polygon(points=[[0, 0], [0, column_thickness()],  [x, h], [x, h - column_thickness()]]);
                polygon(points=[[0, h], [0, h - column_thickness()],  [x, 0], [x, column_thickness()]]);
            }
        }
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
    union() {
        translate([side_a_offset_x, offset_y, offset_z]) console_column(h = h, rx = rx);
        translate([side_b_offset_x, offset_y, offset_z]) console_column(h = h, rx = rx);
        translate([side_a_offset_x, offset_y, offset_z]) pair_of_columns_crosslink(h = h, rx = rx);
    }
}

module foot() {
    thickness = (column_thickness() - column_end_thickness()) / 2;
    union() {
        linear_extrude(column_end_height()) {
            translate([0, 0]) square([thickness, column_thickness()]);
            translate([column_end_thickness() + thickness, 0]) square([thickness, column_thickness()]);
            translate([0, 0]) square([column_thickness(), thickness]);
            translate([0, column_end_thickness() + thickness, 0]) square([column_thickness(), thickness]);
        }
    }
}

function base_plate_crossling_thickness() = 2;

module base_plate() {
    side_a_offset_x = - side_wall_minimum_thickness();
    side_b_offset_x = organizer_width() - vertical_console_slot_depth() + side_a_offset_x;
    side_b_column_offset_x = side_b_offset_x - column_thickness() + console_shaft_arm_thickness();

    row_1_offset_y = 46.37; // TODO calculate this
    offset_z = -40; // TODO calculate this

    translate([side_a_offset_x, row_1_offset_y, offset_z]) foot();
    translate([side_b_column_offset_x, row_1_offset_y, offset_z]) foot();

    row_2_offset_y = 81.3; // TODO calculate this

    union() {
        translate([side_a_offset_x, row_2_offset_y, offset_z]) foot();
        translate([side_b_column_offset_x, row_2_offset_y, offset_z]) foot();
        translate([side_a_offset_x, row_1_offset_y, offset_z]) {
        linear_extrude(base_plate_crossling_thickness())
            polygon(points = [
                    [column_thickness(), 0],
                    [column_thickness(), column_thickness()],
                    [organizer_width() - column_thickness(), row_2_offset_y - row_1_offset_y + column_thickness()],
                    [organizer_width() - column_thickness(), row_2_offset_y - row_1_offset_y],
                ]);

        linear_extrude(base_plate_crossling_thickness())
            polygon(points = [
                    [column_thickness(), row_2_offset_y - row_1_offset_y],
                    [column_thickness(), column_thickness() + row_2_offset_y - row_1_offset_y],
                    [organizer_width() - column_thickness(), column_thickness()],
                    [organizer_width() - column_thickness(), 0],
            ]);

        linear_extrude(base_plate_crossling_thickness())
            polygon(points = [
                    [0, column_thickness()],
                    [0, row_2_offset_y - row_1_offset_y],
                    [column_thickness(), row_2_offset_y - row_1_offset_y],
                    [column_thickness(), column_thickness()],
            ]);

        linear_extrude(base_plate_crossling_thickness())
            polygon(points = [
                    [organizer_width() - column_thickness(), column_thickness()],
                    [organizer_width() - column_thickness(), row_2_offset_y - row_1_offset_y],
                    [organizer_width(), row_2_offset_y - row_1_offset_y],
                    [organizer_width(), column_thickness()],
            ]);
        }
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

    translate([side_a_offset_x, row_2_offset_y, row_2_offset_z]) console_shaft_arm(rx = rx);
    translate([side_b_offset_x, row_2_offset_y, row_2_offset_z]) console_shaft_arm(rx = rx);

    pair_of_columns(h = row_1_column_height, rx = rx, side_a_offset_x = side_a_offset_x, side_b_offset_x = side_b_column_offset_x, offset_y = row_1_column_offset_y, offset_z = row_1_column_offset_z);
    pair_of_columns(h = row_2_column_height, rx = rx, side_a_offset_x = side_a_offset_x, side_b_offset_x = side_b_column_offset_x, offset_y = row_2_column_offset_y, offset_z = row_2_column_offset_z);
}

rotate = 39;
rotate([-rotate, 0, 0]) {
%organizer();
console(h = 10, rx = 39);
}
color("grey") base_plate();
