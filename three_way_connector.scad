rod_diameter = 12; // mm
wall_width = 2; // mm
connector_length = 30; // mm
connector_depth = 5; // mm
rod_length = 50; // mm

assert(connector_depth < connector_length);

x_y_angle = 60; // deg
x_z_angle = 60; // deg

gusset_width = 1; // mm
gusset_length_factor = 0.75; // percent

outer_radius = rod_diameter / 2 + wall_width;
rod_protruding_distance = connector_length - outer_radius;
rod_plus_cylinder_depth = connector_length - rod_protruding_distance;
gusset_length = rod_protruding_distance * gusset_length_factor;


module x_y_gusset(){
//    translate([wall_width, - connector_length, -gusset_width / 2]){
//        cube([connector_length - wall_width, connector_length - wall_width, gusset_width]);
//    };
    translate([rod_plus_cylinder_depth, -rod_plus_cylinder_depth, 0]){
        polygon(
            points=[
                [0, 0],
                [0, -gusset_length],
                [gusset_length * sin(x_y_angle), -gusset_length * cos(x_y_angle)],
            ]
        );
    };
};

module x_z_gusset(){
//    translate([wall_width, - connector_length, -gusset_width / 2]){
//        cube([connector_length - wall_width, connector_length - wall_width, gusset_width]);
//    };
    translate([0, -rod_plus_cylinder_depth, rod_plus_cylinder_depth]){
        rotate([0, -90, 0]){
            polygon(
                points=[
                    [0, 0],
                    [0, -gusset_length],
                    [gusset_length * sin(x_z_angle), -gusset_length * cos(x_z_angle)],
                ]
            );
        };
    };
};

module y_z_gusset(){
    translate([0, 0, 0]){
        rotate([0, 0, x_y_angle]){
            x_z_gusset();
        };
    };
}

module all_gussets(){
    union(){
        x_y_gusset();
        x_z_gusset();
        y_z_gusset();
    };
};

module full_model(){
    union(){
        color("blue", alpha=0.3){
            rotate([90 - x_z_angle, 0, 0]){cylinder(r=wall_width + rod_diameter / 2, h=connector_length);}; // Z rod
            rotate([90 - x_y_angle, 90, 0]){cylinder(r=wall_width + rod_diameter / 2, h=connector_length);}; // XY rod
            rotate([90, 0, 0]){cylinder(r=wall_width + rod_diameter / 2, h=connector_length);}; // X rod
            sphere(r=outer_radius);
        };
    };
    all_gussets();
}

module all_rods(){
    union(){
        color("red", alpha=0.3){
            translate([0, -connector_depth * cos(x_z_angle), connector_depth * sin(x_z_angle)]){rotate([90 - x_z_angle, 0, 0]){cylinder(r=rod_diameter / 2, h=rod_length);};}; // Z rod
            translate([connector_depth * sin(x_y_angle), -connector_depth * cos(x_y_angle), 0]){rotate([90 - x_y_angle, 90, 0]){cylinder(r=rod_diameter / 2, h=rod_length);};}; // XY rod
            translate([0, 0, 0]){rotate([90, 0, 0]){cylinder(r=rod_diameter / 2, h=rod_length);};}; // X rod
        };
    };
};

$fa = 1.0;
$fs = 0.1;

difference(){
    full_model();
    all_rods();  
};