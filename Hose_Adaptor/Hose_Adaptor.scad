// Hose A inside diameter or bore
Size_A = 10; 
// Hose B inside diameter or bore
Size_B = 4; 
// Hose C inside diameter or bore
Size_C = 10; 
// Hose D inside diameter or bore
Size_D = 0;
// Hose E inside diameter or bore
Size_E = 0;
// Hose F inside diameter or bore
Size_F = 0;

// Manifold Bore = Size - Wall Thickness thicker walls are stronger but have a smaller bore
Wall_Thickness_A = 2;
assert(Size_A == 0 || (Size_A != 0 && Wall_Thickness_A < Size_A), "Error: Wall_Thickness_A <= Size_A");

Wall_Thickness_B = 1;
assert(Size_B == 0 || (Size_B != 0 && Wall_Thickness_B < Size_B), "Error: Wall_Thickness_B <= Size_B");

Wall_Thickness_C = 2;
assert(Size_C == 0 || (Size_C != 0 && Wall_Thickness_C < Size_C), "Error: Wall_Thickness_C <= Size_C");

Wall_Thickness_D = 0;
assert(Size_D == 0 || (Size_D != 0 && Wall_Thickness_D < Size_D), "Error: Wall_Thickness_D <= Size_D");

Wall_Thickness_E = 0;
assert(Size_E == 0 || (Size_E != 0 && Wall_Thickness_E < Size_E), "Error: Wall_Thickness_E <= Size_E");

Wall_Thickness_F = 0;
assert(Size_F == 0 || (Size_F != 0 && Wall_Thickness_F < Size_F), "Error: Wall_Thickness_F <= Size_F");

// Number of barbs on output - try 3 for larger tubing to reduce overall print height try 4 for smaller tubing
Size_A_barb_count = 3;
assert(Size_A_barb_count >= 1, "Error: Size_A_barb_count < 1");

Size_B_barb_count = 4;
assert(Size_B_barb_count >= 1, "Error: Size_B_barb_count < 1");

Size_C_barb_count = 3;
assert(Size_C_barb_count >= 1, "Error: Size_C_barb_count < 1");

Size_D_barb_count = 4;
assert(Size_D_barb_count >= 1, "Error: Size_D_barb_count < 1");

Size_E_barb_count = 4;
assert(Size_E_barb_count >= 1, "Error: Size_E_barb_count < 1");

Size_F_barb_count = 4;
assert(Size_F_barb_count >= 1, "Error: Size_F_barb_count < 1");

function size_bore(size, wall_thickness) = size - (wall_thickness * 2);

// Hidden Variables used throught the sketch dont't sugest changing these
Size_A_Bore = size_bore(Size_A, Wall_Thickness_A);
Size_B_Bore = size_bore(Size_B, Wall_Thickness_B);
Size_C_Bore = size_bore(Size_C, Wall_Thickness_C);
Size_D_Bore = size_bore(Size_D, Wall_Thickness_D);
Size_E_Bore = size_bore(Size_E, Wall_Thickness_E);
Size_F_Bore = size_bore(Size_F, Wall_Thickness_F);

MANIFOLD_CUBE_SIZE = [10, 20, 12.5];

DIRECTION_A = [0, 90, 0];
DIRECTION_B = [90, 90, 0];
DIRECTION_C = [180, 90, 0];
DIRECTION_D = [270, 90, 0];
DIRECTION_E = [0, 0, 0];
DIRECTION_F = [0, 180, 0];

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
  rotate(DIRECTION_D) translate([0, 0, (MANIFOLD_CUBE_SIZE[2] / 2) - 0.5]) connector_size_D();
  rotate(DIRECTION_E) translate([0, 0, (MANIFOLD_CUBE_SIZE[2] / 2) - 0.5]) connector_size_E();
  rotate(DIRECTION_F) translate([0, 0, (MANIFOLD_CUBE_SIZE[2] / 2) - 0.5]) connector_size_F();
}

module connector(size, bore, barb_count) {
  difference()
  {
    union()
    {
      for (i = [1:barb_count])
      {
        translate([0, 0, (i - 1) * size * 0.9]) cylinder(h = size , r2 = size * 0.85 / 2, r1 = size * 1.16 / 2, $fa = 0.5, $fs = 0.5);

      }
    }
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
