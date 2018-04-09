base_width = 34.0; // mm
base_length = 80.0; // mm
base_height = 7; // mm
bracket_wall_width = 4.0; // mm
bracket_height = 28.0; // mm
hole_diameter = 8; // mm
hole_centered = true;
hole_distance_to_wall = 10; // mm
hole_distance_to_bottom = 9; // mm

bracket_length = hole_diameter + 2 * hole_distance_to_wall; // mm
inter_hole_distance = 26.0; // mm
assert(base_width - 2 * bracket_wall_width >= inter_hole_distance);

leg_radius = 13.8; // mm
assert((bracket_height - hole_diameter) / 2 >= leg_radius);

bolt_distance = 34; // mm
assert(base_width <= bolt_distance);

$fa = 1.0;
$fs = 0.1;
difference(){
    union(){
        cube(size=[base_width, base_length, base_height], center=false);
        color("red"){
            union(){
                translate(v=[base_width - bracket_wall_width, 0, base_height]){
                    difference(){
                        cube(size=[bracket_wall_width, bracket_length, bracket_height], center=false);
                        translate([0, bracket_length / 2,bracket_height / 2]){rotate([0, 90, 0]){cylinder(r=hole_diameter / 2, h=bracket_wall_width);};};
                    };
                };
                translate(v=[0, 0, base_height]){
                    difference(){
                        cube(size=[bracket_wall_width, bracket_length, bracket_height], center=false);
                        translate([0, bracket_length / 2,bracket_height / 2]){rotate([0, 90, 0]){cylinder(r=hole_diameter / 2, h=bracket_wall_width);};};
                    };
                };
                //translate(v=[0, 0, base_height]){cube(size=[base_width, bracket_wall_width, bracket_height], center=false);};
            };
        };
    };
    translate([base_width / 2, base_length, base_height + bracket_height / 2]){rotate([90, 0, 0]){cylinder(r=inter_hole_distance / 2, h=base_length);};};
    translate([base_width / 2, bracket_length / 2, base_height + bracket_height / 2 - leg_radius]){cylinder(r=inter_hole_distance / 2, h=base_length);};
}