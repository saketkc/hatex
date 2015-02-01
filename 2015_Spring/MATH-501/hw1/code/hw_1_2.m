%format long g
fx = @(x) (x-atan(x));
[c,i] = hw1_1_fixed(fx,5,0.01,10e-6,100)
