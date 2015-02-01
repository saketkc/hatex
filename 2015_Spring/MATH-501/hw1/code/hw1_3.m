%format long g
fx = @(x) (exp(x)+x);
fdashx = @(x) (exp(x)+1);
[c,i] = hw1_3_newton(fx,fdashx,0,0.01,10e-8,10e-8,100)
