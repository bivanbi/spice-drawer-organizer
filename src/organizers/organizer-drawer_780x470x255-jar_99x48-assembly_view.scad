use <../drawers/drawer-780x470x255.scad>;
use <../jars/jar-rectangular-99x48.scad>;
use <organizer-drawer_780x470x255-jar_99x48.scad>;

module rotated_jar() {
    translate([0, 0, jar_width()])
    rotate([jar_rotate_x(), 0, 0]) jar();
}

module rotated_organizer() {
    rotate([jar_rotate_x(), 0, 0]) translate([0, -31,36])organizer();
}

module sketch() {
    %drawer();

    for (j = [0:4]) {
        offset_x = j * 50;
        for (i = [0:4]) {
            translate([offset_x, offset_y() + i * overlap_factor() * jar_height(), offet_z() + i * elevation_factor()]) rotated_jar();
            color("red") translate([offset_x, offset_y() + i * overlap_factor() * jar_height(), offet_z() + i * elevation_factor()]) rotated_organizer();
        }
    }
}

sketch();
