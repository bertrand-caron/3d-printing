base_width = 34.0; // mm
base_length = 80.0; // mm
base_height = 5; // mm
bracket_wall_width = 4.0; // mm
bracket_height = 28.0; // mm
bracket_triangular_brace_length = 25; // mm
hole_diameter = 8; // mm
hole_centered = true;
hole_distance_to_wall = 10; // mm
hole_distance_to_bottom = 9; // mm

bracket_length = hole_diameter + 2 * hole_distance_to_wall; // mm
inter_hole_distance = 26.0; // mm
assert(base_width - 2 * bracket_wall_width >= inter_hole_distance);

leg_length = 11.9 + hole_diameter / 2; // mm
assert((bracket_height - hole_diameter) / 2 >= leg_length);

bolt_distance = 34; // mm
assert(base_width <= bolt_distance);

module prism(l, w, h){
    mirror(v=[0, 1, 0]){
       polyhedron(
           points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
           faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
       );
    };
};

module bracket() {
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
                translate([0, bracket_length + bracket_triangular_brace_length, base_height]){prism(bracket_wall_width, bracket_triangular_brace_length, bracket_height);};
                translate(v=[0, 0, base_height]){
                    difference(){
                        cube(size=[bracket_wall_width, bracket_length, bracket_height], center=false);
                        translate([0, bracket_length / 2,bracket_height / 2]){rotate([0, 90, 0]){cylinder(r=hole_diameter / 2, h=bracket_wall_width);};};
                    };
                };
                translate([base_width - bracket_wall_width, bracket_length + bracket_triangular_brace_length, base_height]){prism(bracket_wall_width, bracket_triangular_brace_length, bracket_height);};
                //translate(v=[0, 0, base_height]){cube(size=[base_width, bracket_wall_width, bracket_height], center=false);};
            };
        };
    };
 };

module leg_at_angle(angle){
    translate([base_width / 2, bracket_length / 2, base_height + leg_length]){
        rotate([-angle, 0, 0]){
            translate([0, 0, -leg_length]){
                cylinder(r=inter_hole_distance / 2, h=base_length);
            };
        };
    };
};

module folded_leg(){
    leg_at_angle(90);
};

module extended_leg(){
    leg_at_angle(0);
};

$fa = 1.0;
$fs = 0.1;
union(){
    difference(){
        bracket();
        folded_leg();
        extended_leg();
    };
    //color("green"){folded_leg();};
    //color("orange"){extended_leg();};
    //color("grey"){leg_at_angle(45);};
    //color("grey"){leg_at_angle(0);};
    //color("grey"){leg_at_angle(30);};
    //color("grey"){leg_at_angle(60);};
    //color("grey"){leg_at_angle(90);};
};