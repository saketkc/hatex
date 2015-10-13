function [beta] = estimate_beta(p,x,y)
X = [];
beta = [];
%% x : Column vector
rows_X = size(x,1);
cols_X = size(x,2);
powers_X = 0:p-1;
for i=1:rows_X
    X(end+1,:) = power(x(i),powers_X);
end
%size(X)
%size(y)
beta = pinv(X'*X)*X'*y;
end
