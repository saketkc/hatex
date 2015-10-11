function [f] = fx(x)
    epsilon = normrnd(0,0.1);
    f = 2*x*x'+epsilon;
end
