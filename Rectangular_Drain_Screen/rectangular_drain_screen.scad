/* [Grate dimensions] */

GRATE_WIDTH = 1; //mm
GRATE_SPACING = 3; // mm

/* [Drain dimensions] */

DRAIN_BOTTOM_HEIGHT = 2; // mm
DRAIN_X = 70; // mm
DRAIN_Y = 70; // mm

/* [Drain wall dimensions (set either to zero to disable)] */

DRAIN_OUTSIDE_WALL_HEIGHT = 15; // mm
DRAIN_OUTSIDE_WALL_THICKNESS = 1.5; // mm

NUMBER_X_GRATES = (DRAIN_X - 2 * DRAIN_OUTSIDE_WALL_THICKNESS - GRATE_WIDTH) / GRATE_SPACING;
NUMBER_Y_GRATES = (DRAIN_Y - 2 * DRAIN_OUTSIDE_WALL_THICKNESS - GRATE_WIDTH) / GRATE_SPACING;

// Asert that the number of grates in the X and Y direction is an integer.
// We following equation should be true:
// DRAIN_X = 2 * DRAIN_OUTSIDE_WALL_THICKNESS + (N - 1) * GRATE_SPACING + GRATE_WIDTH
// where N is an integer >= 1.
// Comment the two lines below to allow partial grids.
assert(ceil(NUMBER_X_GRATES) == NUMBER_X_GRATES, "Expected NUMBER_X_GRATES to be an integer.");
assert(ceil(NUMBER_Y_GRATES) == NUMBER_Y_GRATES, "Expected NUMBER_Y_GRATES to be an integer.");

module grate_x(x=0) {
    translate([0, DRAIN_OUTSIDE_WALL_THICKNESS + x, 0]) {
        cube([DRAIN_X + GRATE_WIDTH, GRATE_WIDTH, DRAIN_BOTTOM_HEIGHT]);
    };
}

module grate_y(y=0) {
    translate([DRAIN_OUTSIDE_WALL_THICKNESS + y, 0, 0]) {
        cube([GRATE_WIDTH, DRAIN_Y + GRATE_WIDTH, DRAIN_BOTTOM_HEIGHT]);
    };
}

module outside_wall() {
    color([1, 0, 0]) translate([DRAIN_X / 2, DRAIN_Y / 2, DRAIN_OUTSIDE_WALL_HEIGHT / 2]) {
        difference() {
            cube([DRAIN_X, DRAIN_Y, DRAIN_OUTSIDE_WALL_HEIGHT], center=true);
            cube([DRAIN_X - 2 * DRAIN_OUTSIDE_WALL_THICKNESS, DRAIN_Y - 2 * DRAIN_OUTSIDE_WALL_THICKNESS, DRAIN_OUTSIDE_WALL_HEIGHT], center=true);
        }
    }
}

module grate() {
    union() {
        union() {
            for (i = [0: NUMBER_X_GRATES])
                grate_x(i * GRATE_SPACING);
        };
        union() {
            for (i = [0: NUMBER_Y_GRATES])
                grate_y(i * GRATE_SPACING);
        };
    };
}

intersection() {
    translate([0, 0, 0]) {
        union() {
            color([1,0,0,0.5]) grate();
            color([0,0,1,0.5]) outside_wall();
        };
    };
    translate([0, 0, 0]) {
        color([0,1,0,0.5]) cube([DRAIN_X, DRAIN_Y, max(DRAIN_OUTSIDE_WALL_HEIGHT, DRAIN_BOTTOM_HEIGHT)]);
    };
};
