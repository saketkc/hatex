function [varx] = variance(b,X,ef)
rows_X = size(X,1);
cols_X = size(X,2);
var1=0;
errx=0;
for i=1:rows_X
    for j=1:cols_X
        x= X(i,j);
        errx = errx+(g(b(i,:),x)-ef(i,j))^2;
    end
end
varx = errx/(cols_X*rows_X);
end
