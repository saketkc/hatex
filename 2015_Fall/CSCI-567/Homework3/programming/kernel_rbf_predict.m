function [ypredict,k] = kernel_rbf_predict(sigma,l,X,Xtest)
n = size(X,1);
s = X*X';
s = s/sigma;
d = diag(s);
s = s-ones(n,1)*d'/2;
s = s-d*ones(1,n)/2;
s=2*s;
%s =pdist2(X,X);
%s = -s/sigma;

K = exp(s);

s1 = X*Xtest';
s1= s1/sigma;
d=diag(s1);
s1 = s1-ones(n,1)*d'/2;
s1 = s1-d*ones(1,n)/2;
s1=2*s1;
ypredict = y'*pinv(K+l*eye(n))*(s1);%*X');
end

