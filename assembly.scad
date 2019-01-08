include <rear_wheel.scad>;
include <front_wheel.scad>;
include <rider.scad>;
include <seat.scad>;
include <steering_BB.scad>;
include <beam.scad>;
include <vector_operations.scad>;
include <cranks.scad>;
include <heim_joint.scad>;
include <heim_joint_thru_axle.scad>;
include <ortlieb_pannier.scad>;

wheelbase = 930; // 20"
// wheelbase = 1200; // 26"
pivot_angle = 60;
steering_angle = 0;

////// BB dimensions - Shimano Innenlager BB-UN26 Vierkant
BB_width = 110;
BB_shell_width = 68;
BB_shell_diameter = 34.8;

////// heim joint parameter
heim_spacing = 120;
heim_axis_offset = 135;

////// wheels
tire_width = 55;
rim_width = 25;
rim_diameter = 406; // 20"
// rim_diameter = 559; // 26"
rim_depth = 15;
rim_depth_extrusion = 10;
spokes = 20;
spoke_diameter = 5;
hub_diameter = 60;
hub_axle_diameter = 12;
rear_hub_width = 100;
front_hub_width = 130;

////// beam parameters
beam_diameter = 32;
default_beam_fn = 25;
beam_wall_thickness = 2.1;
default_beam_fn = 20;
default_l = 20;
default_l_in = 14;
default_hole_diameter = 4;
default_hole_distance = 5;
joint_diameter = beam_diameter;
joint_distance = 2*joint_diameter; // radial distance from the wheel
default_joint_fn = 10;

////// seat
seat_translation = [850, 0, -350];
seat_rotation = [0, 58, 180];

////// bagpack
// * cube([300, 150, 500]);

////// TODO: handle for bicycle bag on rear frame
* translate([-500, +200, -50]) rotate([0, 0, 0]) ortlieb_pannier();
* translate([-500, -200, -50]) rotate([0, 0, 180]) ortlieb_pannier();

////// rear frame
rear_frame_ground_clearance = 80;
rear_frame_bottom_z = -(rim_diameter/2 - rear_frame_ground_clearance - beam_diameter/2);

////// front frame
front_frame_ground_clearance = 80;
front_frame_bottom_z = -(rim_diameter/2 - front_frame_ground_clearance - beam_diameter/2);

////// brakes
brake_offset = 27; // see brake manual

////// floor
translate([0, 0, -rim_diameter/2-tire_width-100/2]) cube([wheelbase+rim_diameter+tire_width*2, 100, 100], center=true);

////// rider
* translate(seat_translation) rotate(seat_rotation) rider(left_hip_angle=48, left_knee_angle=10, right_hip_angle=80, right_knee_angle=90, left_arm_angle=180, right_arm_angle=230);

////// maximum 3D printing volume
* translate([0, 0, 400]) cube([200, 200, 200], center=true);

////// seat
* translate(seat_translation) rotate(seat_rotation) seat();

////// wheels
translate([-wheelbase/2, 0, 0]) rotate([90, 0, 0]) rear_wheel(hub_width=rear_hub_width, rim_diameter=rim_diameter);

// translate(+(translate_1_xyz + translate_2_xyz))
// rotate([0, -(90-pivot_angle), 0]) rotate([0, 0, steering_angle]) rotate([0, +(90-pivot_angle), 0])
// translate(-(translate_1_xyz + translate_2_xyz))

translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
rotate([0, 0, steering_angle])
translate(-translate_1_xyz)
rotate(-rotate_xyz)
translate(-translate_2_xyz)

translate([+wheelbase/2, 0, 0]) rotate([90, 0, 0]) {
    front_wheel(hub_width=front_hub_width, rim_diameter=rim_diameter);
    translate([0, 0, 32]) cogset();
};



//////// pivot
pivot_distance_to_wheel = 60;
//
translate_1_xyz = [- (rim_diameter/2 + tire_width/2 + pivot_distance_to_wheel), 0, 0];
rotate_xyz = [0, pivot_angle-90, 0];
translate_2_xyz = [ -translate_1_xyz.x + wheelbase/2 - (rim_diameter/2 + tire_width/2 + pivot_distance_to_wheel), 0, 0];
//
//translate(translate_2_xyz)
//rotate(rotate_xyz)
//translate(translate_1_xyz)
//steering_BB(BB_width, BB_shell_width, BB_shell_diameter);

