module base_cube(size, center=[0, 0, 0]) {
    // echo(["base_cube", size, center]);
    translate(center) {
        cube(size, center=true);
    };
};

module fractal_cube(base_size, depth, max_depth, center = [0, 0, 0]) {
    // echo(["fractal_cube", base_size, depth, max_depth, center]);
    size = base_size / pow(3, depth);
    next_size = size / 3;

    if (depth >= max_depth) {
        // Reached max recursion depth, return a plain cube at the right center.
        base_cube(size, center);
    } else {
        // V2
        // Return the union between 20 cubes (3^D - 7 where D = 3) of the next recursion level
        // differing by their center only
        union() {
            for (i = [-1, 0, 1])
                for (j = [-1, 0, 1])
                    for (k = [-1, 0, 1])
                        if ([i, j, k] != [0, 0, 0] && [i, j, k] != [0, 0, 1] && [i, j, k] != [0, 0, -1] && [i, j, k] != [1, 0, 0] && [i, j, k] != [-1, 0, 0] && [i, j, k] != [0, 1, 0] && [i, j, k] != [0, -1, 0]) // Exclude the necessary sub-cubes
                            fractal_cube(base_size, depth + 1, max_depth, center=center + [i * next_size, j * next_size, k * next_size]);
        };
    };
}

fractal_cube(60, 0, 3, center=[0, 0 ,0]);
