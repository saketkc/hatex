function [g] = function g(w,x)
    l = length(w);
    powers = 0:l-1;
    g =  w*power(w,x)
end
