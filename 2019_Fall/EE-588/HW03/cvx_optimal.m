A = [1 2 0 1;
     0 0 3 1;
     0 3 1 1;
     2 1 2 5;
     1 0 3 2];
cmax = [100; 100; 100; 100; 100];

p = [3; 2; 7; 6];
pdisc = [2; 1; 4; 2];
q = [4; 10 ;5; 10];

cvx_begin
	variable x(4)
	maximize( sum(min(p.*x,p.*q+pdisc.*(x-q))) )
	subject to
		x >= 0;
		A*x <= cmax
cvx_end

x
r = min(p.*x,p.*q+pdisc.*(x-q))
revenue = sum(r)
avg_price_per_unit = r./x
