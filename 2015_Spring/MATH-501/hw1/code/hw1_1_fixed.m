function [x2,k] = hw1_1_fixed(gx,x0,delta,deltaf,M)
k=0;
shouldReturn=0;
x1=feval(gx,x0);
x2=feval(gx,x1);
%random choice of x2 starting with x1+2delta so
x1=x0;
while(abs(x2-x1)>=delta && abs(feval(gx,x2)-x2)>=deltaf && k<=M-1)
    x2temp=x2;
    x2=feval(gx,x1);
    x1=x2temp;
    k=k+1;

    %Set flag to return if this condition fails
    if (abs(feval(gx,x2)-x2)<deltaf)
        shouldReturn=1;
    end

    fprintf('Iteration : %d ||  x2 = %g || x1 = %g \n ', k, x2, x1); 
    if shouldReturn
        return
    end
end
