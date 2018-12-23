include <rear_wheel.scad>;
include <front_wheel.scad>;
include <rider.scad>;
include <seat.scad>;
include <steering_BB.scad>;
include <beam.scad>;
include <vector_operations.scad>;
include <cranks.scad>;

wheelbase = 950;
pivot_angle = 65;

////// Steering BB dimensions - Shimano Innenlager BB-UN26 Vierkant
BB_width = 110;
BB_shell_width = 68;
BB_shell_diameter = 34.8;

////// wheels
tire_width = 55;
rim_width = 25;
rim_diameter = 406;
rim_depth = 15;
rim_depth_extrusion = 10;
spokes = 20;
spoke_diameter = 5;
hub_diameter = 60;
hub_axle_diameter = 12;
rear_hub_width = 100;
front_hub_width = 130;

beam_diameter = 32;
default_beam_fn = 25;
joint_diameter = beam_diameter;
joint_distance = 2*joint_diameter; // radial distance from the wheel
default_joint_fn = 10;

seat_translation = [650, 0, -600];
seat_rotation = [0, 43, 180];

////// wheels
translate([-wheelbase/2, 0, 0]) rotate([90, 0, 0]) rear_wheel(hub_width=rear_hub_width);
translate([+wheelbase/2, 0, 0]) rotate([90, 0, 0]) {
    front_wheel(hub_width=front_hub_width); // to be changed to front wheel with sprockets
    color("red") translate([0, 0, 32]) cogset();
};

////// floor
* translate([0, 0, -rim_diameter/2-tire_width-100/2]) cube([wheelbase+rim_diameter+tire_width*2, 100, 100], center=true);

////// rider
* translate([710, 0, -600]) rotate([0, 45, 180]) rider(left_hip_angle=55, left_knee_angle=10, right_hip_angle=90, right_knee_angle=90);

////// maximum 3D printing volume
* translate([0, 0, 400]) cube([200, 200, 200], center=true);

////// seat
* translate(seat_translation) rotate(seat_rotation) seat();

////// steering bottom bracket
BB_distance_to_wheel = 60;

translate_1_xyz = [- rim_diameter/2 - tire_width/2 - BB_distance_to_wheel, 0, 0];
rotate_xyz = [0, -(90-pivot_angle), 0];
translate_2_xyz = [rim_diameter/2 + tire_width/2 + BB_distance_to_wheel + wheelbase/2 - (rim_diameter/2 + tire_width/2 + BB_distance_to_wheel), 0, 0];

translate(translate_2_xyz)
rotate(rotate_xyz)
translate(translate_1_xyz)
steering_BB(BB_width, BB_shell_width, BB_shell_diameter);

////// cycling bottom bracket and cranks
cycling_bracket_distance = wheelbase/2 + rim_diameter/2 + tire_width/2 + 140;
cycling_bracket_height = 100;

translate([cycling_bracket_distance, 0, cycling_bracket_height]) rotate([90, 0, 0]) {
    steering_BB(BB_width, BB_shell_width, BB_shell_diameter);
    color("blue") cranks(BB_shell_width+2);
}

////// rear frame: defining the points of the frame
rear_frame_width = rear_hub_width + joint_diameter;

// directly next to the rear wheel hub 
p_rear_hub_r = [-wheelbase/2, -rear_hub_width/2 - joint_diameter/2, 0]; joint(p_rear_hub_r);
p_rear_hub_l = [-wheelbase/2, +rear_hub_width/2 + joint_diameter/2, 0]; joint(p_rear_hub_l);

// recalculating the positions above and below the steering bottom bracket
p_bb_t = 
    v_translate(translate_2_xyz,
        v_rotate_y(
            v_translate(translate_1_xyz, [0, BB_width/2, 0]), +(90-pivot_angle)
            )
        ); * joint(p_bb_t);

p_bb_b = 
    v_translate(translate_2_xyz,
        v_rotate_y(
            v_translate(translate_1_xyz, [0, -BB_width/2, 0]), +(90-pivot_angle)
            )
        ); * joint(p_bb_b);

p_bb_l_t = [ p_bb_t.x - 30, +p_bb_t.y + joint_diameter, p_bb_t.z]; joint(p_bb_l_t);
p_bb_r_t = [ p_bb_t.x - 30, -p_bb_t.y - joint_diameter, p_bb_t.z]; joint(p_bb_r_t);
p_bb_l_b = [ p_bb_b.x - 30, +p_bb_b.y + joint_diameter, p_bb_b.z] + [0, 0, -10]; joint(p_bb_l_b);
p_bb_r_b = [ p_bb_b.x - 30, -p_bb_b.y - joint_diameter, p_bb_b.z] + [0, 0, -10]; joint(p_bb_r_b);

