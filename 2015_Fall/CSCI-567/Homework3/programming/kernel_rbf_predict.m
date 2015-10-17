function [ypredict,k] = kernel_rbf_predict(sigma,l,X,y,Xtest)
n = size(X,1);
s = X*X';
s = s/sigma;
d = diag(s);
s = s-ones(n,1)*d'/2;
s = s-d*ones(1,n)/2;
s=2*s;

K = exp(s);

%s1 = X*Xtest';
%s1= s1/sigma;
%size(s1)%
%d=diag(s1);
%size(d)
%m = size(Xtest,1);
%s1 = s1-ones(m,1)*d'/2;
%s1 = s1-d*ones(1,m)/2;
%s1=2*s1;
s1 = pdist2(X,Xtest);
s1 = s1.^2;
s1 = -s1./sigma;
k = exp(s1);
ypredict = y'*pinv(K+l*eye(n))*(k);%*X');
end

