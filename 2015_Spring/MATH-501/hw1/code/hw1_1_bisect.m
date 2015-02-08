function [c,i] = hw1_1_bisect(fx, a, b, delta)
    i=0;
    format long g;
    shouldReturn=0;
    fprintf('\n')
    while (b-a>=2*(delta))
        c = (a+b)/2;
        i = i+1;  
           
        if (abs(feval(fx,c))<delta)
            shouldReturn=1;
        elseif (feval(fx,c)*feval(fx,b)<0)
            a=c;
        elseif (feval(fx,a)*feval(fx,c)<0)
            b=c;
        end

        fprintf('Iteration : %d || a = %g || b = %g || x* = %g || b+a/2= %g || f=%g\n ', i, a, b, c,(b+a)/2, atan((a+b)/2))   
        if (shouldReturn==1)
            return
        end
        
    end
