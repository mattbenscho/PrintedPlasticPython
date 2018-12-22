include <rear_wheel.scad>;
include <rider.scad>;
include <seat.scad>;
include <steering_BB.scad>;

wheelbase = 950;
pivot_angle = 65;


////// wheels
tire_width = 55;
rim_width = 25;
rim_diameter = 406;
rim_depth = 15;
rim_depth_extrusion = 10;
spokes = 20;
spoke_diameter = 5;
hub_width = 100;
hub_diameter = 60;
hub_axle_diameter = 12;

seat_translation = [650, 0, -600];
seat_rotation = [0, 43, 180];

translate([-wheelbase/2, 0, 0]) rotate([90, 0, 0]) rear_wheel();
translate([+wheelbase/2, 0, 0]) rotate([90, 0, 0]) rear_wheel(); // to be changed to front wheel with sprockets

////// rider
translate([710, 0, -600]) rotate([0, 45, 180]) rider(left_hip_angle=55, left_knee_angle=10, right_hip_angle=90, right_knee_angle=90);

////// maximum 3D printing volume
// translate([0, 0, 400]) cube([200, 200, 200], center=true);

////// seat
seat_points = [
    [  60, 1500, 100 ],
    [ 100, 1450, 200 ],
    [ 110, 1400, 300 ],
    [ 110, 1300, 300 ],
    [  90, 1200, 250 ],
    [  80, 1100, 200 ],
    [  80, 1000, 250 ],
    [ 100,  900, 300 ],
    [  75,  850, 300 ],
    [  20,  825, 300 ],
    [ -30,  810, 150 ]
];

// translate([690, 0, -600]) rotate([0, 43, 180]) seat(seat_points=seat_points);
translate(seat_translation) rotate(seat_rotation) seat(seat_points=seat_points);

////// steering bottom bracket
steering_bracket_x = wheelbase/2 - rim_diameter/2 - tire_width/2 - 80;
steering_bracket_z = -35;
translate([steering_bracket_x, 0, steering_bracket_z]) rotate([0, 90+pivot_angle, 0]) {
    steering_BB();
}

////// cycling bottom bracket
cycling_bracket_distance = wheelbase/2 + rim_diameter/2 + tire_width/2 + 140;
cycling_bracket_height = 100;

// needed for front frame hull: 
front_angle = -asin(cycling_bracket_height/sqrt(pow(cycling_bracket_distance - wheelbase/2, 2) + pow(cycling_bracket_height, 2)));

translate([cycling_bracket_distance, 0, cycling_bracket_height]) rotate([90, 0, 0]) {
    steering_BB();
}

deltafn=20;

////// front frame hull
* difference() {
    union () {
                        // holding the steering bracket in place: cylinder around bottom bracket
                translate([steering_bracket_x, 0, steering_bracket_z]) rotate([0, 90+pivot_angle, 0]) {
                    cylinder(h=BB_shell_width, r=BB_shell_diameter, center=true);
                }
                

                
            hull() {

                translate([+wheelbase/2 - 1.20 * (rim_diameter/2 + tire_width/2), 0, steering_bracket_z+10])
                cylinder(h=BB_shell_width, r=tire_width/2 * 1.20, center=true);
                            
                // cycling BB cylinder
                translate([cycling_bracket_distance, 0, cycling_bracket_height])
                rotate([90, 0, 0])
                cylinder(h=BB_shell_width-10, r=BB_shell_diameter/2, center=true);
                
                // enlarged wheel minus cube
                translate([+wheelbase/2, 0, 0])
                rotate([90, 0, 0])
                scale(1.20) {
                    cylinder(h=hub_width, r=hub_diameter/2, center=true, $fn=50);
                    difference () {                        
                        rotate_extrude(convexity=2, $fn=100)
                        translate([rim_diameter/2 + tire_width/2, 0, 0]) circle(r=tire_width/2, $fn=30);
                        // subtract bottom half of enlarged wheel
                        rotate([0, 0, -front_angle]) translate([0, -300/2, 0]) cube([1000, 300, 1000], center=true);
                        translate([0, -300/2, 0]) cube([1000, 300, 1000], center=true);
                    }
               }
           }
        }  
//        hull() {
//            // translate([steering_bracket_x, 0, steering_bracket_z]) rotate([0, 90+pivot_angle, 0]) {
//            //     translate([0, 75, 0]) cylinder(h=BB_shell_width-15, r=BB_shell_diameter/2, center=true);
//            //     translate([0, -75, 0]) cylinder(h=BB_shell_width-15, r=BB_shell_diameter/2, center=true);
//            // }
//            // translate([+wheelbase/2, -75, 0]) sphere(r=20, center=true, $fn=deltafn);
//            // translate([+wheelbase/2, +75, 0]) sphere(r=20, center=true, $fn=deltafn);
//            // cycling BB cylinder
//            translate([cycling_bracket_distance, 0, cycling_bracket_height])
//            rotate([90, 0, 0])
//            cylinder(h=BB_shell_width, r=BB_shell_diameter/2, center=true);
//            // translate([cycling_bracket_distance, -10, cycling_bracket_height]) sphere(r=20, center=true, $fn=deltafn);
//            // translate([cycling_bracket_distance, +10, cycling_bracket_height]) sphere(r=20, center=true, $fn=deltafn);
//    }
    hull() {
        // place for the wheel
        translate([+wheelbase/2, 0, 0])
        rotate([90, 0, 0]) {
            scale(1.05) cylinder(h=hub_width, r=hub_diameter/2, center=true, $fn=50);
            scale(1.10) rotate_extrude(convexity=2, $fn=100) {
                translate([rim_diameter/2 + tire_width/2, 0, 0]) circle(r=tire_width/2, $fn=30);
            }
        }
    }
    // place for the steering bottom bracket
    translate([steering_bracket_x, 0, steering_bracket_z])
    rotate([0, 90+pivot_angle, 0]) {
        cylinder(h=1.10*BB_shell_width, r=BB_shell_diameter/2, center=true);
        
//        translate([0, 0, BB_shell_width])
//        cube([BB_shell_width, BB_shell_width*2, BB_shell_width], center=true);
//        translate([0, 0, -BB_shell_width])
//        cube([BB_shell_width, BB_shell_width*2, BB_shell_width], center=true);
    }
}

