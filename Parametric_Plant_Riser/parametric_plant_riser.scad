/* [Riser dimensions] */

RISER_HEIGHT = 10; // mm


/* [Riser circles] */

CIRCLE_DIAMETERS = [25, 50, 75, 100]; // mm
CIRCLE_WIDTH = 2; // mm

/* [Riser arms] */

ARM_ANGLES = [0, 120, 240]; // in degrees

BASE_WIDTH = 2; // mm
ARM_WIDTH = 2; // mm


$fa = 1.0;
$fs = 0.1;

module hollow_cyclinder (outer_d=0, inner_d=0, h=0) {
    difference() {
        cylinder(d=outer_d, h=h, center=true);
        cylinder(d=inner_d, h=h, center=true);
    }
}

// Recursive function to compute the maximum value of an array.
function maximum(a, i = 0) = (i < len(a) - 1) ? max(a[i], maximum(a, i +1)) : a[i];

ARM_LENGTH = maximum(CIRCLE_DIAMETERS) / 2;

module arm (angle_degree=0, h=0) {
    translate([ARM_LENGTH * sin(angle_degree) / 2, -ARM_LENGTH * cos(angle_degree) / 2]) {
        rotate([0, 0, angle_degree]) {
            cube([ARM_WIDTH, ARM_LENGTH, RISER_HEIGHT], center=true);
        }
    };
};

union() {
    for (d = CIRCLE_DIAMETERS) {
        hollow_cyclinder(outer_d=d, inner_d=d - 2 * CIRCLE_WIDTH, h=RISER_HEIGHT);
    };
    for (angle_degree = ARM_ANGLES) {
        arm(angle_degree=angle_degree, h=RISER_HEIGHT);
    }
};
