function [ypredict, ymodel] = kernel_rbf(sigma,l,X,y)
n = size(X,1);
s = X*X';
s = s/sigma;
d = diag(s);
s = s-ones(n,1)*d'/2;
s = s-d*ones(1,n)/2;
s=2*s;
K = exp(s);
ymodel  = y'*pinv(K+l*eye(n));%*X');
ypredict = ymodel*(K);
end
