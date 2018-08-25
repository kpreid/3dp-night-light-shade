mount_diameter = 17.2;
mount_straight_before_clip = 5.29;
clip_nub = 1;
mount_thick = 1.8;  // measured 1.87 but we don't want any chance of it rounded up by layer height...
center_to_wall = 16;

inside_height = 72;
clear_wall = 0.45;

epsilon = 0.01;

main();

module main() {
    intersection() {
        mount();
        
        cylinder(r=center_to_wall, h=mount_thick);
    }
    
    difference() {
        cylinder(r=center_to_wall, h=inside_height + mount_thick + clear_wall);

        // interior volume
        translate([0, 0, -epsilon])
        cylinder(r=center_to_wall - clear_wall, h=inside_height + mount_thick + epsilon);

        // mount
        translate([-mount_diameter / 2, 0, -epsilon])
        cube([mount_diameter, center_to_wall * 2, inside_height]);
    }
}

module mount() {
    linear_extrude(mount_thick, convexity=5)
    difference() {
        circle(d=100);
        
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