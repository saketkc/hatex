format long g
fx = @(x) (atan(x));
fdashx = @(x) (1/(1+x*x));
x0 = 0.5


[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.3
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.4
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0 =1.35
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.375
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.3875
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.39375
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.390625
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)

x0=1.3921875
[c,i] = hw1_3_newton(fx,fdashx,x0,10e-10,10e-10,10e-10,20)
