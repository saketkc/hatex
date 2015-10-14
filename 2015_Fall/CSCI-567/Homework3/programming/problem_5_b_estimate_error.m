function [yerror] = problem_5_b_estimate_error(w,X,y)
ypred = w'*X;
yerror = norm(y-ypred);
end
