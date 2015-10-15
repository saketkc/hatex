function [yerror] = kernel_linear_estimate_error(y,ypred)
yerror = norm(y-ypred')/length(y);
end
