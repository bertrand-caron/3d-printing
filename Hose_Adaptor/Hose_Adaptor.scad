/*
  Inspired by https://www.thingiverse.com/thing:1324986.
  Allows up to six connectors (each of customisable inside diameter, wall thickness and number of barbs) on a cube manifold (with custom manifold dimensions).
  Cube faces are numbered A to F (A and C along the X axis, B and D along the Y axis, and E and F along the Z axis).
*/

// Hose A inside diameter or bore. Set to zero to disable.
Size_A = 10; 
// Hose B inside diameter or bore. Set to zero to disable.
Size_B = 4; 
// Hose C inside diameter or bore. Set to zero to disable.
Size_C = 10; 
// Hose D inside diameter or bore. Set to zero to disable.
Size_D = 4;
// Hose E inside diameter or bore. Set to zero to disable.
Size_E = 4;
// Hose F inside diameter or bore. Set to zero to disable.
Size_F = 4;

// Manifold Bore = Size_A - 2 * Wall Thickness_A. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_A = 2;
assert(Size_A == 0 || (Size_A != 0 && Wall_Thickness_A < Size_A), "Error: Wall_Thickness_A <= Size_A");
// Manifold Bore = Size_B - 2 * Wall Thickness_B. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_B = 1;
assert(Size_B == 0 || (Size_B != 0 && Wall_Thickness_B < Size_B), "Error: Wall_Thickness_B <= Size_B");
// Manifold Bore = Size_C - 2 * Wall Thickness_C. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_C = 2;
assert(Size_C == 0 || (Size_C != 0 && Wall_Thickness_C < Size_C), "Error: Wall_Thickness_C <= Size_C");
// Manifold Bore = Size_D - 2 * Wall Thickness_D. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_D = 1;
assert(Size_D == 0 || (Size_D != 0 && Wall_Thickness_D < Size_D), "Error: Wall_Thickness_D <= Size_D");
// Manifold Bore = Size_E - 2 * Wall Thickness_E. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_E = 1;
assert(Size_E == 0 || (Size_E != 0 && Wall_Thickness_E < Size_E), "Error: Wall_Thickness_E <= Size_E");
// Manifold Bore = Size_F - 2 * Wall Thickness_F. Thicker walls are stronger but have a smaller bore (i.e. less flow and more resistance).
Wall_Thickness_F = 1;
assert(Size_F == 0 || (Size_F != 0 && Wall_Thickness_F < Size_F), "Error: Wall_Thickness_F <= Size_F");

// Number of barbs on connector A (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_A_barb_count = 3; // [1:4]
assert(Size_A_barb_count >= 1, "Error: Size_A_barb_count < 1");
// Number of barbs on connector B (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_B_barb_count = 3; // [1:4]
assert(Size_B_barb_count >= 1, "Error: Size_B_barb_count < 1");
// Number of barbs on connector C (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_C_barb_count = 3; // [1:4]
assert(Size_C_barb_count >= 1, "Error: Size_C_barb_count < 1");
// Number of barbs on connector D (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_D_barb_count = 3; // [1:4]
assert(Size_D_barb_count >= 1, "Error: Size_D_barb_count < 1");
// Number of barbs on connector E (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_E_barb_count = 3; // [1:4]
assert(Size_E_barb_count >= 1, "Error: Size_E_barb_count < 1");
// Number of barbs on connector F (>=1). Try 3 for larger tubing to reduce overall print height, 4 for smaller tubing.
Size_F_barb_count = 3; // [1:4]
assert(Size_F_barb_count >= 1, "Error: Size_F_barb_count < 1");

// Compute the bore of a hole based on its size and wall thickness.
function size_bore(size, wall_thickness) = size - (wall_thickness * 2);

// Manifold cube size (in mm) [X, Y, Z]
MANIFOLD_CUBE_SIZE = [10, 20, 12.5];

// Directions for face A. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_A = [0, 90, 0];
// Directions for face B. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_B = [90, 90, 0];
// Directions for face C. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_C = [180, 90, 0];
// Directions for face D. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_D = [270, 90, 0];
// Directions for face E. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_E = [0, 0, 0];
// Directions for face F. Do not change unless you know what you are doing (and want connectors not aligned with cube faces).
DIRECTION_F = [0, 180, 0];

