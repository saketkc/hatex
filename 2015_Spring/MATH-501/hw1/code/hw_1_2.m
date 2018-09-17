%format long g
fx = @(x) (x-atan(x));i
x0=5
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=-5
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=1
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=-1
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=0.1
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)
