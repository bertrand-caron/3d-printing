rod_diameter = 12; // mm
wall_width = 2; // mm
connector_length = 30; // mm
connector_depth = 5; // mm
rod_length = 50; // mm

assert(connector_depth < connector_length);

x_y_angle = 75; // deg
x_z_angle = 60; // deg

gusset_width = 2.0; // mm
gusset_length_factor = 1.0; // percent

outer_radius = rod_diameter / 2 + wall_width;
rod_protruding_distance = connector_length - outer_radius;
rod_plus_cylinder_depth = connector_length - rod_protruding_distance;
gusset_length = rod_protruding_distance * gusset_length_factor;

module x_y_gusset(){
//    translate([wall_width, - connector_length, -gusset_width / 2]){
//        cube([connector_length - wall_width, connector_length - wall_width, gusset_width]);
//    };
    translate([rod_plus_cylinder_depth - wall_width, - (rod_plus_cylinder_depth - wall_width), -gusset_width / 2]){
        linear_extrude(height=gusset_width){
                polygon(
                points=[
                    [0, 0],
                    [0, -gusset_length],
                    [gusset_length * sin(x_y_angle), -gusset_length * cos(x_y_angle)],
                ]
            );
        };
    };
};

module x_z_gusset(){
    translate([gusset_width / 2, -(rod_plus_cylinder_depth - wall_width), (rod_plus_cylinder_depth - wall_width)]){
        rotate([0, -90, 0]){
            linear_extrude(height=gusset_width){
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
};

O = [0, 0, 0];
Y = [connector_length * sin(x_y_angle), -connector_length * cos(x_y_angle), 0];
Z = [0, -connector_length * cos(x_z_angle), connector_length * sin(x_z_angle)];
theta_y_z = acos(Y * Z / (norm(Y) * norm(Z)));

module y_z_gusset(){
    rotate([-0, 0, 0]){
        linear_extrude(height=gusset_width){
            polygon(
                points=[
                    [0, 0],
                    [0, -gusset_length],
                    [gusset_length * cos(theta_y_z), -gusset_length * sin(theta_y_z)],
                ]
            );
        };
    };
}

module y_z_gusset_(){
    Z_gusset = [0, -gusset_length * cos(x_z_angle), gusset_length * sin(x_z_angle)];
    Y_gusset = [gusset_length * sin(x_y_angle), -gusset_length * cos(x_y_angle), 0];
    
    gusset_normalised_vector = (Y / norm(Y) + Z / norm(Z));
    gusset_normal_vector = cross(Z_gusset, Y_gusset);
    gusset_U = gusset_normal_vector / norm(gusset_normal_vector);
    gusset_width_vector = gusset_U * gusset_width;
    
    length_correction_factor = cos(90 - theta_y_z);
    
    translate((rod_diameter / 2) * gusset_normalised_vector - (gusset_width / 2) * gusset_U){
        hull(){
            polyhedron(
                points=[
                    O,
                    Z_gusset * length_correction_factor,
                    Y_gusset * length_correction_factor,
                    O + gusset_width_vector,
                    Z_gusset * length_correction_factor + gusset_width_vector,
                    Y_gusset * length_correction_factor + gusset_width_vector,
                ],
                faces=[
                    [0, 1, 2],
                    [0, 1, 4, 3],
                    [3, 4, 5],
                    [0, 3, 5, 2],
                    [1, 4, 5, 2],
                ]
            );
        };
    };
};

module all_gussets(){
    union(){
        x_y_gusset();
        x_z_gusset();
        y_z_gusset_();
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
$fs = 0.5;

difference(){
    full_model();
    all_rods();  
};