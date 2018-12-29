module rider (
inseam_length = 790,
leg_length = 920,
height = 1760,
shoulder_height = 1460,
lower_leg_length = 490, // measured from floor to knee joint
left_knee_angle = 0,
right_knee_angle = 0,
left_hip_angle = 0,
right_hip_angle = 0,
leg_width = 50,
waist_width = 350,
waist_depth = 200,
torso_minkowski_radius = 50,
leg_minkowski_radius = 40,
arm_minkowski_radius = 10,
head_diameter = 220,
left_arm_angle = 90,
right_arm_angle = 90) {

// calculated variables
upper_leg_length = leg_length - lower_leg_length;
torso_height = shoulder_height - inseam_length - torso_minkowski_radius + 30;

module leg(hip_angle = left_hip_angle, knee_angle = left_knee_angle) {
    // upper leg
    translate([0, 0, upper_leg_length + lower_leg_length])
    rotate([0, hip_angle, 0])
    translate([0, 0, -upper_leg_length])
    minkowski () {
        sphere(r=leg_minkowski_radius);
        cylinder(h=upper_leg_length, r=leg_width/2);
    };

    // lower leg
    knee_angle = knee_angle - hip_angle;
    translate([-sin(hip_angle) * upper_leg_length + sin(knee_angle) * lower_leg_length,
        0,
        upper_leg_length - cos(hip_angle) * upper_leg_length
        + lower_leg_length - cos(knee_angle) * lower_leg_length])
    rotate([0, -knee_angle, 0])
    minkowski () {
        sphere(r=leg_minkowski_radius);
        cylinder(h=lower_leg_length, r=leg_width/2);
    };
};

// legs
translate([0, -waist_width/2+leg_width/2+leg_minkowski_radius, 0])
leg(hip_angle = left_hip_angle, knee_angle = left_knee_angle);

translate([0, +waist_width/2-leg_width/2-leg_minkowski_radius, 0])
leg(hip_angle = right_hip_angle, knee_angle = right_knee_angle);

// torso
translate([0, 0, torso_height/2 + inseam_length + torso_minkowski_radius])
minkowski () {
    sphere(r=torso_minkowski_radius);
    cube([waist_depth - 2*torso_minkowski_radius,
        waist_width - 2*torso_minkowski_radius,
        torso_height- 2*torso_minkowski_radius], center=true);
};

// head
translate([0, 0, height - head_diameter/2]) sphere(r=head_diameter/2);

// neck
translate([0, 0, height - head_diameter]) cylinder(r=50, h=200, center=true);

// arms
module arm(angle=left_arm_angle, side=-1) {
    translate([0, side*200, 1420])
    rotate([0, -angle, 0])
    minkowski () {
        sphere(r=arm_minkowski_radius);
        cylinder(h=740, r1=50, r2=5);
    }
};

arm(angle=left_arm_angle, side=-1);
arm(angle=right_arm_angle, side=1);

};

* translate([-300, 500, 900]) scale(1.8) rotate([90, 0, 0]) surface(file = "./pics/IMG_20181214_210412_side.png", center=true);

* rider(left_hip_angle=0, left_knee_angle=0, right_hip_angle=0, right_knee_angle=0, left_arm_angle=0);