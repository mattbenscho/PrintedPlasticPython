// translate([-300, 500, 900]) scale(1.8) rotate([90, 0, 0]) surface(file = "./Body Pics/IMG_20181214_210412_side.png", center=true);

include <rider.scad>;

module stick (height=300) {
    rotate([90, 0, 0]) cylinder(h=height, r=20, center=true);
}

module seat (seat_points=[
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
    [ -30,  810, 300 ]
]) {
    difference () {
    for (i = [0 : len(seat_points) - 2 ]) {
        hull() {
            translate([ seat_points[i][0], 0, seat_points[i][1]]) stick(seat_points[i][2] );
            translate([ seat_points[i+1][0], 0, seat_points[i+1][1]]) stick(seat_points[i+1][2] );
        }
    }
    hull () {
        translate([0, 0, 1400]) rotate([0, 90, 0]) cylinder(h=500, r=30, center=true);
        translate([0, 0, 900]) rotate([0, 90, 0]) cylinder(h=500, r=30, center=true);
    }
    }
    
}

// seat();



// rider(left_hip_angle=55, left_knee_angle=10, right_hip_angle=90, right_knee_angle=90);
