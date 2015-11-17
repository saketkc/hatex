function [g] = gaussian(X, mu, sigma)
    n = size(X,2);
    diff = bsxfun(@minus,X,mu);
    g = 1/(sqrt((2*pi)^n*det(sigma)))*exp(-0.5*sum(diff*inv(sigma).*diff,2));
end
