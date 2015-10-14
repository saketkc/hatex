function [w] = kernel_linear(l,X,y)
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
K = X*X';
cols_X = size(X,2);
w = y'*pinv(K+l*eye(n))*(X);%*X');
end