////// heim joint
* translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
heim_joint(spacing=heim_spacing, axis_offset = heim_axis_offset);

translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
heim_joint_thru_axle(spacing=heim_spacing, axis_offset = heim_axis_offset);

////// cycling bottom bracket and cranks
cycling_bracket_distance = wheelbase/2 + rim_diameter/2 + tire_width/2 + 140;
cycling_bracket_height = 200;

translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
rotate([0, 0, steering_angle])
translate(-translate_1_xyz)
rotate(-rotate_xyz)
translate(-translate_2_xyz)
translate([cycling_bracket_distance, 0, cycling_bracket_height]) rotate([90, 0, 0]) {
    steering_BB(BB_width, BB_shell_width, BB_shell_diameter);
    cranks(bracket_width=BB_shell_width+2, crank_angle=210);
}

////// rear frame: defining the points of the frame
rear_frame_width = rear_hub_width + joint_diameter;

// directly next to the rear wheel hub 
p_rear_hub_r = [-wheelbase/2, -rear_hub_width/2 - joint_diameter/2, 0]; * joint(p_rear_hub_r);
p_rear_hub_l = [-wheelbase/2, +rear_hub_width/2 + joint_diameter/2, 0]; * joint(p_rear_hub_l);
        
p_hj_t = translate_2_xyz + v_rotate_y(translate_1_xyz + [ -50, 0, +heim_spacing/2 + heim_axis_offset], pivot_angle-90);

p_hj_b = translate_2_xyz + v_rotate_y(translate_1_xyz + [ -50, 0, -heim_spacing/2 + heim_axis_offset], pivot_angle-90);

p_hj_l_t = p_hj_t + [0, 20, 0]; * joint(p_hj_l_t);
p_hj_r_t = p_hj_t + [0, -20, 0]; * joint(p_hj_r_t);
p_hj_l_b = p_hj_b + [0, 20, 0]; * joint(p_hj_l_b);
p_hj_r_b = p_hj_b + [0, -20, 0]; * joint(p_hj_r_b);

// the joints next to the rear wheel
p_rear_wheel_l_t = [-wheelbase/2 + rim_diameter/2 + tire_width/2 + joint_distance, +rear_hub_width/2 + joint_diameter/2, 20]; * joint(p_rear_wheel_l_t);
p_rear_wheel_r_t = [-wheelbase/2 + rim_diameter/2 + tire_width/2 + joint_distance, -rear_hub_width/2 - joint_diameter/2, 20]; * joint(p_rear_wheel_r_t);

p_rear_wheel_r_b = [p_rear_wheel_r_t.x - 10, p_hj_b.y, rear_frame_bottom_z] + [0, -rear_frame_width/2, 0]; * joint(p_rear_wheel_r_b);
p_rear_wheel_l_b = [p_rear_wheel_l_t.x - 10, p_hj_b.y, rear_frame_bottom_z] + [0, +rear_frame_width/2, 0]; * joint(p_rear_wheel_l_b);

// joints directly under the rider, i.e. at x=0; 4 points for the top part
// p_center_1_r_t = [-50, -rear_frame_width/2-50, 0]; joint(p_center_1_r_t);
// p_center_1_l_t = [-50, +rear_frame_width/2+50, 0]; joint(p_center_1_l_t);
p_center_1_l_t = [+50, +rear_frame_width/2+50, 30]; * joint(p_center_1_l_t);
p_center_1_r_t = [+50, -rear_frame_width/2-50, 30]; * joint(p_center_1_r_t);

// p_center_2_r_t = [+50, -rear_frame_width/2-50, 10]; joint(p_center_2_r_t);
// p_center_2_l_t = [+50, +rear_frame_width/2+50, 10]; joint(p_center_2_l_t);
p_center_r_b = [30, -rear_frame_width/2-0, rear_frame_bottom_z]; * joint(p_center_r_b);
p_center_l_b = [30, +rear_frame_width/2+0, rear_frame_bottom_z]; * joint(p_center_l_b);

