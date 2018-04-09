base_width = 50.0; // mm
base_length = 100.0; // mm
base_height = 8; // mm
bracket_wall_width = 7; // mm
bracket_height = 40; // mm
bracket_length = 50; // mm
hole_diameter = 8; // mm
hole_centered = true;

$fa = 1.0;
$fs = 0.1;

union(){
    cube(size=[base_width, base_length, base_height], center=false);
    color("red"){
        union(){
            translate(v=[base_width - bracket_wall_width, 0, base_height]){
                difference(){
                    cube(size=[bracket_wall_width, bracket_length, bracket_height], center=false);
                    translate([0, bracket_length / 2,bracket_height / 2]){rotate([0, 90, 0]){cylinder(r=hole_diameter, h=bracket_wall_width);};};
                };
            };
            translate(v=[0, 0, base_height]){
                difference(){
                    cube(size=[bracket_wall_width, bracket_length, bracket_height], center=false);
                    translate([0, bracket_length / 2,bracket_height / 2]){rotate([0, 90, 0]){cylinder(r=hole_diameter, h=bracket_wall_width);};};
                };
            };
            translate(v=[0, 0, base_height]){cube(size=[base_width, bracket_wall_width, bracket_height], center=false);};
        };
    };
}
