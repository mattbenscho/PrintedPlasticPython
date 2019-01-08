module ortlieb_pannier() {
module hook() {
	import ("external_parts/ortlieb_bag/Oertlieb_Hook_original_1_3.stl");
}

module clip() {
	import ("external_parts/ortlieb_bag/ortlieb-hook-10mm.stl");
}

hull() {
// lower end
cube([250, 180, 100], center=true);

// upper end
translate([0, 0, 280])
	cube([340, 180, 100], center=true);
}

// upper bar
translate([0, -100, 290])
	cube([300, 15, 30], center=true);

translate([-75, -97, 260]) rotate([0, -90, 180]) clip();
translate([+75, -97, 260]) rotate([0, -90, 180]) clip();

translate([40, -100, 50]) rotate([90, 180, 0]) hook();
}