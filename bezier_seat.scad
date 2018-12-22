include <OpenScad_Surface_Solids/maths.scad>;
include <OpenScad_Surface_Solids/Renderer.scad>;

module seat() { translate([0,-6*s,0]) rotate([-90,0,90]) scale(4) linear_extrude_bezier([[[.7,-6,-1], [1,-6.5,-1.5], [2,-6.5,-1.5], [2.3,-6,-1]], [[0,-5,1], [1,-5,1], [2,-5,1], [3,-5,1]], [[0,-4,-.5], [1,-4,0], [2,-4,0], [3,-4,-.5]], [[0,0,0], [1,0.5,0.5], [2,0.5,0.5], [3,0,0]]], steps=10, thickness = 0.2*s);

translate([0,-6*s,0]) rotate([-120,0,90]) scale(4) linear_extrude_bezier([[[0.3,2.5,0.5], [1,3.5,0], [2,3.5,0], [2.7,2.5,0.5]], [[0,2,1], [1,2,1], [2,2,1], [3,2,1]], [[0,1,1], [1,1,1], [2,1,1], [3,1,1]], [[0,0,0], [1,0,.5], [2,0,.5], [3,0,0]]], steps=10, thickness = 0.25*s);
} 