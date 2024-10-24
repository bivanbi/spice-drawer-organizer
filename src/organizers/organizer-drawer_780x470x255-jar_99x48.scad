use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;

function side_wall_minimum_thickness() = 1;
function foot_wall_minimum_thickness() = side_wall_minimum_thickness();
function organizer_width() = jar_width() + side_wall_minimum_thickness() * 2;
function side_length() = jar_height() + side_wall_minimum_thickness();
function side_height() = jar_round_edge_radius();

function side_attachment_slot_width() = 5;
function side_attachment_slot_depth() = 3;

module organizer_side(ol = 0) {
    difference() {
        linear_extrude(side_length())
        difference() {
            square([organizer_width(), side_height() + side_wall_minimum_thickness()]);
            translate([jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
            translate([jar_width() - jar_round_edge_radius() + side_wall_minimum_thickness(), jar_round_edge_radius() + side_wall_minimum_thickness()])circle(jar_round_edge_radius());
            translate([side_wall_minimum_thickness() + jar_round_edge_radius(), side_wall_minimum_thickness()]) square([jar_width() - 2 * jar_round_edge_radius(), side_height()]);
        }

        if (ol > 0) {
            translate([0, 0, ol]) cube([side_attachment_slot_width(), side_attachment_slot_depth(), foot_wall_minimum_thickness()]);
            translate([organizer_width() - side_attachment_slot_width(), 0, ol]) cube([side_attachment_slot_width(), side_attachment_slot_depth(), foot_wall_minimum_thickness()]);
        }
    }
}

module organizer_foot(lf = 0, ol = 0) {
    attachmen_slot_offset_y = organizer_width() + lf;
    attachmen_slot_offset_x = organizer_width() - side_attachment_slot_width();
    union() {
        %cube([organizer_width(), organizer_width() + lf, foot_wall_minimum_thickness()]);
        if (ol > 0) {
            translate([0, attachmen_slot_offset_y, 0]) cube([side_attachment_slot_width(), side_attachment_slot_depth(), foot_wall_minimum_thickness()]);
            translate([attachmen_slot_offset_x, attachmen_slot_offset_y, 0]) cube([side_attachment_slot_width(), side_attachment_slot_depth(), foot_wall_minimum_thickness()]);
        }
    }
}

module organizer(
    ol = 0, // overlap - used to determine where the foot of the next organizer will attach to the side of the current one
    lf = 0, // loose fit - distance between two organizers so it is easy to slide in jar into overlapping organizers
) {
    translate([jar_width() + side_wall_minimum_thickness(), jar_width() + side_wall_minimum_thickness(), -side_wall_minimum_thickness()])
    rotate([0, 0, 180])
    difference() {
        union() {
            organizer_side(ol);
            organizer_foot(lf = lf, ol = ol);
        }
    }
}

organizer(lf = 5, ol = 15);

