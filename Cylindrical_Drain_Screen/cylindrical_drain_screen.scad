/* [Grate dimensions] */

GRATE_WIDTH = 0.5; //mm
GRATE_SPACING = 2.5; // mm

/* [Drain dimensions] */

DRAIN_BOTTOM_HEIGHT = 2; // mm
DRAIN_DIAMETER = 75; // mm

/* [Drain wall dimensions (set both to zero to disable)] */

DRAIN_OUTSIDE_WALL_HEIGHT = 20; // mm
DRAIN_OUTSIDE_WALL_THICKNESS = 2; // mm

module grate_x(x=0) {
    translate([0, x, 0]) {
        cube([DRAIN_DIAMETER + GRATE_WIDTH, GRATE_WIDTH, DRAIN_BOTTOM_HEIGHT], center=true);
    };
}

module grate_y(y=0) {
    translate([y, 0, 0]) {
        cube([GRATE_WIDTH, DRAIN_DIAMETER + GRATE_WIDTH, DRAIN_BOTTOM_HEIGHT], center=true);
    };
}

module outside_wall() {
    color([0, 1, 0]) translate([0, 0, (DRAIN_OUTSIDE_WALL_HEIGHT - DRAIN_BOTTOM_HEIGHT) / 2]) {
        difference() {
            cylinder(d=DRAIN_DIAMETER, h=DRAIN_OUTSIDE_WALL_HEIGHT, center = true);
            cylinder(d=DRAIN_DIAMETER - DRAIN_OUTSIDE_WALL_THICKNESS, h=DRAIN_OUTSIDE_WALL_HEIGHT, center = true);
        }
    }
}

GRATE_NUMBER = ceil(DRAIN_DIAMETER / GRATE_SPACING);

$fa = 1.0;
$fs = 0.1;

intersection() {
    translate([0, 0, DRAIN_BOTTOM_HEIGHT / 2]) {
        union() {
            union() {
                for (i = [-GRATE_NUMBER/2: GRATE_NUMBER/2])
                    grate_x(i * GRATE_SPACING);
            };
            union() {
                for (i = [-GRATE_NUMBER/2: GRATE_NUMBER/2])
                    grate_y(i * GRATE_SPACING);
            };
            outside_wall();
        };
    };
    translate([0, 0, max(DRAIN_BOTTOM_HEIGHT, DRAIN_OUTSIDE_WALL_HEIGHT) / 2]) {
        color([1,0,0]) cylinder(h=max(DRAIN_BOTTOM_HEIGHT, DRAIN_OUTSIDE_WALL_HEIGHT), d=DRAIN_DIAMETER, center=true);
    };
}