seat_points_l = [
    [p_center_1_l_t.x +120, rear_frame_width/2-20, p_center_1_l_t.z],
    [p_center_1_l_t.x +50, rear_frame_width/2+50, p_center_1_l_t.z-30],
    [p_center_1_l_t.x -90, rear_frame_width/2, p_center_1_l_t.z+80],
    [p_center_1_l_t.x -190, rear_frame_width/2, p_center_1_l_t.z+200],
    [p_center_1_l_t.x -300, rear_frame_width/2+20, p_center_1_l_t.z+300],
    [p_center_1_l_t.x -390, rear_frame_width/2, p_center_1_l_t.z+400]
];

seat_points_translation = [20, 0, 20];
seat_points_rotation = [0, -17, 0];

// calculate the points of the seats after the rotation and translation and store in the array sp_calc
sp_calc = [
    for (i=[0:len(seat_points_l)-1]) [
        seat_points_translation + v_rotate_y(seat_points_l[i], seat_points_rotation.y),
        seat_points_translation + v_rotate_y(seat_points_l[i] + [0, -2*seat_points_l[i].y, 0], seat_points_rotation.y)
    ]
];
    
sp_list = concat([ for (i=[0, 1]) sp_calc[i]], [[p_center_1_l_t, p_center_1_r_t]], [ for (i=[2:len(sp_calc)-1]) sp_calc[i]]);    

// generating beams for the seat
for(i=[0:len(sp_list)-1]) {
    * color("pink") {
        joint(sp_list[i][0]);
        joint(sp_list[i][1]);        
    }
    // color("green") {
		if (i<len(sp_list)-1) {
			beam(sp_list[i][0], sp_list[i+1][0]);
			beam(sp_list[i][1], sp_list[i+1][1]);
			if (i>1) {
				beam(sp_list[i][0], sp_list[i][1]);
				beam(sp_list[i][0], sp_list[i+1][1]);
			};
		}
    // }
};

// connecting the last two joints
beam(sp_list[len(sp_list)-1][0], sp_list[len(sp_list)-1][1]);

// extra joints for the butt
p_butt_l = sp_list[1][0] + [0, -60, 0]; joint(p_butt_l);
p_butt_r = sp_list[1][1] + [0, +60, 0]; joint(p_butt_r);

p_rear_brake_l = [-wheelbase/2, 0, 0] + v_rotate_y([ rim_diameter/2 - brake_offset, +rear_frame_width/2, 0], -62); * joint(p_rear_brake_l);
p_rear_brake_r = [-wheelbase/2, 0, 0] + v_rotate_y([ rim_diameter/2 - brake_offset, -rear_frame_width/2, 0], -62); * joint(p_rear_brake_r);

////// support for the pannier 
pannier_l = [-wheelbase/2 - 130, rear_frame_width/2, sp_list[5][0].z]; * joint(pannier_l);
pannier_r = [-wheelbase/2 - 130, -rear_frame_width/2, sp_list[5][1].z]; * joint(pannier_r);
p_pannier_l = [-wheelbase/2, 0, 0] + v_rotate_y([ -(rim_diameter/2 + tire_width/2 + joint_distance), +rear_frame_width/2, 0], 75); * joint(p_pannier_l);
p_pannier_r = [-wheelbase/2, 0, 0] + v_rotate_y([ -(rim_diameter/2 + tire_width/2 + joint_distance), -rear_frame_width/2, 0], 75); * joint(p_pannier_r);

beam(p_rear_hub_l, p_pannier_l);
beam(p_rear_hub_r, p_pannier_r);
beam(p_pannier_l, sp_list[6][0]);
beam(p_pannier_r, sp_list[6][1]);
beam(p_pannier_l, sp_list[5][0]);
beam(p_pannier_r, sp_list[5][1]);
beam(p_pannier_l, p_pannier_r);

////// rear frame: connecting the joints with beams
beam(p_rear_hub_r, p_rear_wheel_r_t);
beam(p_rear_hub_l, p_rear_wheel_l_t);
beam(p_rear_wheel_l_t, p_rear_wheel_r_t);

beam(p_rear_hub_r, p_rear_wheel_r_b);
beam(p_rear_hub_l, p_rear_wheel_l_b);
beam(p_rear_wheel_l_b, p_rear_wheel_r_b);
beam(p_rear_wheel_l_b, p_rear_wheel_r_t);
beam(p_rear_wheel_l_b, p_rear_wheel_l_t);
beam(p_rear_wheel_r_b, p_rear_wheel_r_t);

