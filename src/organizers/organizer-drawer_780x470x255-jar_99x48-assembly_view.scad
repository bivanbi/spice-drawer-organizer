use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;
use <organizer-drawer_780x470x255-jar_99x48.scad>;
use <organizer-drawer_780x470x255-jar_99x48-console.scad>;


function rows() = 5;
function columns() = 5;

function overlap() = 18; // mm
function overlap_loose_fit() = 3;

function rotate_x() = -38;
function column_offset_y() = -4;
function column_offset_z() = 7;

function alternating_color_green(n) = n % 2 == 0 ? "green" : "lightgreen";
function alternating_color_blue(n) = n % 2 == 0 ? "blue" : "lightblue";
function alternating_color_red(n) = n % 2 == 0 ? "red" : "darkred";

column_lenght = side_length() - overlap() + foot_wall_minimum_thickness();
column_elevation = organizer_width();
column_angle = 33; // FIXME: calculate this

echo("Column lenght: ", column_lenght);
echo("Column elevation: ", column_elevation);
echo("Column angle: ", column_angle);

module column(n = 0) {
    for (i = [0:rows() - 1]) {
        offset_y = i * (organizer_width() + overlap_loose_fit());
        offset_z = i * (jar_height() - overlap());
        column_h = (column_offset_z() + offset_y * sin(column_angle));

        translate([0, offset_y, offset_z]) jar();
        if (i > 0) {
            color(alternating_color_red(n)) translate([0, offset_y, offset_z]) organizer(ol = overlap(), lf = overlap_loose_fit(), fp = true);
        } else {
            color(alternating_color_green(n)) translate([0, offset_y, offset_z]) organizer(ol = overlap());
        }
        color(alternating_color_blue(n)) translate([0, offset_y, offset_z]) row_attachment_pin_aligned();
        color(alternating_color_blue(n)) translate([0,offset_y, offset_z]) console(h = column_h, rx = - rotate_x());
    }
}

module rotated_column(n = 0) {
    translate([0, jar_width(), 0])
    rotate([rotate_x(), 0, 0]) translate([0, - organizer_width(), 0]) column(n);
}

module sketch() {
    for (j = [0:columns() - 1]) {
        offset_x = j * organizer_width();
        translate([offset_x, column_offset_y(), column_offset_z()]) rotated_column(j);
    }
}

%drawer();
sketch();
