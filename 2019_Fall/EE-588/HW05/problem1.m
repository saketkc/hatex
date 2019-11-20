nonlin_meas_data;
r = zeros(1,m);
r(1) = -1;
r(2) = 1;

c = zeros(1,m-1);
c(1) = -1;
Ydiff = toeplitz(c,r);


cvx_begin 
    variable x(n);
    variable w(m);
    minimize (norm(w-A*x,2));
    subject to
	1/beta*Ydiff*y<=Ydiff*w;
	Ydiff*w <= 1/alpha*Ydiff*y;
cvx_end

disp(x);
plot(w,y);
xlabel('w');
ylabel('y');
title('ML estimate');
saveas(gcf, 'problem1.pdf');


