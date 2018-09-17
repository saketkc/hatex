function [X,Y] = problem_5_a(n)
%X,Y are 100*10 matrices
    X = [];
    Y= [];
    for i=1:n
        x = unifrnd(-1,1,1,10);
        X(end+1,1:10) = x;
        epsilon = normrnd(0,sqrt(0.1),1,10);
        Y(end+1,1:10) = fx(x)+epsilon;
    end
end
