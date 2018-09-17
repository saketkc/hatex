format long g
fx = @(x) (atan(x));
x0=0.5;
x1=1;
[c,i] = hw1_4_secant(fx,x0,x1,10e-10,10e-10,20)


