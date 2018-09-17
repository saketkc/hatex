function [b] = estimate_bias(y,w,x)
% w is column vector 1 x 10
fxhat = g(w,x);
b = (y-fxhat)'*(y-fxhat);
end
