function [K] = poly_poly(a,b,X)
n = size(X,1);
d = size(X,2);
K = X*X'+a;
K = K.^b;
end
