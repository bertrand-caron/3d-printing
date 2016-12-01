/* [Plates] */

thickness = 1.0; // mm
width = 10.0; // mm
total_length = 50.0; //mm

/* [Holes] */

hole_diameter = 5.0; // mm
hole_distances_from_center = [-20, -10, 0.0]; // [mm]

/* [Angle] */

bracket_angle = 35.0; // degrees

/* [Braces] */

bracing_thickness = 1.0; // mm
bracing_distances_from_corner = [15.0, 20.0]; // [mm]

/* [Advanced] */

$fa = 1.0;
$fs = 1.0;

module Semi_Rounded_Bracket(thickness, width, total_length, center_position=[0,0,0], orientation=[0,0,0])
{
    translate(center_position)
    rotate(orientation)
    {
        difference()
        {
            union()
            {
                cube([total_length - width, width, thickness], center=true);
                {
                    for (sign = [-1, +1])
                    translate([(total_length - total_length/2 - width/2)*sign, 0, 0])
                    {
                        if (sign == -1) cylinder(r=width/2, h=thickness, center=true);
                        if (sign == +1) cube([width, width, thickness], center=true);
                    };
                };
            };
            union()
            {   for (hole_distance_from_center = hole_distances_from_center)
                translate([hole_distance_from_center, 0, 0])
                {
                    cylinder(r=hole_diameter/2, h=thickness + 1.0, center=true);
                };
            }
        }
    }
}

module Brace(bracing_distance_from_corner)
{
    c = sqrt(2) * bracing_distance_from_corner * sqrt(1 - cos(bracket_angle/2));
    intersection()
    {
        translate([total_length/2 - bracing_distance_from_corner, -width/2, thickness/2])
        {
            rotate([0, bracket_angle/2, 0])
            {
                cube([bracing_thickness, width, 2 * c]);
            };
        };

        // These two cubes are used to trim the angled cube intersections
        translate([0,0,total_length/2])
        cube([total_length + thickness, width, total_length], center=true);

        d = total_length * (1 - cos(bracket_angle));
        e = total_length * (1 - sin(bracket_angle)); 

        rotate([0, bracket_angle,0])
        translate([-d/2, 0, -e/2])
        cube([total_length + thickness, width, total_length], center=true);
    }
}

union()
{
    Semi_Rounded_Bracket(thickness, width, total_length);
    Semi_Rounded_Bracket(thickness, width, total_length, center_position=[(total_length/2)*(1-cos(bracket_angle)), 0, (total_length/2)*sin(bracket_angle)], orientation=[0,bracket_angle,0]);
    union()
    {   for (bracing_distance_from_corner = bracing_distances_from_corner)
        Brace(bracing_distance_from_corner);
    }
}

