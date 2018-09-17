format long g
fx = @(x) (atan(x));
x0=0.5
x1=1

[c,i] = hw1_4_secant(fx,x0,x1,10e-10,10e-10,20)

x0=1
x1=1.3
[c,i] = hw1_4_secant(fx,x0,x1,10e-10,10e-10,20)

x0=1.4
x1=1.5
[c,i] = hw1_4_secant(fx,x0,x1,10e-10,10e-10,20)



x0=10
x1=11
[c,i] = hw1_4_secant(fx,x0,x1,10e-10,10e-10,20)
