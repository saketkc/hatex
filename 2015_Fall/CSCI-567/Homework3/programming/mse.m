function [mse1] = mse(b,X)
rows_X = size(X,1);
cols_X = size(X,2);
mse1 = [];
for i=1:rows_X 
    mse1(end+1) = mean((g(b(i,:),X(i,:))-fx(X(i,:)')).^2);%/(rows_X*cols_X);
end
