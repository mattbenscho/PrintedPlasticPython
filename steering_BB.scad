// Bottom bracket: Shimano Innenlager BB-UN26 Vierkant
BB_width = 110;
BB_shell_width = 68;
BB_shell_diameter = 34.8;

module steering_BB () {
    difference() {
        cylinder(h=BB_shell_width, r=BB_shell_diameter/2, center=true);
        cylinder(h=BB_shell_width - 10, r=BB_shell_diameter/2 - 5, center=true);
        cylinder(h=BB_shell_width + 10, r=BB_shell_diameter/2 - 10, center=true);
    }
    cube([ 10, 10, BB_width ], center=true); // nochmal Vierkantmaße überprüfen
    cylinder(h=BB_shell_width - 11, r=BB_shell_diameter/2 - 6, center=true);
}

// difference() {
    // steering_BB();
    // translate([0, -100, 0]) cube([200, 200, 200], center=true);
// }