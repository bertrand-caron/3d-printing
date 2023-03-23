/* [Riser circles] */

CIRCLE_DIAMETERS = [25, 50, 75, 100]; // mm
CIRCLE_WIDTH = 2; // mm
CIRCLE_HEIGHT = 12; // mm

/* [Riser arms] */

ARM_ANGLES = [0, 120, 240]; // in degrees
ARM_HEIGHT = 6; // mm

BASE_WIDTH = 2; // mm
ARM_WIDTH = 2; // mm

assert (CIRCLE_HEIGHT > ARM_HEIGHT, "Expected CIRCLE_HEIGHT to be strictly greater than ARM_HEIGHT");

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
            cube([ARM_WIDTH, ARM_LENGTH, h], center=true);
        }
    };
};

module notched_cylinder(d) {
    // Notch the cylinders above the arm to increase airflow
    difference() {
        hollow_cyclinder(outer_d=d, inner_d=d - 2 * CIRCLE_WIDTH, h=CIRCLE_HEIGHT);
        union() {
            for (angle_degree = ARM_ANGLES) {
                color([1, 0, 0, 0.5]) translate([0, 0, CIRCLE_HEIGHT - (CIRCLE_HEIGHT - ARM_HEIGHT)]) arm(angle_degree=angle_degree, h=CIRCLE_HEIGHT);
            }
        };
    };
};

union() {
    for (d = CIRCLE_DIAMETERS) {
        notched_cylinder(d);
    };
    for (angle_degree = ARM_ANGLES) {
        arm(angle_degree=angle_degree, h=ARM_HEIGHT);
    }
};
