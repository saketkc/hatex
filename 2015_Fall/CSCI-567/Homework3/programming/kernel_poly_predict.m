function [ypred] = kernel_poly_predict(l,a,b,X,y,Xtest)
n = size(X,1);
d = size(X,2);
K = X*X'+a;
K = K.^b;
cols_X = size(X,2);
yy = (X*Xtest'+a).^b;
ypred = y'*pinv(K+l*eye(n))*yy;
end
