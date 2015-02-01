function [x2,k] = hw1_3_newton(fx,fdashx,x0,delta,deltaf,deltafdash,M)
k=0;
shouldReturn=0;
x1=x0-feval(fx,x0)/feval(fdashx,x0);
x2=x1-feval(fx,x1)/feval(fdashx,x1);
%random choice of x2 starting with x1+2delta so
x1=x0;
while(abs(x2-x1)>=delta && k<=M-1)
    x2temp=x2;
    x2=x1-feval(fx,x1)/feval(fdashx,x1);
    x1=x2temp;
    k=k+1;
    
    %Set flag to return if this condition fails
    if (abs(feval(fx,x2))<deltaf || abs(feval(fdashx,x2))<deltafdash) 
        shouldReturn=1;
    end
    
    fprintf('Iteration : %d ||  x2 = %f || x1 = %f \n ', k, x2, x1); 
    if shouldReturn
        return
    end
end
        
    
    