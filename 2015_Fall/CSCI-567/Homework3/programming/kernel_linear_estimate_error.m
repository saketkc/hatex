function [yerror] = kernel_linear_estimate_error(w,X,y)
size(w);
size(X);
size(y);
ypred = w*X';
ypred = ypred';
yerror = (norm(y-ypred,2))^2/length(ypred);
end
