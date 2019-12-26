// Dimensions for mount to night light base
mount_diameter = 18;
mount_straight_before_clip = 5.29;
clip_nub = 1;
mount_thick = 1.6;
mount_entrance_height = 19;

// Overall dimensions
center_to_wall = 16;
inside_height = 72;
clear_wall = 0.45;

// It's-made-out-of-triangles-and-floats
epsilon = 0.01;
$fn = 240;


main();
//mount();


module main() {
    mount();
    
    difference() {
        cylinder(r=center_to_wall, h=inside_height + mount_thick - epsilon);

        // interior volume
        translate([0, 0, -epsilon])
        cylinder(r=center_to_wall - clear_wall, h=inside_height + mount_thick + epsilon);

        // mount
        translate([-mount_diameter / 2, 0, -epsilon])
        cube([mount_diameter, center_to_wall * 2, mount_entrance_height]);
        
        // decorations
        zstep = 8;
        for (z = [10:zstep:inside_height - 5])
        translate([0, 0, z]) {
            is_even_row = floor(z / zstep) % 2 == 0;
            alt = is_even_row ? 0.5 : 0;
            
            angle_step = 360 / 12;
            angle_range = z > mount_entrance_height ? 180 : 120;
            step_range = floor(angle_range / angle_step);
            for (i = [-step_range - alt:1:step_range + alt]) {
                angular_position = i * angle_step + alt;
                scale([1, 1, 2])
                rotate([90, 0, angular_position])
                cylinder(d=4.8, h=center_to_wall * 1.2, $fn=4);
            }
        }
    }
}

module mount() {
    linear_extrude(mount_thick, convexity=5)
    difference() {
        circle(r=center_to_wall);
        
        circle(d=mount_diameter);
        
        r = mount_diameter / 2;
        polygon([
            [-r, 0],
            [-r, mount_straight_before_clip],
            [-(r - clip_nub), mount_straight_before_clip],
            [-r, mount_straight_before_clip + clip_nub],
            [-r, 100],
            [r, 100],
            [r, mount_straight_before_clip + clip_nub],
            [(r - clip_nub), mount_straight_before_clip],
            [r, mount_straight_before_clip],
            [r, 0],
        ]);
    }
}