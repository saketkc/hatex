%format long g
fx = @(x) (x/2+1/(2*x))
x0=1.1
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=2
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=5
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=10
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

x0=50
[c,i] = hw1_1_fixed(fx,x0,0.01,10e-6,10)

