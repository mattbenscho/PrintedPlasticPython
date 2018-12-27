// cranks: Shimano Kettenradgarnitur FC-TY301 Triple 6/7/8-Gang Junior
// https://www.ebay.de/itm/Shimano-Kettenradgarnitur-FC-TY301-Triple-6-7-8-Gang-Junior/
// 123478255730?epid=15025661321&hash=item1cbfe0a872:g:SFEAAOSw2gNb5JGN

// sprockets: 42x34x24
// chain line: 47.5 mm 
// Q Factor 150 mm ???

function diameter(n) = (n/3.141) * 2.54 * 2;

module cranks(bracket_width, crank_length=150, sprocket_width=3, qfactor = 150, chain_line=47.5, sprocket_distance = 5, crank_angle = 0) {
    translate([0, 0, chain_line]) {
        translate([0, 0, (-1)*sprocket_distance]) cylinder(r=diameter(24), h=sprocket_width, center=true);
        translate([0, 0, 0*sprocket_distance]) cylinder(r=diameter(34), h=sprocket_width, center=true);
        translate([0, 0, (+1)*sprocket_distance]) cylinder(r=diameter(42), h=sprocket_width, center=true);
    }
    
    // crank next to sprockets
    rotate([0, 0, crank_angle]) hull() {
        translate([0, 0, chain_line + 2*sprocket_width + 5]) cylinder(r=10, h=10);
        translate([crank_length, 0, qfactor/2 + 5]) cylinder(r=10, h=10);
    }
    
    % translate([0, 0, qfactor/2 + 10]) difference() {
        cylinder(r=crank_length + 10, h=10, center=true, $fn=50);
        cylinder(r=crank_length + 8, h=12, center=true, $fn=50);
    }

    // crank on the other side
    rotate([0, 0, crank_angle]) hull() {
        translate([0, 0, -(chain_line + 2*sprocket_width + 15)]) cylinder(r=10, h=10);
        translate([-crank_length, 0, -(qfactor/2 + 15)]) cylinder(r=10, h=10);
    }
    
    % translate([0, 0, -qfactor/2 - 10]) difference() {
        cylinder(r=crank_length + 10, h=10, center=true, $fn=50);
        cylinder(r=crank_length + 8, h=12, center=true, $fn=50);
    }
}

