// thru axle: Shimano E-Thru AX-MT500 Steckachse 12 x 172 mm - 172 mm axle length
// https://bike.shimano.com/de-DE/product/component/slx-m7000/AX-MT500-148x12.html

// heim joint: https://www.igus.de/product/162 - KBRM-12 MH

module heim_joint_thru_axle(axis_offset = 0, spacing=120, lever_angle=180, heim_joint_ball_width = 16.2) {
    translate([0, 0, axis_offset+spacing/2]) {
        translate([0, 0, 8.5]) {
            translate([0, 0, 16])
				rotate([-90, 180, lever_angle])
					import("external_parts/quick_release/04232-2531110X50.stl");
            translate([0, 0, -172]) cylinder(h=172, d=12);
        }
        rotate([90, 0, 90]) import("external_parts/heim_joint/KBRM_12_1.stl");
        translate([0, 0, -spacing]) rotate([90, 0, 90]) import("external_parts/heim_joint/KBRM_12_1.stl");
    }	
	
	* translate([0, 0, axis_offset + spacing/2 - 10/2 - heim_joint_ball_width/2 ])
		cylinder(d=20, h=10, center=true);
	
	* translate([0, 0, axis_offset - spacing/2 + 10/2 + heim_joint_ball_width/2 ])
		cylinder(d=20, h=10, center=true);
	
	* translate([0, 0, axis_offset - spacing/2 - 10/2 - heim_joint_ball_width/2 ])
		cylinder(d=20, h=10, center=true);
};

* heim_joint_thru_axle();