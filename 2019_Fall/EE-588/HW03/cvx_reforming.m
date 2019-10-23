cvx_begin
	variables x y u z v
	x == 0;
	y == 0;
	square_pos( square( x + y ) ) <= x - y
	inv_pos(x)+inv_pos(y)<=1
	norm( [ u ; v ] ) <= 3*x + y;
	max( x , 1 ) <= u;
	max( y , 2 ) <= v;
	x >= inv_pos(y);
	x >= 0;
	y >= 0;
	quad_over_lin(x + y , sqrt(y)) <= x - y + 5;
	pow_pos(x,3) + pow_pos(y,3) <= 1;
	x+z <= 1+geo_mean([x-quad_over_lin(z,y),y])
cvx_end

