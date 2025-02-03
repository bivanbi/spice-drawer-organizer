use <organizer-drawer_780x470x255-jar_99x48.scad>;

translate([side_wall_minimum_thickness(), foot_wall_minimum_thickness(), organizer_width() - side_wall_minimum_thickness()])
rotate([-90, 0, 0])
organizer(lf = 3, ol = 18, fp = false);
