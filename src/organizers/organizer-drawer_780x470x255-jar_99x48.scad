use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;

function jar_rotate_x() = -40;
function elevation_factor() = 30;
function overlap_factor() = 0.95;
function offset_y() = 5;
function offet_z() = -11;

function side_wall_minimum_thickness() = 1;
function width() = jar_width() + side_wall_minimum_thickness() * 2;
function side_length() = jar_height() + side_wall_minimum_thickness();
function side_height() = jar_round_edge_radius();

module organizer_side() {
    linear_extrude(side_length())

    difference() {
        square([width(), side_height() + side_wall_minimum_thickness()]);
        translate([jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
        translate([jar_width() - jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
        translate([side_wall_minimum_thickness() + jar_round_edge_radius(), side_wall_minimum_thickness()]) square([jar_width() - 2 * jar_round_edge_radius(), side_height()]);
    }
}

module organizer_foot_first_row() {
    cube([width(), width(), side_wall_minimum_thickness()]);
}

module organizer() {
    translate([jar_width() + side_wall_minimum_thickness(), jar_width() + side_wall_minimum_thickness(), -side_wall_minimum_thickness()])
    rotate([0, 0, 180])
    union() {
        organizer_side();
        organizer_foot_first_row();
    }
}

organizer();
