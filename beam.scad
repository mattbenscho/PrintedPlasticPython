// Source: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks

// Find the unitary vector with direction v. Fails if v=[0,0,0].
function unit(v) = norm(v)>0 ? v/norm(v) : undef; 

// Find the transpose of a rectangular matrix
function transpose(m) = // m is any rectangular matrix of objects
  [ for(j=[0:len(m[0])-1]) [ for(i=[0:len(m)-1]) m[i][j] ] ];

// The identity matrix with dimension n
function identity(n) = [for(i=[0:n-1]) [for(j=[0:n-1]) i==j ? 1 : 0] ];

// computes the rotation with minimum angle that brings a to b
// the code fails if a and b are opposed to each other
function rotate_from_to(a,b) = 
    let( axis = unit(cross(a,b)) )
    axis*axis >= 0.99 ? 
        transpose([unit(b), axis, cross(axis, unit(b))]) * 
            [unit(a), axis, cross(axis, unit(a))] : 
        identity(3);

module beam(
    p0,
    p1,
    diameter=beam_diameter,
    fn=default_beam_fn,
    l1=default_l,
    l2=default_l,
    l_in_1=default_l_in,
    l_in_2=default_l_in,
    hole_diameter_1=default_hole_diameter,
    hole_diameter_2=default_hole_diameter,
    hole_angle_1=0,
    hole_angle_2=0,
    hole_distance_1=default_hole_distance,
    hole_distance_2=default_hole_distance,
	drill_hole=0
) {
    module drill_hole(this_l, this_l_in, this_hole_distance, this_hole_diameter, this_angle) {
        translate([0, 0, this_l + this_hole_distance + this_hole_diameter/2])
            rotate([0, 90, this_angle])
                cylinder(d=abs(this_hole_diameter), h=2*diameter, $fn=fn, center=true);
    }    
    v = p1-p0;
	color("blue")
		translate(p0)	
			sphere(r=diameter/2, $fn=fn);
    color("blue")
		translate(p1)
			sphere(r=diameter/2, $fn=fn);
    translate(p0)
        multmatrix(rotate_from_to([0,0,1],v)) {
            color("blue") {
            // cylinder(d=diameter, h=l1, $fn=fn);
			if (drill_hole==1) {
            difference() {
                translate([0, 0, l1]) cylinder(d=diameter - 2*beam_wall_thickness, h=l_in_1, $fn=fn);
                drill_hole(l1, l_in_1, hole_distance_1, hole_diameter_1, hole_angle_1);
            };
            // translate([0, 0, norm(v)-l2]) cylinder(d=diameter, h=l2, $fn=fn);
            difference() {
                translate([0, 0, norm(v)-l2-l_in_2]) cylinder(d=diameter - 2*beam_wall_thickness, h=l_in_2, $fn=fn);
                drill_hole(norm(v)-l2, -l_in_2, -hole_distance_1, -hole_diameter_1, hole_angle_2);
            };          
		} else {
			translate([0, 0, l1]) cylinder(d=diameter - 2*beam_wall_thickness, h=l_in_1, $fn=fn);
			translate([0, 0, norm(v)-l2-l_in_2]) cylinder(d=diameter - 2*beam_wall_thickness, h=l_in_2, $fn=fn);
		}
            }
			// echo("length of beam: ", norm(v)-l1-l2);
            difference() {
                cylinder(d=diameter, h=norm(v), $fn=fn);
                translate([0, 0, -1]) cylinder(d=2*diameter, h=l1+1, $fn=fn);
                translate([0, 0, norm(v)-l2]) cylinder(d=2*diameter, h=l2+1, $fn=fn);
				if (drill_hole==1) {
					drill_hole(l1, l_in_1, hole_distance_1, hole_diameter_1, hole_angle_1);
					drill_hole(norm(v)-l2, -l_in_2, -hole_distance_1, -hole_diameter_1, hole_angle_2);
				}
            }
        }
	// extra rotation to avoid issues with CSG rendering
	translate(p0)
		multmatrix(rotate_from_to([0,0,1],v)) {
            color("blue") {
				cylinder(d=diameter, h=l1, $fn=fn);
				translate([0, 0, norm(v)-l2]) cylinder(d=diameter, h=l2, $fn=fn);
			}
		}
}

module joint(p0, diameter=beam_diameter, fn=default_joint_fn) {
    translate(p0) sphere(r=diameter/2, $fn=fn);
}

//beam_diameter = 32;
//default_beam_fn = 25;
//beam_wall_thickness = 2.1;
//default_beam_fn = 50;
//default_l = 20;
//default_l_in = 14;
//default_hole_diameter = 4;
//default_hole_distance = 5;
//beam([0, 0, 0], [100, 100, 100], hole_angle_1=0);