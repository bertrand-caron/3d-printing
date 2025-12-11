// Shoe Holder Design
// - Hollow rectangular cylinder: 200mm x 100mm x 70mm
// - Wall thickness: 4mm
// - Sliding hole for screw: 5mm diameter expanding to 2mm shank hole

$fn = 64; // smoother circles globally

// Parameters
outer_length = 200;
outer_width = 50;
outer_radius =  25;

total_length = outer_length + 2 * outer_radius;

outer_height = 70;
wall_thickness = 4.0;
bridge_width = 35;

// Screw hole parameters
screw_head_diameter = 5;
screw_shank_diameter = 2;
hole_depth = wall_thickness + 1; // Extra depth for sliding


module body_outside() {
    union() {
        translate([-outer_length / 2, 0, -outer_height/2]) cylinder(h=outer_height, r=outer_radius);
        translate([outer_length / 2, 0, -outer_height/2]) cylinder(h=outer_height, r=outer_radius);
        cube([outer_length, outer_width, outer_height], center = true);
    }
}

module body_inside() {
    union() {
        translate([-outer_length / 2, 0, -outer_height/2]) cylinder(h=outer_height, r=outer_radius - wall_thickness / 2);
        translate([outer_length / 2, 0, -outer_height/2]) cylinder(h=outer_height, r=outer_radius  - wall_thickness / 2);
        cube([outer_length, outer_width - wall_thickness, outer_height], center = true);
    }
}

module bridge() {
    translate([0, 0, -outer_height/2 + wall_thickness / 2]) cube([bridge_width, outer_width, wall_thickness], center=true);
}

module body() {
    union() {
        difference() {
            body_outside();
            body_inside();
        }
        bridge();
    }
}

module screw_hole(head_diameter, shank_diameter, offset) {
    union() {
        // use diameter parameter for circle; add missing semicolon
        circle(d=head_diameter);
        translate([offset, 0]) circle(d=shank_diameter);
        // Bridge the gap with a cube
        translate([0, -shank_diameter / 2]) square([offset, shank_diameter]);
    }
}

module Z_screw_hole() {
    rotate([0, -90, 90]) linear_extrude(outer_width) {
        screw_hole(9, 4, 10);
    };
}

difference() {
    body();
    color([0, 1, 0]) union() {
        translate([-outer_length / 4, 0, 0]) Z_screw_hole();
        translate([outer_length / 4, 0, 0]) Z_screw_hole();
    };
}
