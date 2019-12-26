// Dimensions for mount to night light base
mount_diameter = 18;
mount_straight_before_clip = 5.29;
clip_nub = 1;
mount_thick = 1.6;
socket_height = 19;

// Overall dimensions
center_to_wall = 16;
inside_height = 72;
clear_wall = 0.8;  // two extrusion widths (one is transparenter but raggedy)

// It's-made-out-of-triangles-and-floats
epsilon = 0.01;
$fn = 240;

center_to_wall_interior = center_to_wall - clear_wall;
mount_radius = mount_diameter / 2;
y_position_of_entrance_sides = center_to_wall_interior * sqrt(1 - pow(mount_radius / center_to_wall, 2));
socket_slope_height = center_to_wall - y_position_of_entrance_sides;


main();
//mount();


module main() {
    mount();
    
    difference() {
        outer_cylinder();

        inner_cylinder();

        socket_clearance_negative();
        
        // decorations
        zstep = 8;
        for (z = [10:zstep:inside_height - 5])
        translate([0, 0, z]) {
            is_even_row = floor(z / zstep) % 2 == 0;
            alt = is_even_row ? 0.5 : 0;
            
            angle_step = 360 / 12;
            step_range = floor(360 / angle_step - alt);
            for (i = [0:step_range]) {
                angular_position = (i + alt) * angle_step;
                scale([1, 1, 2])
                rotate([90, 0, angular_position])
                cylinder(d=4.8, h=center_to_wall * 1.2, $fn=4);
            }
        }
    }
    
    socket_clearance_support();
}

module outer_cylinder() {
    cylinder(r=center_to_wall, h=inside_height + mount_thick - epsilon);
}

module inner_cylinder() {
    translate([0, 0, -epsilon])
    cylinder(r=center_to_wall - clear_wall, h=inside_height + mount_thick + epsilon);
}

module socket_clearance_negative() {
    // construct a prism
    translate([-mount_radius, 0, -epsilon])
    hull() {
        translate([0, center_to_wall + epsilon, 0])
        cube([mount_diameter, epsilon, socket_height + socket_slope_height]);
        translate([0, y_position_of_entrance_sides, 0])
        cube([mount_diameter, epsilon, socket_height]);
    }
}

module socket_clearance_support() {
    // the thickness in Z (as defined) and Y (because the slope is 45°), chosen to give two filament strands
    slope_axial_thickness = 0.9;  
    
    intersection() {
        union() {
            // construct a sloped bar that sits above the prism of socket_clearance_negative
            translate([-mount_radius, 0, -epsilon])
            hull() {
                translate([0, center_to_wall + epsilon, socket_height + socket_slope_height])
                cube([mount_diameter, epsilon, slope_axial_thickness]);
                translate([0, y_position_of_entrance_sides, socket_height])
                cube([mount_diameter, epsilon, slope_axial_thickness]);
            }
        
            // vertical supports (prohibit diamonds)
            difference() {
                support_width = mount_diameter + 4; 
                support_height = socket_height + socket_slope_height;
                translate([-support_width / 2, 0, -epsilon])
                cube([support_width, center_to_wall, support_height]);

                translate([-mount_radius, 0, -epsilon])
                cube([mount_diameter, center_to_wall, support_height + epsilon]);
                
                socket_clearance_negative();
                inner_cylinder();
            }
        }

        outer_cylinder();
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