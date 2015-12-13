function quat = quaternion_from_axis_rotation(axis_rotation)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

rotation_angle = norm(axis_rotation);
quat = zeros(4,1);

if(rotation_angle < 1e-4)  % avoid division by zero -- also: can use simpler computation in this case, since for small angles sin(x) = x is a good approximation
	quat(1:3) = axis_rotation/2;
else
	normalized_axis = axis_rotation / rotation_angle;
	quat(1:3) = normalized_axis * sin(rotation_angle/2);
end
quat(4) = sqrt(1 - norm(quat(1:3),2)^2);
return;



