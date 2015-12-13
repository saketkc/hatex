function dx = compute_dx(xtarget, x)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

dx = x - xtarget;

dx(end-3:end) = quat_multiply([-1; -1; -1; 1].*xtarget(end-3:end), x(end-3:end));

dx(end) = 1;


