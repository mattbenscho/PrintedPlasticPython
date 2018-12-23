// Schwalbe Big Apple 20"
// https://www.schwalbe.com/de/tour-reader/big-apple.html

// cogset: Shimano CS-HG200-7 https://bike.shimano.com/en-EU/product/component/tourney/CS-HG200-7.html
// 12-14-16-18-21-26-32 OR 12-14-16-18-21-24-28
// cogset width: 31.9, sprocked width: 1.85, spacer width: 3.15, distance sprocket-sprocket: 5 (center to center)

function diameter(n) = (n/3.141) * 2.54 * 2;

combination = [32, 26, 21, 18, 16, 14, 12];

module cogset(sprocket_width = 1.85, spacer_width = 3.15) {
    for (i=[0:6]) {
        difference() {
            translate([0, 0, (i)*(sprocket_width + spacer_width)])
            cylinder(h=sprocket_width, r=diameter(combination[i]));
            cylinder(h=1000, r=10);
        }
    }
}

module front_wheel (tire_width = 55,
rim_width = 25,
rim_diameter = 406,
rim_depth = 15,
rim_depth_extrusion = 10,
spokes = 20,
spoke_diameter = 5,
hub_width = 130,
hub_diameter = 20,
hub_axle_diameter = 12) {
// tire
rotate_extrude(convexity=2, $fn=100) {
    translate([rim_diameter/2 + tire_width/2, 0, 0]) circle(r=tire_width/2, $fn=30);
}

// rim
rotate_extrude(convexity=2, $fn=100) {
    translate([rim_diameter/2 - rim_depth/2 + rim_depth_extrusion/2, 0, 0]) square(size = [rim_depth+rim_depth_extrusion, rim_width], center=true);
}

// hub
difference() {
    cylinder(h=hub_width, r=hub_diameter/2, center=true, $fn=50);
    cylinder(h=hub_width + 10, r=hub_axle_diameter/2, center=true, $fn=25);
}

// spokes
for (i=[0:spokes]) {
    rotate([0, 0, 360/spokes * i])
    translate([0, rim_diameter/2/2, -hub_width/2/2])
    rotate([ asin((hub_width/2)/(rim_diameter/2))+90, 0, 0])
    cylinder(h=sqrt(pow(hub_width/2,2)+pow(rim_diameter/2-hub_diameter/2,2)), r=spoke_diameter/2, $fn=5, center=true);
}

for (i=[0:spokes]) {
    rotate([0, 0, 360/spokes * i + 360/spokes/2])
    translate([0, rim_diameter/2/2, 0])
    rotate([90-5, 0, 0])
    cylinder(h=sqrt(pow(hub_width/2,2)+pow(rim_diameter/2-hub_diameter/2,2)), r=spoke_diameter/2, $fn=5, center=true);
}

}