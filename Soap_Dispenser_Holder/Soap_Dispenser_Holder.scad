// Define the dimensions of the bottles
BOTTLE_DIMENSIONS = [45, 67, 75];

// Number of bottles in the arrangement
NUM_BOTTLES = 4;

// Clearance inside the bottles for internal components
INTERNAL_CLEARANCE = 2; // mm

// Thickness of the walls of the holder
WALL_THICKNESS = 2.4; // mm

// Clearance around windows on the bottles
WINDOW_CLEARANCE = 5.0; // mm

// Define a single bottle as a module
module bottle() {
    // Create a red-colored cube representing a bottle
    color([1, 0, 0]) cube(BOTTLE_DIMENSIONS);
};

// Create multiple bottles in an array arrangement
module bottles() {
    union(){
        for (i = [0:NUM_BOTTLES - 1])
        translate([i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), 0, 0]) bottle();
    };
};

// Calculate the total length of the holder
TOTAL_LENGTH = NUM_BOTTLES * BOTTLE_DIMENSIONS[0] + (NUM_BOTTLES + 1) * WALL_THICKNESS + 2 * NUM_BOTTLES * INTERNAL_CLEARANCE;

// Define a wall along the X-axis
module x_wall() {
    cube([
        TOTAL_LENGTH,
        WALL_THICKNESS,
        BOTTLE_DIMENSIONS[2]
    ]);
};

// Define a window on the X-axis (version 1). This is a rectangular window, that requires support for printing.
module x_window_v1() {
    translate([WALL_THICKNESS + WINDOW_CLEARANCE, 0, WINDOW_CLEARANCE])
    cube([BOTTLE_DIMENSIONS[0] - 2 * WINDOW_CLEARANCE, WALL_THICKNESS, BOTTLE_DIMENSIONS[2] - 2 * WINDOW_CLEARANCE - WALL_THICKNESS]);
};

// Define a window on the X-axis (version 2). This is a trinagular window, that does not require support for printing.
module x_window_v2() {
    color([1, 0, 0])
    translate([WALL_THICKNESS + WINDOW_CLEARANCE, WALL_THICKNESS, WINDOW_CLEARANCE])
    resize([BOTTLE_DIMENSIONS[0] - 2 * WINDOW_CLEARANCE, WALL_THICKNESS, BOTTLE_DIMENSIONS[2] - 2 * WINDOW_CLEARANCE])
    rotate([90, 0, 0])
    linear_extrude(WALL_THICKNESS)
    polygon([[0, 0], [100, 100], [200, 0]]);
};

// Define a wall along the Y-axis
module y_wall() {
    translate([
        0,
        WALL_THICKNESS,
        0
    ])
    cube([
        WALL_THICKNESS,
        BOTTLE_DIMENSIONS[1] + 2 * INTERNAL_CLEARANCE,
        BOTTLE_DIMENSIONS[2]
    ]);
};

// Define a window on the Y-axis (version 1). This is a rectangular window, that requires support for printing.
module y_window_v1() {
    color([1, 0, 0]) translate([0, WALL_THICKNESS + INTERNAL_CLEARANCE + BOTTLE_DIMENSIONS[1] / 2, BOTTLE_DIMENSIONS[2] / 2]) rotate([90, 0, 90]) cylinder(d=BOTTLE_DIMENSIONS[1], h=WALL_THICKNESS, $fn=64);
};

// Define a window on the Y-axis (version 2). This is a trinagular window, that does not require support for printing.
module y_window_v2() {
    color([1, 0, 0])
    translate([0, WALL_THICKNESS + WINDOW_CLEARANCE + INTERNAL_CLEARANCE, WINDOW_CLEARANCE])
    resize([WALL_THICKNESS, BOTTLE_DIMENSIONS[1] - 2 * WINDOW_CLEARANCE, BOTTLE_DIMENSIONS[2] - 2 * WINDOW_CLEARANCE])
    rotate([90, 0, 90])
    linear_extrude(WALL_THICKNESS)
    polygon([[0, 0], [100, 100], [200, 0]]);
};

// Define the bottom of the bottle assembly
module bottom() {
    cube([TOTAL_LENGTH, BOTTLE_DIMENSIONS[1] + 2 * (WALL_THICKNESS + INTERNAL_CLEARANCE), WALL_THICKNESS]);
};

module bottom_window() {
    translate([INTERNAL_CLEARANCE, WALL_THICKNESS + INTERNAL_CLEARANCE, 0]) resize([BOTTLE_DIMENSIONS[0], BOTTLE_DIMENSIONS[1], WALL_THICKNESS]) cylinder(d=BOTTLE_DIMENSIONS[0], h=WALL_THICKNESS, $fn=64);
};

// Create the final assembly of walls, windows, and bottom
union(){
    translate([0, 0, WALL_THICKNESS]) {
        //translate([WALL_THICKNESS + INTERNAL_CLEARANCE, WALL_THICKNESS + INTERNAL_CLEARANCE, 0]) bottles();
        difference() {
            // X WALLS
            union() {
                x_wall();
                translate([0, BOTTLE_DIMENSIONS[1] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE, 0]) x_wall();
            };
            // X WINDOWS (FRONT)
            union(){
                for (i = [0:NUM_BOTTLES - 1])
                translate([i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), 0, 0]) x_window_v2();
            };
            // X WINDOWS (BACK)
            union(){
                for (i = [1:NUM_BOTTLES - 2])
                translate([i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), BOTTLE_DIMENSIONS[1] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE, 0]) x_window_v2();
            };
        };
        difference() {
            // Y WALLS
            union(){
                for (i = [0:NUM_BOTTLES])
                translate([i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), 0, 0]) y_wall();
            };
            // Y WINDOWS
            union(){
                for (i = [0:NUM_BOTTLES])
                translate([i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), 0, 0]) y_window_v2();
            };
        };

    };
    difference() {
        // BOTTOM
        bottom();
        // Y WINDOWS
        union(){
            for (i = [0:NUM_BOTTLES - 1])
            translate([WALL_THICKNESS + BOTTLE_DIMENSIONS[0] / 2 + i * (BOTTLE_DIMENSIONS[0] + WALL_THICKNESS + 2 * INTERNAL_CLEARANCE), BOTTLE_DIMENSIONS[1] / 2, 0]) bottom_window();
        };
    }
};
