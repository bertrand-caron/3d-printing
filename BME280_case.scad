case_inside_length = 30.0; // mm
case_inside_width = 20.0; // mm
case_inside_height = 10.0; // mm

case_wall_width = 2.0; // mm
case_bottom_height = 1.0; // mm

pillars_width = 4; //mm

case_outside_length = case_inside_length + case_wall_width;
case_outside_width = case_inside_width + case_wall_width;
case_outside_height = case_inside_height + case_wall_width;

screw_internal_diameter = 1.5; // mm
screw_hole_depth = 5; // mm
screw_head_diameter = 3.0; // mm
screw_head_depth = 2.0; // mm

module case_inside(){
    cube([case_inside_length, case_inside_width, case_inside_height], center=true);
};

module case_outside(){
    cube([case_outside_length, case_outside_width, case_outside_height], center=true);
};

module pillar(){  
    difference(){
        cube([pillars_width, pillars_width, case_outside_height], center=true);
        color("red") translate([0, 0, screw_hole_depth / 2]) cylinder(r=screw_internal_diameter / 2, h=screw_hole_depth, center=true);
    };
};

module screw_head(){
    cylinder(r=screw_head_diameter/ 2, h=screw_head_depth, center=true);
}

breathing_hole_diameter = 1.5; // mm
breathing_hole_angle = 45; // deg, to Z

module breathing_holes(){
    for (delta_y=[-case_inside_width / 4, 0, case_inside_width / 4], x_sign=[-1, +1]){
        translate([x_sign * case_outside_length / 2, delta_y, case_inside_height / 10]) rotate([0, - x_sign * breathing_hole_angle, 0]) cylinder(r=breathing_hole_diameter / 2, h=10, center=true);
    };
}

module corner_pillars(){
    for (x_sign=[-1, +1], y_sign=[-1, +1]){
        translate([x_sign * (case_inside_length / 2 - case_wall_width), y_sign * (case_inside_width / 2 - case_wall_width), 0]){
            pillar();
        };
    };
}

module screw_heads(){
    for (x_sign=[-1, +1], y_sign=[-1, +1]){
        translate([x_sign * (case_inside_length / 2 - case_wall_width), y_sign * (case_inside_width / 2 - case_wall_width), case_outside_height / 2]){
            screw_head();
        };
    };
};

module full_case(){
    difference(){
        union(){
            difference(){
                case_outside();
                case_inside();
            };
            corner_pillars();
        };
        screw_heads();
        breathing_holes();
    };
};

module top_half_case(){
    intersection(){
        full_case();
        translate([0, 0, 100 / 2]) cube([100, 100, 100], center=true);
    };
};

module bottom_half_case(){
    intersection(){
        full_case();
        translate([0, 0, -100 / 2]) cube([100, 100, 100], center=true);
    };
};

$fa = 0.1;
$fs = 0.1;

union(){
    translate([0, 0, 20]) top_half_case();
    translate([0, 0, -20]) bottom_half_case();
};