beam(p_rear_wheel_r_t, p_center_1_r_t);
beam(p_rear_wheel_l_t, p_center_1_l_t);
beam(p_rear_wheel_r_b, p_center_1_l_t);
beam(p_rear_wheel_l_b, p_center_r_b);

beam(p_rear_wheel_r_b, p_center_r_b);
beam(p_rear_wheel_l_b, p_center_l_b);
beam(p_center_r_b, p_center_l_b);
beam(p_center_r_b, p_center_1_r_t);
beam(p_center_l_b, p_center_1_l_t);

beam(p_center_l_b, p_hj_l_b);
beam(p_center_r_b, p_hj_r_b);

beam(p_hj_l_b, p_hj_l_t);
beam(p_hj_r_b, p_hj_r_t);

beam(p_hj_l_t, p_center_l_b);
beam(p_hj_r_t, p_center_r_b);

beam(p_center_1_l_t, p_hj_l_b);
beam(p_center_1_r_t, p_hj_r_b);

////// seat

// beams for the butt
beam(p_butt_l, sp_list[0][0]);
beam(p_butt_r, sp_list[0][1]);
beam(p_butt_l, sp_list[1][0]);
beam(p_butt_r, sp_list[1][1]);
beam(p_butt_l, p_hj_l_t);
beam(p_butt_r, p_hj_r_t);

// seat connection to rear wheel top joints
beam(p_rear_wheel_l_t, sp_list[3][0]);
beam(p_rear_wheel_l_t, sp_list[4][0]);
beam(p_rear_wheel_r_t, sp_list[3][1]);
beam(p_rear_wheel_r_t, sp_list[4][1]);

////// brake joint connections
beam(p_rear_brake_l, sp_list[4][0]);
beam(p_rear_brake_l, sp_list[5][0]);
// beam(p_rear_brake_l, sp_list[6][0]);
beam(p_rear_brake_l, p_rear_hub_l);
beam(p_rear_brake_l, p_rear_wheel_l_t);
beam(p_rear_brake_r, sp_list[4][1]);
beam(p_rear_brake_r, sp_list[5][1]);
// beam(p_rear_brake_r, sp_list[6][1]);
beam(p_rear_brake_r, p_rear_hub_r);
beam(p_rear_brake_r, p_rear_wheel_r_t);



////// front frame: defining the points of the frame
front_frame_width = 90 + joint_diameter;
front_frame_width_ext = 70 + joint_diameter;

// next to the hub
p_front_hub_r = [+wheelbase/2, -front_hub_width/2 - joint_diameter/2, 0]; * joint(p_front_hub_r);
p_front_hub_l = [+wheelbase/2, +front_hub_width/2 + joint_diameter/2, 0]; * joint(p_front_hub_l);

// directly next to the heim joint
p_hj_f_t = translate_2_xyz + v_rotate_y(translate_1_xyz + [ 0, 0, +heim_spacing/2 + heim_axis_offset - beam_diameter/2 - 10], pivot_angle-90);

p_hj_f_c = translate_2_xyz + v_rotate_y(translate_1_xyz + [ 0, 0, -heim_spacing/2 + heim_axis_offset - beam_diameter/2 + 39], pivot_angle-90); joint(p_hj_f_c);

p_hj_f_b = translate_2_xyz + v_rotate_y(translate_1_xyz + [ 0, 0, -heim_spacing/2 + heim_axis_offset - beam_diameter/2 - 10], pivot_angle-90);

// points connecting to the ones at the bottom bracket
// p_fw_l_t = [ p_hj_t.x+100, front_frame_width/2, p_hj_t.z+20]; * joint(p_fw_l_t);
// p_fw_r_t = [ p_hj_t.x+100, -front_frame_width/2, p_hj_t.z+20]; * joint(p_fw_r_t);
p_fw_l_t = [ p_hj_t.x+100, p_front_hub_l.y, p_hj_t.z]; * joint(p_fw_l_t);
p_fw_r_t = [ p_hj_t.x+100, p_front_hub_r.y, p_hj_t.z]; * joint(p_fw_r_t);

p_fw_l_b = [ p_hj_b.x+100, p_front_hub_l.y, front_frame_bottom_z]; * joint(p_fw_l_b);
p_fw_r_b = [ p_hj_b.x+100, p_front_hub_r.y, front_frame_bottom_z]; * joint(p_fw_r_b);

