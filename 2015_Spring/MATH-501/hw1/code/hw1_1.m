format long g
fx = @(x) atan(x);
[c,i] = hw1_1_bisect(fx,-4.9,5.1,0.01)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-4)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-8)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-16)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-32)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-64)
[c,i] = hw1_1_bisect(fx,-4.9,5.1,10e-128)
