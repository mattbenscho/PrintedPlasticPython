module heim_joint(spacing = 200, axis_offset = 0) {
    module parts() {
        translate([0, 0, 23.5]) rotate([-90, 180, 0]) import("external_parts/quick_release/04232-2531110X50.stl");
        rotate([90, 0, 90]) import("external_parts/heim_joint/KCRM_10_1.stl");
    }
    translate([0, 0, spacing/2 + axis_offset]) parts();
    translate([0, 0, -spacing/2 + axis_offset]) rotate([0, 0, 0]) parts();
};