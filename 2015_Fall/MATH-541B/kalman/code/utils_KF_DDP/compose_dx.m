function x1 = compose_dx(x0, dx)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

x1 = x0 + dx;

x0(end-3:end) = x0(end-3:end)/norm(x0(end-3:end));
quat0 = x0(end-3:end);
dq = [dx(end-3:end-1); sqrt(1-(norm(dx(end-3:end-1),2))^2)];
x1(end-3:end) = quat_multiply(quat0, dq);
