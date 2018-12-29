// thru axle: https://bike.shimano.com/de-DE/product/component/deorext-m8000/SM-AX56-B.html - 177 mm axle length
// heim joint: https://www.igus.de/product/162 - KBRM-12 MH

module heim_joint_thru_axle(axis_offset = 0, spacing=120, lever_angle=180) {
    translate([0, 0, axis_offset+spacing/2]) {
        translate([0, 0, 8.5]) {
            translate([0, 0, 16]) rotate([-90, 180, lever_angle]) import("external_parts/quick_release/04232-2531110X50.stl");
            translate([0, 0, -177]) cylinder(h=177, d=12);
        }
        rotate([90, 0, 90]) import("external_parts/heim_joint/KBRM_12_1.stl");
        translate([0, 0, -spacing]) rotate([90, 0, 90]) import("external_parts/heim_joint/KBRM_12_1.stl");
    }
};

* heim_joint_thru_axle();