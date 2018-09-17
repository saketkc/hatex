function [ h ] = hessian( X_data, theta )
n = size(X_data,1);
p = size(X_data,2);
h = zeros(p,p);
for i=1:n       
    h = h + sigmoid(X_data(i,:)*theta) * ( 1-sigmoid(X_data(i,:)*theta) ) * X_data(i,:)'*X_data(i,:);
end
%h=1/n*h;
end


