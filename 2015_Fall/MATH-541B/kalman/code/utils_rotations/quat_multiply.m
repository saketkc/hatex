function quat = quat_multiply(lq, rq)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

%// quaternion entries in order: x, y, z, w
quat = zeros(4,1);

quat(1) = lq(4)*rq(1) + lq(1)*rq(4) + lq(2)*rq(3) - lq(3)*rq(2);
quat(2) = lq(4)*rq(2) - lq(1)*rq(3) + lq(2)*rq(4) + lq(3)*rq(1);
quat(3) = lq(4)*rq(3) + lq(1)*rq(2) - lq(2)*rq(1) + lq(3)*rq(4);
quat(4) = lq(4)*rq(4) - lq(1)*rq(1) - lq(2)*rq(2) - lq(3)*rq(3);


%quat = [lq(4)  -lq(3)  lq(2)  lq(3);
%	lq(3)      lq(4)   -lq(1) lq(2);
%	-lq(2)     lq(1)   lq(4)  lq(3);
%	 -lq(1)    -lq(2)  -lq(3)  lq(4);
%	 ] * rq;
 
return;
