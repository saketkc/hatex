function [varx] = variance(b,X,ef)
rows_X = size(X,1);
cols_X = size(X,2);
varx=0;
errx=0;
%for i=1:rows_X
%    for j=1:cols_X
%        x= X(i,j);
%        errx = errx+(g(b(i,:),x)-ef(i,j))^2;
%    end
%end

%varx = errx/(cols_X*rows_X);
for i=1:rows_X 
    varx(end+1) = mean( (g(b(i,:),X(i,:))-ef(i,:)').^2 );
end

end
