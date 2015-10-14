function [yerror] = problem_5_b_estimate_error(w,X,y)
size(w);
size(X);
size(y);
ypred = X*w;
yerror = norm(y-ypred);
end
