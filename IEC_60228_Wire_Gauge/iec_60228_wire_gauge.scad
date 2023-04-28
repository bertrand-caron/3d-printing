SECTIONS = [
    0.5,
    0.75,
    1,
    1.5,
    2.5,
    4,
    6,
    10,
    16,
    25,
    // 35,
    // 50,
    // 70,
    // 95,
    // 120,
    // 150,
    // 185,
    // 240,
    // 300,
    // 400,
    // 500,
    // 630,
    // 800,
    // 1000,
    // 1200,
    // 1400,
    // 1600,
    // 1800,
    // 2000,
    // 2500,
];

N = len(SECTIONS);

DIAMETERS = [for (s=SECTIONS) sqrt(s)];

LABELS = [for (s=SECTIONS) str(s)];
LABEL_LENGTHS = [for (s=LABELS) len(s)];

TEXT_SIZE = 4.0;

function maximum(list, i = 0) =
    i < len(list) - 1 ?
    max(list[i], maximum(list, i + 1)) :
    0;

function sumRight(list, c = 0) = 
    c < len(list) - 1 ? 
    list[c] + sumRight(list, c + 1) :
    list[c];

SECTIONS_SUM = sumRight(SECTIONS);
DIAMETERS_SUM = sumRight(DIAMETERS);

TEXT_HEIGHT = 0.25;
MIN_TEXT_OFFSET = TEXT_SIZE;
MIN_DISC_DIAMETER = 2.5 * TEXT_SIZE * maximum(LABEL_LENGTHS);

// Roughly compute the gauge disc diameter by summing the diameters and applying a multiplicative factor.
GAUGE_DISC_DIAMETER = MIN_DISC_DIAMETER + 4 * DIAMETERS_SUM / 3.14;
// Gauge disc height (in mm).
GAUGE_DISC_HEIGHT = 1; // in mm

function reverse(list, i=0) = 
    len(list) > i ? 
    concat(list[len(list) - (i + 1)],  reverse(list, i+1)) : 
    [];

function cumulativeSum(list) = reverse([for (i=[0:N-1]) sumRight(reverse(list), c=i)]);

CUMULATIVE_SECTIONS = cumulativeSum(SECTIONS);
CUMULATIVE_DIAMETERS = cumulativeSum(DIAMETERS);

$fa = 1.0;

module base_disc() {
    cylinder(d=GAUGE_DISC_DIAMETER, h=GAUGE_DISC_HEIGHT, $fs=1.0, center=true);
}

FULL_CIRCLE = 360; // in degrees

function cumulativeDiameter(i) = ((i == 0 ? 0 : CUMULATIVE_DIAMETERS[i-1]) + CUMULATIVE_DIAMETERS[i]) / 2;

module label(i) {
    d = DIAMETERS[i];
    label = LABELS[i];

    rotate([0, 0, FULL_CIRCLE * cumulativeDiameter(i) / DIAMETERS_SUM]) {
        translate([GAUGE_DISC_DIAMETER / 4, 0, 0]) {
            translate([MIN_TEXT_OFFSET + d / 2, 0, -GAUGE_DISC_HEIGHT / 2]) {
                linear_extrude(height = GAUGE_DISC_HEIGHT + TEXT_HEIGHT) {
                    text(label, size=TEXT_SIZE, halign="left", valign="center", font="Liberation Sans:style=Bold");
                };
            }
            
        };
    };
}

module hole(i) {
    d = DIAMETERS[i];

    rotate([0, 0, FULL_CIRCLE * cumulativeDiameter(i) / DIAMETERS_SUM]) {
        translate([GAUGE_DISC_DIAMETER / 4, 0, 0]) {
            cylinder(d=d, h = GAUGE_DISC_HEIGHT, $fs=0.1, center=true);
        };
    }
}

difference() {
    union() {
        base_disc();
        for (i = [0:N-1]) label(i);
    };
    union() {
        for (i = [0:N-1]) hole(i);
    };
};
