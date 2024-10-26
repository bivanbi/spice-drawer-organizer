use <organizer-drawer_780x470x255-jar_99x48.scad>;

function console_shaft_arm_thickness() = vertical_console_slot_depth();
function console_shaft_arm_width() = vertical_console_shaft_diameter() + vertical_console_shaft_minimum_clearance() - 2;
function console_shaft_arm_diagonal() = sqrt(pow(console_shaft_arm_width(), 2) * 2);
function console_shaft_arm_offset_y() = console_shaft_arm_diagonal();
function console_shaft_arm_center_offset_x() = console_shaft_arm_diagonal() - console_shaft_arm_width() / 2;

function console_shaft_minimum_height() = console_shaft_arm_offset_y();

module console_shaft_arm() {
    diagonal = console_shaft_arm_diagonal();
    half_diagonal = console_shaft_arm_diagonal() / 2;

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

console_shaft_arm();
