function [s] = problem_5_1_a(x, XI, h, kernel_type)
s=0;
l=length(XI);

if  strcmp(kernel_type, 'gaussian')
        for i=1:l            
            xi = XI(i);           
            u = (x-xi)/h;
            e = (1/sqrt(2*pi))*exp(-u*u/2);
            s=s+e;
        end
end
        
if strcmp(kernel_type, 'epanechnikov')
        for i=1:l            
            xi = XI(i);           
            u = (x-xi)/h;            
            if abs(u)<=1
                s=s+(3/4)*(1-u*u);
            end
        end
end

if strcmp(kernel_type,'uniform')
        for i=1:l
            xi = XI(i);
            u = (x-xi)/h; 
            if abs(u)<=1
                s=s+0.5;
            end
        end
end
s = s/(l*h);      
end