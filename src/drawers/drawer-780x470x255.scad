// These are the usable inner dimension of the drawer.
function drawer_inner_depth() = 471; // millimeters
function drawer_inner_width() = 780;
function drawer_inner_front_height() = 255;
function drawer_inner_back_height() = 160;
function drawer_inner_height() = max(drawer_inner_front_height(), drawer_inner_back_height());

function drawer_side_wall_thickness() = 15; // Does not matter in regards to usable space

module drawer_bottom() {
    width = drawer_inner_width() + 2* drawer_side_wall_thickness();
    height = drawer_side_wall_thickness();
    depth = drawer_inner_depth() + 2* drawer_side_wall_thickness();

    // make the innner space of the drawer aligned with coordinates [0,0,0]
    offset_x = -drawer_side_wall_thickness();
    offset_y = -drawer_side_wall_thickness();
    offset_z = -drawer_side_wall_thickness();

    translate([offset_x, offset_y, offset_z]) cube([width, depth, height]);
}

module drawer_front() {
    width = drawer_inner_width() + 2* drawer_side_wall_thickness();
    height = drawer_inner_height();
    depth = drawer_side_wall_thickness();

    offset_x = -drawer_side_wall_thickness();
    offset_y = -drawer_side_wall_thickness();
    offset_z = -drawer_side_wall_thickness();

    handle_width = 160;
    handle_depth = 20;
    handle_height = 20;

    // make the innner space of the drawer aligned with coordinates [0,0,0]
    handle_offset_x = offset_x + width / 2 - handle_width / 2;
    handle_offset_y = offset_y - handle_depth;
    handle_offset_z = offset_z + height / 2 - handle_height / 2;

    union() {
        // front panel
        translate([offset_x, offset_y, offset_z]) cube([width, depth, height]);
        translate([handle_offset_x, handle_offset_y, handle_offset_z]) {
            cube([handle_width, handle_depth, handle_height]);
        }
    }
}

module drawer_side(s = "left") {
    width = drawer_side_wall_thickness();
    height = drawer_inner_height();
    depth = drawer_inner_depth() + 2* drawer_side_wall_thickness();

    offset_y = -drawer_side_wall_thickness();
    offset_z = -drawer_side_wall_thickness();
    if (s == "right") {
        offset_x = drawer_inner_width() + drawer_side_wall_thickness();
        translate([offset_x, offset_y, offset_z]) cube([width, depth, height]);
    } else {
        offset_x = -drawer_side_wall_thickness();
        translate([offset_x, offset_y, offset_z]) cube([width, depth, height]);
    }
}

module drawer_bottom_side_intrusion_left() {
    rotate([0, -90, -90])
    linear_extrude(drawer_inner_depth())
    polygon([
        // it is a bit tricky because of the rotation
        [0, 0],
        [drawer_bottom_side_intrusion_height(), 0],
        [0, drawer_bottom_side_intrusion_width()],
    ]);
}

module drawer_bottom_side_intrusion_right() {
    translate([drawer_inner_width() + drawer_side_wall_thickness(), 0, 0])
    mirror([1, 0, 0])
    drawer_bottom_side_intrusion_left();
}



module drawer_back() {
    width = drawer_inner_width() + 2* drawer_side_wall_thickness();
    height = drawer_inner_back_height();
    depth = drawer_side_wall_thickness();

    offset_x = -drawer_side_wall_thickness();
    offset_y = drawer_inner_depth();
    offset_z = -drawer_side_wall_thickness();

    translate([offset_x, offset_y, offset_z]) cube([width, depth, height]);
}

module drawer() {
    union() {
        drawer_bottom();
        drawer_front();
        drawer_side(s = "left");
        drawer_side(s = "right");
        drawer_bottom_side_intrusion_left();
        drawer_bottom_side_intrusion_right();
        drawer_back();
    }
}

drawer();
