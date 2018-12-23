function v_translate(v, object) = v + object;

function v_rotate_x(v, angle) = 
 [ [         0,           0, 1],
   [cos(angle), -sin(angle), 0],
   [sin(angle),  cos(angle), 0]   
] * v;

function v_rotate_y(v, angle) = 
 [ [cos(angle), -sin(angle), 0],
   [         0,           0, 1],
   [sin(angle),  cos(angle), 0]
] * v;

function v_rotate_z(v, angle) = 
 [ [cos(angle), -sin(angle), 0],
   [sin(angle),  cos(angle), 0],
   [         0,           0, 1]
] * v;


    