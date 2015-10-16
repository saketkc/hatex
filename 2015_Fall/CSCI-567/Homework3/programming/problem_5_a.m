function [X,Y] = problem_5_a(n,m)
%X,Y are 100*10 matrices
    X = [];
    Y= [];
    for i=1:n
        x = unifrnd(-1,1,1,m);
        X(end+1,1:m) = x;
        epsilon = normrnd(0,sqrt(0.1),1,m);
        Y(end+1,1:m) = fx(x)+epsilon;
    end
end
