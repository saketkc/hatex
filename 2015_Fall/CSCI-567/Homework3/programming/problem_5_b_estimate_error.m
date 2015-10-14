function [yerror] = problem_5_b_estimate_error(w,X,y)
ypred = X*w;
yerror = norm(y-ypred,2)/length(y);
end