////// rear frame hull
* difference() {
    for (i = [ 1, 2, 3, 4, 5, 6, 7 ]) {
        hull() {
            translate([-wheelbase/2, -75, 0])
            sphere(r=20, center=true, $fn=deltafn);
            
            translate([-wheelbase/2, +75, 0])
            sphere(r=20, center=true);
            
            translate(seat_translation) rotate(seat_rotation) {            
                translate([seat_points[i][0], seat_points[i][2]/2, seat_points[i][1]])
                sphere(r=20, center=true, $fn=deltafn);
            
                translate([seat_points[i+1][0], seat_points[i+1][2]/2, seat_points[i+1][1]])
                sphere(r=20, center=true, $fn=deltafn);

                translate([seat_points[i][0], -seat_points[i][2]/2, seat_points[i][1]])
                sphere(r=20, center=true);
            
                translate([seat_points[i+1][0], -seat_points[i+1][2]/2, seat_points[i+1][1]])
                sphere(r=20, center=true);
            }
        }     
    }
    hull() {
        translate([-wheelbase/2, 0, 0])
        rotate([90, 0, 0]) {
            scale(1.05) cylinder(h=hub_width, r=hub_diameter/2, center=true, $fn=50);
            scale(1.10) rotate_extrude(convexity=2, $fn=100) {
                translate([rim_diameter/2 + tire_width/2, 0, 0]) circle(r=tire_width/2, $fn=30);
            }
        }
    }  
}
     
//////// hollowing out the hull
//    for (i = [ 1, 2, 3, 4, 5, 6, 7 ]) {
//        hull() {
//            translate([-wheelbase/2, -75, 0])
//            sphere(r=10, center=true, $fn=deltafn);
//            
//            translate([690, 0, -600])
//            rotate([0, 43, 180])
//            translate([seat_points[i][0], seat_points[i][2]/2, seat_points[i][1]])
//            sphere(r=10, center=true, $fn=deltafn);
//            
//            translate([690, 0, -600])
//            rotate([0, 43, 180])
//            translate([seat_points[i+1][0], seat_points[i+1][2]/2, seat_points[i+1][1]])
//            sphere(r=10, center=true, $fn=deltafn);
//        }
//    }

////// slicing up the hull
//    multiplier = 20;
//    sheet_thickness = 6;
//    translate([-200, -100, 100])
//    for (i = [ -12:12 ]) {        
//        translate([0, 0, i*multiplier]) rotate([0, -30, 0]) cube([1000, 150, sheet_thickness], center=true);
//        translate([0, 0, i*multiplier]) rotate([0, 30, 0]) cube([1000, 150, sheet_thickness], center=true);
//    }
//}
    