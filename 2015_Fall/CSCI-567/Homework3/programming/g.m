function [gx] = g(w,x)
    l = length(w);
    powers = 0:l-1;
    power_X = [];
    x=x';
    for i=1:length(x)
        power_X(end+1,:)  = power(x(i), powers);
    end
    gx =  power_X*w';
end
