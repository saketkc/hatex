function [yerror] = kernel_linear_estimate_error(y,ypred)
yerror = (norm(y-ypred'))^2/length(y);
end
