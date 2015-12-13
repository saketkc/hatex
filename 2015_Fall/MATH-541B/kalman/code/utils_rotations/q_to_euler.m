function euler = q_to_euler(q)

     % Authors: Pieter Abbeel (pabbeel@cs.berkeley.edu)
     %          Adam Coates (acoates@cs.stanford.edu)

%    /** @brief Returns an equivalent euler angle representation of
%     * this quaternion.
%     * @return Euler angles in roll-pitch-yaw order.
%     */

mData = q;

my_epsilon = 1e-10;
euler = zeros(3,1);

%// quick conversion to Euler angles to give tilt to user
sqw = mData(4)*mData(4);
sqx = mData(1)*mData(1);
sqy = mData(2)*mData(2);
sqz = mData(3)*mData(3);

euler(2) = asin(2.0 * (mData(4)*mData(2) - mData(1)*mData(3)));
if (pi/2 - abs(euler(2)) > my_epsilon) 
	euler(3) = atan2(2.0 * (mData(1)*mData(2) + mData(4)*mData(3)),...
		sqx - sqy - sqz + sqw);
	euler(1) = atan2(2.0 * (mData(4)*mData(1) + mData(2)*mData(3)),...
		sqw - sqx - sqy + sqz);
else
	%	// compute heading from local 'down' vector
	euler(3) = atan2(2*mData(2)*mData(3) - 2*mData(1)*mData(4), ...
		2*mData(1)*mData(3) + 2*mData(2)*mData(4));
	euler(1) = 0.0;
        
	%        // If facing down, reverse yaw
	if (euler(2) < 0)
		euler(3) = pi - euler(3);
	end
end

