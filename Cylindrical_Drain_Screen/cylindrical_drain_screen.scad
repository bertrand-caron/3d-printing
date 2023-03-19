/* [Grate dimensions] */

GRATE_WIDTH = 1; //mm
GRATE_SPACING = 2.5; // mm

/* [Drain dimensions] */

DRAIN_HEIGHT = 2; // mm
DRAIN_DIAMETER = 75; // mm

module grate_x(x=0) {
    translate([0, x, 0]) {
        cube([DRAIN_DIAMETER + GRATE_WIDTH, GRATE_WIDTH, DRAIN_HEIGHT], center=true);
    };
}

module grate_y(y=0) {
    translate([y, 0, 0]) {
        color([0,1,1])
        cube([GRATE_WIDTH, DRAIN_DIAMETER + GRATE_WIDTH, DRAIN_HEIGHT], center=true);
    };
}

GRATE_NUMBER = ceil(DRAIN_DIAMETER / GRATE_SPACING);

$fa = 1.0;
$fs = 0.1;

intersection() {
    union() {
        union() {
            for (i = [-GRATE_NUMBER/2: GRATE_NUMBER/2])
                grate_x(i * GRATE_SPACING);
        };
        union() {
            for (i = [-GRATE_NUMBER/2: GRATE_NUMBER/2])
                grate_y(i * GRATE_SPACING);
        };
        // Create a solid outside layer for strength and look
        color([0.5, 0.5, 0.5]) difference() {
            cylinder(h=DRAIN_HEIGHT, r=(DRAIN_DIAMETER + GRATE_WIDTH)/ 2, center=true);
            cylinder(h=DRAIN_HEIGHT, r=DRAIN_DIAMETER / 2, center=true);
        };
    };
    color([0,1,0]) cylinder(h=DRAIN_HEIGHT, r = (DRAIN_DIAMETER + GRATE_WIDTH) / 2, center=true);
}
