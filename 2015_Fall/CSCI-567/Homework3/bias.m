function [b1] = bias(b,X,efx)
rows_X = size(X,1);
cols_X = size(X,2);
b1 = [];
for i=1:rows_X 
    b1(end+1) = mean((fx(X(i,:))-efx(i,:)))^2;
end
