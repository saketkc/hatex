function vout = express_vector_in_quat_frame(vin, q)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

vout = rotate_vector(vin, [-q(1:3); q(4)]);
