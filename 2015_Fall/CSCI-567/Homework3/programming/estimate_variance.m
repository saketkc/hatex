function [v] = estimate_variance(w,x)
gx = g(w,x)';
v = (fx(x)-gx)*(fx(x)-gx)';
end
