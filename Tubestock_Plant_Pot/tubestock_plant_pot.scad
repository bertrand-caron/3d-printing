/* [Top and bottom dimensions (set to same value for no taper)] */

TOP_DIMENSION = 50; // in mm

BOTTOM_DIMENSION = 39; // in mm

/* [Total height] */

HEIGHT = 120; // in mm

/* [Wall thickness] */

WALL_THICKNESS = 0.4; // in mm

/* [Drainage holes] */

HOLE_DIAMETER = 5; // in mm

HOLE_SPACING = 10; // in mm

/* [Lip dimension (set to zero to disable)] */

LIP_DIMENSION = 0.4; // in mm

/* [Internal variables (do not touch)] */

EPSILON = 0.00001; // in mm

module tapered_cube(top_xy, bottom_xy, height) {
    translate([bottom_xy / 2, bottom_xy / 2, 0]) {
        linear_extrude(height=height, scale=top_xy / bottom_xy) square(bottom_xy, center=true);
    };
};

module lip() {
    translate([BOTTOM_DIMENSION / 2, BOTTOM_DIMENSION / 2, HEIGHT - LIP_DIMENSION / 2]) {
        difference(){
            cube([TOP_DIMENSION + 2 * LIP_DIMENSION, TOP_DIMENSION + 2 * LIP_DIMENSION, LIP_DIMENSION], center=true);
            cube([TOP_DIMENSION, TOP_DIMENSION, LIP_DIMENSION], center=true);
        };
    };    
}

difference() {
    color([1, 0, 0, 0.5]) union() {
        tapered_cube(TOP_DIMENSION, BOTTOM_DIMENSION, HEIGHT);
        // Lip
        lip();
    };
    color([0, 1, 0, 0.5]) union() {
        translate([WALL_THICKNESS, WALL_THICKNESS, WALL_THICKNESS]) {
            tapered_cube(TOP_DIMENSION - 2 * WALL_THICKNESS, BOTTOM_DIMENSION - 2 * WALL_THICKNESS, HEIGHT);
        };
        union() {
            for (i = [1:floor((BOTTOM_DIMENSION - EPSILON)/ HOLE_SPACING)])
                for (j = [1:floor((BOTTOM_DIMENSION - EPSILON)/ HOLE_SPACING)])
                    translate([i * HOLE_SPACING, j * HOLE_SPACING, 0])
                        cylinder(d=HOLE_DIAMETER, h=WALL_THICKNESS, $fs=0.5);
        };
    };
};