// rider protection
// p_rider_r_b = [+wheelbase/2 - (rim_diameter/2 + tire_width/2 + joint_distance), -front_frame_width_ext/2, p_hj_f_r_t.z + 80] + [10, 0, 0]; * joint(p_rider_r_b);
// p_rider_l_b = [+wheelbase/2 - (rim_diameter/2 + tire_width/2 + joint_distance), +front_frame_width_ext/2, p_hj_f_l_t.z + 80] + [10, 0, 0]; * joint(p_rider_l_b);

p_rider_l_b = [+wheelbase/2, +front_frame_width_ext/2, 0] + v_rotate_y([ - (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 30); * joint(p_rider_l_b);
p_rider_r_b = [+wheelbase/2, -front_frame_width_ext/2, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 30); * joint(p_rider_r_b);

p_rider_l_t = [+wheelbase/2, +front_frame_width_ext/2, 0] + v_rotate_y([ - (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 65); * joint(p_rider_l_t);
p_rider_r_t = [+wheelbase/2, -front_frame_width_ext/2, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 65); * joint(p_rider_r_t);

// joints for cantilever sockets
p_front_brake_l = [+wheelbase/2, 0, 0]
	+ v_rotate_y([ rim_diameter/2 - brake_offset, +front_frame_width/2, 0], 210); * joint(p_front_brake_l);
p_front_brake_r = [+wheelbase/2, 0, 0]
	+ v_rotate_y([ rim_diameter/2 - brake_offset, -front_frame_width/2, 0], 210); * joint(p_front_brake_r);

// further to the cycling bottom bracket
p_cb_l_t = [+wheelbase/2, +front_frame_width_ext/2, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 115); * joint(p_cb_l_t);
p_cb_r_t = [+wheelbase/2, -front_frame_width_ext/2, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 115); * joint(p_cb_r_t);
// probably not enough space to fit
// p_cb_l_b = [+wheelbase/2 + rim_diameter/2 + tire_width/2, +front_frame_width/2 -10, +60]; # joint(p_cb_l_b);
// p_cb_r_b = [+wheelbase/2 + rim_diameter/2 + tire_width/2, -front_frame_width/2 +10, +60]; # joint(p_cb_r_b);

// two narrower points before connecting to cyling bottom bracket
p_cbn_l = [ p_cb_l_t.x+80, +front_frame_width_ext/2-30, p_cb_l_t.z]; * joint(p_cbn_l);
p_cbn_r = [ p_cb_r_t.x+80, -front_frame_width_ext/2+30, p_cb_r_t.z]; * joint(p_cbn_r);

// connection to the cycling bottom bracket
p_cbb_l_t = [cycling_bracket_distance, +20, cycling_bracket_height+40]; * joint(p_cbb_l_t);
p_cbb_r_t = [cycling_bracket_distance, -20, cycling_bracket_height+40]; * joint(p_cbb_r_t);
// probably not enough space to fit
// p_cbb_l_c = [cycling_bracket_distance-70, +20, cycling_bracket_height-10]; * joint(p_cbb_l_c);
// p_cbb_r_c = [cycling_bracket_distance-70, -20, cycling_bracket_height-10]; * joint(p_cbb_r_c);
p_cbb_l_b = [cycling_bracket_distance, +20, cycling_bracket_height-40]; * joint(p_cbb_l_b);
p_cbb_r_b = [cycling_bracket_distance, -20, cycling_bracket_height-40]; * joint(p_cbb_r_b);

// additional low-z beams
p_lowz_1_l = [ wheelbase/2 + rim_diameter/2, p_front_hub_l.y, p_fw_l_b.z ]; * joint(p_lowz_1_l);
p_lowz_1_r = [ wheelbase/2 + rim_diameter/2, p_front_hub_r.y, p_fw_r_b.z ]; * joint(p_lowz_1_r);
p_lowz_2_l = [+wheelbase/2, +front_frame_width_ext/2-30, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 190); * joint(p_lowz_2_l);
p_lowz_2_r = [+wheelbase/2, -front_frame_width_ext/2+30, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 190); * joint(p_lowz_2_r);
p_lowz_3_l = [+wheelbase/2, +front_frame_width_ext/2-30, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 170); * joint(p_lowz_3_l);
p_lowz_3_r = [+wheelbase/2, -front_frame_width_ext/2+30, 0] + v_rotate_y([- (rim_diameter/2 + tire_width/2 + joint_distance), 0, 0], 170); * joint(p_lowz_3_r);
// p_lowz_2_l = [ wheelbase/2 + rim_diameter/2 + 100, +20, p_fw_l_b.z ]; * joint(p_lowz_2_l);
// p_lowz_2_r = [ wheelbase/2 + rim_diameter/2 + 100, -20, p_fw_r_b.z ]; * joint(p_lowz_2_r);

// connecting the dots
translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
rotate([0, 0, steering_angle])
translate(-translate_1_xyz)
rotate(-rotate_xyz)
translate(-translate_2_xyz)
{
beam(p_hj_f_t, p_fw_l_t);
beam(p_hj_f_t, p_fw_r_t);
beam(p_hj_f_c, p_fw_l_t);
beam(p_hj_f_c, p_fw_r_t);
beam(p_hj_f_t, p_hj_f_c);

beam(p_hj_f_b, p_fw_l_b);
beam(p_hj_f_b, p_fw_r_b);

beam(p_fw_l_t, p_fw_l_b);
beam(p_fw_r_t, p_fw_r_b);	

// hooking up the joint for the cantilever sockets
beam(p_front_brake_l, p_rider_l_b);
beam(p_front_brake_r, p_rider_r_b);
beam(p_front_brake_l, p_front_hub_l);
beam(p_front_brake_r, p_front_hub_r);
beam(p_front_brake_l, p_fw_l_t);
beam(p_front_brake_r, p_fw_r_t);

beam(p_rider_l_b, p_rider_r_b);
beam(p_rider_l_b, p_rider_l_t);
beam(p_rider_r_b, p_rider_r_t);
beam(p_rider_l_t, p_rider_r_t);

beam(p_rider_l_t, p_cb_l_t);
beam(p_rider_r_t, p_cb_r_t);
beam(p_cb_l_t, p_cb_r_t);

beam(p_cb_l_t, p_cbn_l);
beam(p_cb_r_t, p_cbn_r);

beam(p_cbn_l, p_cbb_l_t);
beam(p_cbn_r, p_cbb_r_t);
beam(p_cbn_l, p_cbn_r);

// beam(p_fw_l_b, p_cb_l_b);
// beam(p_fw_r_b, p_cb_r_b);

// probably not enough space to fit
// beam(p_cb_l_b, p_cbb_l_c);
// beam(p_cb_r_b, p_cbb_r_c);

// connecting everything to the front wheel hub
beam(p_front_hub_l, p_fw_l_b);
beam(p_front_hub_r, p_fw_r_b);

beam(p_front_hub_l, p_fw_l_t);
beam(p_front_hub_r, p_fw_r_t);

beam(p_front_hub_l, p_rider_l_t);
beam(p_front_hub_r, p_rider_r_t);

beam(p_front_hub_l, p_cb_l_t);
beam(p_front_hub_r, p_cb_r_t);

// probably not enough space to fit
// beam(p_front_hub_l, p_cb_l_b);
// beam(p_front_hub_r, p_cb_r_b);

// beam(p_front_hub_l, p_fw_l_t);
// beam(p_front_hub_r, p_fw_r_t);

// beam(p_front_hub_l, p_cbb_l_c);
// beam(p_front_hub_r, p_cbb_r_c);

// low-z front part
beam(p_front_hub_l, p_lowz_1_l);
beam(p_front_hub_r, p_lowz_1_r);

beam(p_lowz_1_l, p_lowz_2_l);
beam(p_lowz_1_r, p_lowz_2_r);

beam(p_lowz_2_l, p_lowz_3_l);
beam(p_lowz_2_r, p_lowz_3_r);
beam(p_lowz_2_l, p_lowz_2_r);

beam(p_lowz_3_l, p_cbb_l_b);
beam(p_lowz_3_r, p_cbb_r_b);
beam(p_lowz_3_l, p_lowz_3_r);

beam(p_lowz_3_l, p_cbn_l);
beam(p_lowz_3_r, p_cbn_r);

// only works if using thru axles, otherwise mounting the wheel becomes hard when using dropouts
beam(p_lowz_1_l, p_fw_l_b);
beam(p_lowz_1_r, p_fw_r_b);
}
