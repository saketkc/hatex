function [ypred, ymodel] = kernel_poly(l,a,b,X,y)
n = size(X,1);
d = size(X,2);
K = X*X'+a;
K = K.^b;
cols_X = size(X,2);
ypred = y'*pinv(K+l*eye(n))*(X*X');%((X*X'a).^b);
ymodel = y'*pinv(K+l*eye(n))*X;
end