// Hidden Variables used throught the sketch dont't sugest changing these.
Size_A_Bore = size_bore(Size_A, Wall_Thickness_A);
// Hidden Variables used throught the sketch dont't sugest changing these.
Size_B_Bore = size_bore(Size_B, Wall_Thickness_B);
// Hidden Variables used throught the sketch dont't sugest changing these.
Size_C_Bore = size_bore(Size_C, Wall_Thickness_C);
// Hidden Variables used throught the sketch dont't sugest changing these.
Size_D_Bore = size_bore(Size_D, Wall_Thickness_D);
// Hidden Variables used throught the sketch dont't sugest changing these.
Size_E_Bore = size_bore(Size_E, Wall_Thickness_E);
// Hidden Variables used throught the sketch dont't sugest changing these.
Size_F_Bore = size_bore(Size_F, Wall_Thickness_F);

// create body of manifold  
union()
{
  difference()
  {
    // Main body (cube) of the manyfold
    color([0.5, 0, 0, 0.5]) cube( MANIFOLD_CUBE_SIZE, center = true, $fa = 0.5, $fs = 0.5);

    // Bore holes for the ports
    rotate(DIRECTION_A) cylinder(h = MANIFOLD_CUBE_SIZE[0], d = Size_A_Bore, center = false, $fa = 0.5, $fs = 0.5);
    rotate(DIRECTION_B) cylinder(h = MANIFOLD_CUBE_SIZE[1], d = Size_B_Bore, center = false, $fa = 0.5, $fs = 0.5);
    rotate(DIRECTION_C) cylinder(h = MANIFOLD_CUBE_SIZE[0], d = Size_C_Bore, center = false, $fa = 0.5, $fs = 0.5);
    rotate(DIRECTION_D) cylinder(h = MANIFOLD_CUBE_SIZE[2], d = Size_D_Bore, center = false, $fa = 0.5, $fs = 0.5);
    rotate(DIRECTION_E) cylinder(h = MANIFOLD_CUBE_SIZE[2], d = Size_E_Bore, center = false, $fa = 0.5, $fs = 0.5);
    rotate(DIRECTION_F) cylinder(h = MANIFOLD_CUBE_SIZE[2], d = Size_F_Bore, center = false, $fa = 0.5, $fs = 0.5);
  }

  // Add the ports
  rotate(DIRECTION_A) translate([0, 0, (MANIFOLD_CUBE_SIZE[0] / 2) - 0.5]) connector_size_A();
  rotate(DIRECTION_B) translate([0, 0, (MANIFOLD_CUBE_SIZE[1] / 2) - 0.5]) connector_size_B();
  rotate(DIRECTION_C) translate([0, 0, (MANIFOLD_CUBE_SIZE[0] / 2) - 0.5]) connector_size_C();
  rotate(DIRECTION_D) translate([0, 0, (MANIFOLD_CUBE_SIZE[1] / 2) - 0.5]) connector_size_D();
  rotate(DIRECTION_E) translate([0, 0, (MANIFOLD_CUBE_SIZE[2] / 2) - 0.5]) connector_size_E();
  rotate(DIRECTION_F) translate([0, 0, (MANIFOLD_CUBE_SIZE[2] / 2) - 0.5]) connector_size_F();
}

module connector(size, bore, barb_count, barb_max_ratio = 1.25, barb_min_ratio = 1.00) {
  difference()
  {
    // Sum of all barbs
    // The total length of the connector is controlled by the number of barbs.
    // The total length is: `size + (barb_count - 1) * size * 0.9`
    union()
    {
      for (i = [1:barb_count])
      {
        translate([0, 0, (i - 1) * size * 0.9]) cylinder(h = size , r2 = size * barb_min_ratio / 2, r1 = size * barb_max_ratio / 2, $fa = 0.5, $fs = 0.5);

      }
    }
    // Minus the bore
    translate([0, 0, -0.1]) cylinder(h = size * barb_count , d = bore , $fa = 0.5, $fs = 0.5);
  }
}

module connector_size_A()
{
  connector(Size_A, Size_A_Bore, Size_A_barb_count);
}

module connector_size_B()
{
  connector(Size_B, Size_B_Bore, Size_B_barb_count);
}

module connector_size_C()
{
  connector(Size_C, Size_C_Bore, Size_C_barb_count);
}

module connector_size_D()
{
  connector(Size_D, Size_D_Bore, Size_D_barb_count);
}

module connector_size_E()
{
  connector(Size_E, Size_E_Bore, Size_E_barb_count);
}

module connector_size_F()
{
  connector(Size_F, Size_F_Bore, Size_F_barb_count);
}
