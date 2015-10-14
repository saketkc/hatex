function [yerror] = kernel_linear_estimate_error(y,y_pred)
yerror = norm(y-ypred);
end
