function [w] = kernel_rbf(sigma,l,X,y)
n = size(X,1);
s = X*X';
s = s/sigma^2;
d = diag(s);
s = s-ones(n,1)*d'/2;
s = s-d*ones(1,n)/2;
k = exp(s);

w = y'*pinv(k+l*eye(n))*(X);%*X');
end

