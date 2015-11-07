function [beta] = problem_5_b(l,X,y)
%size(X)
%size(y)
cols_X = size(X,2);
beta = inv(X'*X+l*eye(cols_X))*X'*y;
end
