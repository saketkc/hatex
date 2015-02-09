function [x2,k] = hw1_4_secant(fx,x0,x1,delta,deltaf,M)
k=0;
shouldReturn=0;
fdashx = (feval(fx,x1)-feval(fx,x0))/(x1-x0);
fdashx = fdashx+delta;
x2=x1-feval(fx,x1)/fdashx;
%random choice of x2 starting with x1+2delta so

%x1=x0;
while(abs(x2-x1)>=delta && k<=M-1)
    x2temp=x2;
    fdashx = (feval(fx,x1)-feval(fx,x0))/(x1-x0);    
    x2=x1-feval(fx,x1)/fdashx;
    x1=x2temp;
    k=k+1;
    
    %Set flag to return if this condition fails
    if (abs(feval(fx,x2))<deltaf) 
        shouldReturn=1;
    end
    
    fprintf('Iteration : %d ||  x2 = %g || x1 = %g \n ', k, x2, x1); 
    if shouldReturn
        return
    end
end
        
    
    