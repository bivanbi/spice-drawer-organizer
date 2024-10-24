function jar_height() = 99; // millimeters
function jar_width() = 48;
function jar_round_edge_radius() = 12;

module jar() {
    linear_extrude(height = jar_height())
    hull() {
        translate([jar_round_edge_radius(), jar_round_edge_radius()]) circle(r = jar_round_edge_radius());
        translate([jar_width() - jar_round_edge_radius(), jar_round_edge_radius()]) circle(r = jar_round_edge_radius());
        translate([jar_width() - jar_round_edge_radius(), jar_width() - jar_round_edge_radius()]) circle(r = jar_round_edge_radius());
        translate([jar_round_edge_radius(), jar_width() - jar_round_edge_radius()]) circle(r = jar_round_edge_radius());
    }
}

jar();