// the joints next to the rear wheel
p_rear_wheel_r_t = [-wheelbase/2 + rim_diameter/2 + tire_width/2 + joint_distance, -rear_hub_width/2 - joint_diameter/2, 0] + [10, 0, 0]; joint(p_rear_wheel_r_t);
p_rear_wheel_l_t = [-wheelbase/2 + rim_diameter/2 + tire_width/2 + joint_distance, +rear_hub_width/2 + joint_diameter/2, 0] + [10, 0, 0]; joint(p_rear_wheel_l_t);

p_rear_wheel_r_b = [-p_bb_b.x, p_bb_b.y, p_bb_r_b.z] + [0, -rear_frame_width/2, 0] + [10, 0, 0]; joint(p_rear_wheel_r_b);
p_rear_wheel_l_b = [-p_bb_b.x, p_bb_b.y, p_bb_l_b.z] + [0, +rear_frame_width/2, 0] + [10, 0, 0]; joint(p_rear_wheel_l_b);

// joints directly under the rider, i.e. at x=0
p_center_r_t = [0, -rear_frame_width/2+40, p_bb_r_t.z-30]; joint(p_center_r_t);
p_center_l_t = [0, +rear_frame_width/2-40, p_bb_l_t.z-30]; joint(p_center_l_t);
p_center_r_b = [0, -rear_frame_width/2+20, p_bb_r_b.z]; joint(p_center_r_b);
p_center_l_b = [0, +rear_frame_width/2-20, p_bb_l_b.z]; joint(p_center_l_b);

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

beam(p_rear_wheel_r_t, p_center_r_t);
beam(p_rear_wheel_l_t, p_center_l_t);
beam(p_center_r_t, p_center_l_t);
beam(p_rear_wheel_l_t, p_center_r_b);

beam(p_rear_wheel_r_b, p_center_r_b);
beam(p_rear_wheel_l_b, p_center_l_b);
beam(p_center_r_b, p_center_l_b);
beam(p_center_r_b, p_center_r_t);
beam(p_center_l_b, p_center_l_t);

beam(p_center_l_b, p_bb_l_b);
beam(p_center_l_t, p_bb_l_t);
beam(p_center_r_b, p_bb_r_b);
beam(p_center_r_t, p_bb_r_t);
beam(p_center_l_b, p_bb_r_t);

////// TODO: work out the details of the steering bottom bracket frame part

% beam(p_bb_r_b, p_bb_l_b);
% beam(p_bb_r_t, p_bb_l_t);
% beam(p_bb_l_b, p_bb_b);
% beam(p_bb_r_b, p_bb_b);
% beam(p_bb_l_t, p_bb_t);
% beam(p_bb_r_t, p_bb_t);

////// front frame: defining the points of the frame
front_frame_width = 90 + joint_diameter;
front_frame_width_ext = 70 + joint_diameter;

// directly next to the steering bottom bracket
p_bb_l_t_f = [ p_bb_t.x, +p_bb_t.y + joint_diameter, p_bb_t.z] + [+30, +10, -30]; joint(p_bb_l_t_f);
p_bb_r_t_f = [ p_bb_t.x, -p_bb_t.y - joint_diameter, p_bb_t.z] + [+30, -10, -30]; joint(p_bb_r_t_f);
p_bb_l_b_f = [ p_bb_b.x, +p_bb_b.y + joint_diameter, p_bb_b.z] + [0, +10, +40]; joint(p_bb_l_b_f);
p_bb_r_b_f = [ p_bb_b.x, -p_bb_b.y - joint_diameter, p_bb_b.z] + [0, -10, +40]; joint(p_bb_r_b_f);

// points connecting to the ones at the bottom bracket
p_fw_l_t = [ p_bb_t.x+100, front_frame_width/2, p_bb_t.z+50]; joint(p_fw_l_t);
p_fw_r_t = [ p_bb_t.x+100, -front_frame_width/2, p_bb_t.z+50]; joint(p_fw_r_t);
p_fw_l_b = [ p_bb_b.x+100, +front_frame_width/2, p_bb_b.z+40]; joint(p_fw_l_b);
p_fw_r_b = [ p_bb_b.x+100, -front_frame_width/2, p_bb_b.z+40]; joint(p_fw_r_b);

// next to the hub
p_front_hub_r = [+wheelbase/2, -front_hub_width/2 - joint_diameter/2, 0]; joint(p_front_hub_r);
p_front_hub_l = [+wheelbase/2, +front_hub_width/2 + joint_diameter/2, 0]; joint(p_front_hub_l);

// rider protection
p_rider_r_b = [+wheelbase/2 - (rim_diameter/2 + tire_width/2 + joint_distance), -front_frame_width_ext/2, 0] + [10, 0, 0]; joint(p_rider_r_b);
p_rider_l_b = [+wheelbase/2 - (rim_diameter/2 + tire_width/2 + joint_distance), +front_frame_width_ext/2, 0] + [10, 0, 0]; joint(p_rider_l_b);

