height = 1.0; // mm
width = 10.0; // mm
total_length = 50.0; //mm

hole_diameter = 5.0; // mm
hole_distances_from_center = [-20:10:0]; // mm

bracket_angle = 25.0; // degrees

bracing_thickness = 5.0; // mm

$fa = 1.0;
$fs = 1.0;

module Rounded_Bracket(height, width, total_length, center_position=[0,0,0], orientation=[0,0,0])
{   
    translate(center_position)
    rotate(orientation)
    {
        difference()
        {
            union()
            {
                cube([total_length - width, width, height], center=true);
                {
                    for (sign = [+1,-1])
                    translate([(total_length - total_length/2 - width/2)*sign, 0, 0])
                    {
                        cylinder(r=width/2, h=height, center=true);
                    };
                };
            };
            union()
            {   for (hole_distance_from_center = hole_distances_from_center)
                translate([hole_distance_from_center, 0, 0])
                {
                    cylinder(r=hole_diameter/2, h=height + 1.0, center=true);
                };
            }
        }
    }
}

union()
{
    Rounded_Bracket(height, width, total_length);
    Rounded_Bracket(height, width, total_length, center_position=[(total_length/2)*(1-cos(bracket_angle)), 0, (total_length/2)*sin(bracket_angle)], orientation=[0,bracket_angle,0]);
    translate([0, -width/2, 0]){cube([bracing_thickness, width, (total_length/2)*sin(bracket_angle)]);};
}