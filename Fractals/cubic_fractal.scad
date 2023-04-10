module base_cube(size, center=[0, 0, 0]) {
    // echo(["base_cube", size, center]);
    translate(center) {
        cube(size, center=true);
    };
};

module fractal_cube(base_size, depth, max_depth, center = [0, 0, 0]) {
    // echo(["fractal_cube", base_size, depth, max_depth, center]);
    size = base_size / pow(2, depth);
    next_size = size / 2;

    if (depth >= max_depth) {
        // Reached max recursion depth, return a plain cube at the right center.
        base_cube(size, center);
    } else {
        // V2
        // Return the union between 6 cubes (2^D - 2 where D = 3) of the next recursion level
        // differing by their center only
        union() {
            for (i = [-1, 1])
                for (j = [-1, 1])
                    for (k = [-1, 1])
                        if (abs(i + j + k) != 3) // Exclude the bottom left and top right cubes
                            fractal_cube(base_size, depth + 1, max_depth, center=center + [ i * next_size / 2, j * next_size / 2, k * next_size / 2]);
        };
    };
}

fractal_cube(50, 0, 4, center=[0, 0 ,0]);
