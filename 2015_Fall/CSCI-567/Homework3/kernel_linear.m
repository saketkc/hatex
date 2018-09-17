function [w] = kernel_linear(l,X,y)
n = size(X,1);
d = size(X,2);
K = X*X';
cols_X = size(X,2);
w = y'*pinv(K+l*eye(n))*(X);
end
