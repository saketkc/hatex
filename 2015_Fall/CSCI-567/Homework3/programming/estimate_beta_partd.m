function [beta] = estimate_beta(p,l,x,y)
X = [];
beta = [];
%% x : Column vector
rows_X = size(x,1);
cols_X = size(x,2);
powers_X = 0:p-1;
for i=1:cols_X
    X(end+1,:) = power(x(i),powers_X);
end
beta = pinv(X'*X+l*eye(rows_X))*X'*y;
end