p_rider_l_t = [+wheelbase/2, +front_frame_width_ext/2, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 135); joint(p_rider_l_t);
p_rider_r_t = [+wheelbase/2, -front_frame_width_ext/2, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 135); joint(p_rider_r_t);

// further to the cycling bottom bracket
p_cb_l_t = [+wheelbase/2, +front_frame_width_ext/2, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 65); joint(p_cb_l_t);
p_cb_r_t = [+wheelbase/2, -front_frame_width_ext/2, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 65); joint(p_cb_r_t);
p_cb_l_b = [+wheelbase/2 + rim_diameter/2 + tire_width/2, +front_frame_width/2 -10, +60]; joint(p_cb_l_b);
p_cb_r_b = [+wheelbase/2 + rim_diameter/2 + tire_width/2, -front_frame_width/2 +10, +60]; joint(p_cb_r_b);

// two narrower points before connecting to cyling bottom bracket
p_cbn_l = [+wheelbase/2, +front_frame_width_ext/2-30, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 40); joint(p_cbn_l);
p_cbn_r = [+wheelbase/2, -front_frame_width_ext/2+30, 0] + v_rotate_y([+wheelbase/2 - (rim_diameter/2 + tire_width/2 - joint_distance), 0, 0], 40); joint(p_cbn_r);

// connection to the cycling bottom bracket
p_cbb_l_t = [cycling_bracket_distance, +20, cycling_bracket_height+40]; joint(p_cbb_l_t);
p_cbb_r_t = [cycling_bracket_distance, -20, cycling_bracket_height+40]; joint(p_cbb_r_t);
p_cbb_l_c = [cycling_bracket_distance-70, +20, cycling_bracket_height-10]; joint(p_cbb_l_c);
p_cbb_r_c = [cycling_bracket_distance-70, -20, cycling_bracket_height-10]; joint(p_cbb_r_c);
p_cbb_l_b = [cycling_bracket_distance, +20, cycling_bracket_height-40]; joint(p_cbb_l_b);
p_cbb_r_b = [cycling_bracket_distance, -20, cycling_bracket_height-40]; joint(p_cbb_r_b);

// additional low-z beams
p_lowz_1_l = [ wheelbase/2 + rim_diameter/2, p_front_hub_l.y, p_fw_l_b.z ]; joint(p_lowz_1_l);
p_lowz_1_r = [ wheelbase/2 + rim_diameter/2, p_front_hub_r.y, p_fw_r_b.z ]; joint(p_lowz_1_r);
p_lowz_2_l = [ wheelbase/2 + rim_diameter/2 + 100, +20, p_fw_l_b.z ]; joint(p_lowz_2_l);
p_lowz_2_r = [ wheelbase/2 + rim_diameter/2 + 100, -20, p_fw_r_b.z ]; joint(p_lowz_2_r);

// connecting the dots
beam(p_bb_l_t_f, p_fw_l_t);
beam(p_bb_r_t_f, p_fw_r_t);
beam(p_bb_l_b_f, p_fw_l_b);
beam(p_bb_r_b_f, p_fw_r_b);
beam(p_bb_r_b_f, p_bb_l_b_f);
beam(p_bb_r_t_f, p_bb_l_t_f);

beam(p_fw_l_t, p_rider_l_b);
beam(p_fw_r_t, p_rider_r_b);
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

beam(p_cb_l_b, p_cbb_l_c);
beam(p_cb_r_b, p_cbb_r_c);

// would block the chain
// beam(p_cb_l_t, p_cb_l_b);
// beam(p_cb_r_t, p_cb_r_b);

// connecting everything to the front wheel hub
beam(p_front_hub_l, p_fw_l_b);
beam(p_front_hub_r, p_fw_r_b);

beam(p_front_hub_l, p_fw_l_t);
beam(p_front_hub_r, p_fw_r_t);

beam(p_front_hub_l, p_rider_l_t);
beam(p_front_hub_r, p_rider_r_t);

beam(p_front_hub_l, p_cb_l_t);
beam(p_front_hub_r, p_cb_r_t);

beam(p_front_hub_l, p_cb_l_b);
beam(p_front_hub_r, p_cb_r_b);

// beam(p_front_hub_l, p_fw_l_t);
// beam(p_front_hub_r, p_fw_r_t);

// beam(p_front_hub_l, p_cbb_l_c);
// beam(p_front_hub_r, p_cbb_r_c);

// low-z front part
beam(p_front_hub_l, p_lowz_1_l);
beam(p_front_hub_r, p_lowz_1_r);

beam(p_lowz_1_l, p_lowz_2_l);
beam(p_lowz_1_r, p_lowz_2_r);

beam(p_lowz_2_l, p_cbb_l_b);
beam(p_lowz_2_r, p_cbb_r_b);
beam(p_lowz_2_l, p_lowz_2_r);

beam(p_lowz_1_l, p_fw_l_b);
beam(p_lowz_1_r, p_fw_r_b);
