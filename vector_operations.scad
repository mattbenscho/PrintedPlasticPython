// https://de.wikipedia.org/wiki/Drehmatrix

function v_rotate_y(v, angle) = 
 [ [cos(angle), 0, sin(angle)],
   [         0,           1, 0],
   [-sin(angle),  0, cos(angle)]
] * v;



    