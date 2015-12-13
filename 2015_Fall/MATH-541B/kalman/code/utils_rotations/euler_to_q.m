function q = euler_to_q(euler)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

c1 = cos(euler(3) * 0.5);
c2 = cos(euler(2) * 0.5);
c3 = cos(euler(1) * 0.5);
s1 = sin(euler(3) * 0.5);
s2 = sin(euler(2) * 0.5);
s3 = sin(euler(1) * 0.5);

q = zeros(4,1);

q(1,1) = c1*c2*s3 - s1*s2*c3;
q(2,1) = c1*s2*c3 + s1*c2*s3;
q(3,1) = s1*c2*c3 - c1*s2*s3;
q(4,1) = c1*c2*c3 + s1*s2*s3;



