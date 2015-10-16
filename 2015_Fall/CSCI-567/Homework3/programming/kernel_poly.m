function [ypred] = kernel_poly(l,a,b,X,y)
%size(X)
%size(y)
n = size(X,1);
d = size(X,2);

%K = zeros(n);
%for i=1:n
%    for j=1:n
%        K(i,j) = X(i,:)*X(j,:)';
%    end
%endii
K = X*X'+a;
K = K.^b;
cols_X = size(X,2);
ypred = y'*pinv(K+l*eye(n))*(X*X');%((X*X'a).^b);
end
