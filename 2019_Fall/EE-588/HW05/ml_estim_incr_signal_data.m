clear all; close all;

% create problem data  
randn('state',0);
N = 100; 
% create an increasing input signal
xtrue = zeros(N,1);
xtrue(1:40) = 0.1;
xtrue(50) = 2;
xtrue(70:80) = 0.15;
xtrue(80) = 1;
xtrue = cumsum(xtrue);

% pass the increasing input through a moving-average filter 
% and add Gaussian noise
h = [1 -0.85 0.7 -0.3]; k = length(h);
yhat = conv(h,xtrue);
y = yhat(1:end-3) + randn(N,1);


cvx_begin
  variable x(N);
  yhat = conv(h, x);
  minimize (sum_square(yhat(1:end-3)-y))
  subject to
    x(1) >=0;
    x(1:N-1) <= x(2:N);
cvx_end

t = 1:N;
plot(t, xtrue, '--', t, x, 'r');
xlabel('t');
legend('xtrue', 'xhatml');
saveas(gcf, 'problem2.pdf');

