use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;
use <organizer-drawer_780x470x255-jar_99x48.scad>;


function rows() = 5;
function columns() = 5;

function overlap() = 18; // mm
function overlap_loose_fit() = 3;

function rotate_x() = -40;
function column_offset_y() = 0;
function column_offset_z() = 10;

module column() {
    for (i = [0:rows() - 1]) {
        offset_y = i * (organizer_width() + overlap_loose_fit());
        offset_z = i * (jar_height() - overlap());
        translate([0, offset_y, offset_z]) jar();
        if (i > 0) {
            color("red") translate([0, offset_y, offset_z]) organizer(ol = overlap(), lf = overlap_loose_fit(), fp = true);
        } else {
            color("green") translate([0, offset_y, offset_z]) organizer(ol = overlap());
        }
    }
}

module rotated_column() {
    translate([0, jar_width(), 0])
    rotate([rotate_x(), 0, 0]) translate([0, - organizer_width(), 0])column();
}

module sketch() {
    for (j = [0:columns() - 1]) {
        offset_x = j * organizer_width();
        translate([offset_x, column_offset_y(), column_offset_z()]) rotated_column();
    }
}

%drawer();
sketch();
