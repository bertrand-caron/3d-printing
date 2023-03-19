/* [Grate dimensions] */

GRATE_WIDTH = 1; //mm
GRATE_SPACING = 2.5; // mm

/* [Drain dimensions] */

DRAIN_HEIGHT = 2; // mm
DRAIN_X = 75; // mm
DRAIN_Y = 75; // mm

module grate_x(x=0) {
    translate([0, x, 0]) {
        cube([DRAIN_X + GRATE_WIDTH, GRATE_WIDTH, DRAIN_HEIGHT], center=true);
    };
}

module grate_y(y=0) {
    translate([y, 0, 0]) {
        color([0,1,1])
        cube([GRATE_WIDTH, DRAIN_Y + GRATE_WIDTH, DRAIN_HEIGHT], center=true);
    };
}

GRATE_NUMBER_X = ceil(DRAIN_Y / GRATE_SPACING);
GRATE_NUMBER_Y = ceil(DRAIN_X / GRATE_SPACING);

intersection() {
    union() {
        union() {
            for (i = [-GRATE_NUMBER_X/2: GRATE_NUMBER_X/2])
                grate_x(i * GRATE_SPACING);
        };
        union() {
            for (i = [-GRATE_NUMBER_Y/2: GRATE_NUMBER_Y/2])
                grate_y(i * GRATE_SPACING);
        };
    };
    // Intersect the grate with the maximum dimensions to ensure that it is no longer/larger than DRAIN_X and DRAIN_Y.
    color([0,1,0]) cube([DRAIN_X, DRAIN_Y, DRAIN_HEIGHT], center=true);
}