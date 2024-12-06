TRUNCATE_CUBE_CORNER = [500, 250, 75];


module corner() {
    difference(){
        color([0, 0, 1, 0.1]) rotate([0, 90, 0]) import("starlinkminiholderV3.stl");
        union() {
            color([1, 0, 0, 0.1]) translate([100, -175, 0]) cube(TRUNCATE_CUBE_CORNER, center=true);
            color([1, 0, 0, 0.1]) translate([300, 0, 0]) cube(TRUNCATE_CUBE_CORNER, center=true);
        };
    };
}

TRUNCATE_CUBE_STRAIGHT = [200, 500, 75];

module straight() {
    difference(){
        color([0, 0, 1, 0.1]) rotate([0, 90, 0]) import("starlinkminiholderV3.stl");
        union() {
            color([1, 0, 0, 0.1]) translate([-50, -175, 0]) cube(TRUNCATE_CUBE_STRAIGHT, center=true);
            color([1, 0, 0, 0.1]) translate([315, -175, 0]) cube(TRUNCATE_CUBE_STRAIGHT, center=true);
            color([1, 0, 0, 0.1]) translate([100, -300, 0]) rotate([0, 0, 90]) cube(TRUNCATE_CUBE_STRAIGHT, center=true);
            // Truncate the bottom
            color([1, 0, 0, 0.1]) translate([-250, -500, -35]) cube([1000, 1000, 30]);
        };
    };
};

WALL_THICKNESS = 10; // mm

HEAD_THICKNESS = 3.5; // mm
HEAD_DIAMETER = 10; // mm
THREAD_DIAMETER = 5.5; // mm

TOTAL_MEMBER_LENGTH = 165; // mm

module M5_bolt() {
    union(){
        cylinder(r=HEAD_DIAMETER / 2, h = HEAD_THICKNESS); // Head
        cylinder(r=THREAD_DIAMETER / 2, h = 50); // Shank
    }
};

module straight_with_M5_holes() {
    difference() {
        straight();
        translate([75, 6.5, 5]) rotate([-90, 90, 0]) M5_bolt();
        translate([75 + 115, 6.5, 5]) rotate([-90, 90, 0]) M5_bolt();
    };
};

straight_with_M5_holes();