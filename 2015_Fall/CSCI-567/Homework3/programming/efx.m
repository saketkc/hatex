function [efx1] = efx(X,b) 
rows_X = size(X,1);
cols_X = size(X,2);
efx1 = zeros(rows_X, cols_X);
for i=1:rows_X
    for j=1:cols_X
        x = X(i,j);
        efx=0;
        for k=1:rows_X
            efx = efx+g(b(k,:),x);
        end
        efx1(i,j) = efx/rows_X;
    end
end
end
