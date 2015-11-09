function [ypred] = kernel_poly_predict(l,a,b,X,y,Xtest)
n = size(X,1);
d = size(X,2);
%n
%d
K = X*X'+a;
K = K.^b;
yy = (X*Xtest'+a);
yy= yy.^b;
ypred = y'*pinv(K+l*eye(n))*yy;
end
