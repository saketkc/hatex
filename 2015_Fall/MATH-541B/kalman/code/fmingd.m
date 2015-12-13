function [M,Y] = fmingd(fun, M_init, stepsize, alpha)

X0 = M_init

Y = zeros(1,20);

max_iters = 100;
bestY = 16000;
tstart = tic;
for iters = 1:max_iters 
    iters
    Y0 = fun(X0)
    if(Y0 > bestY)
        X0 = best;
        Y0 = bestY;
        alpha = 0.8*alpha
    else
        best = X0;
        bestY = Y0;
    end
    
    M(:,:,iters) = X0;
    Y(iters) = Y0;
    
    save('ms.mat','M','Y');
    G = zeros(size(M_init));
    
    for i = 1:numel(M_init)
        d = zeros(size(M_init));
        d(i) = stepsize;
        X1 = X0 + d;
        Y1 = fun(X1);
        G(i) = (Y1-Y0)/stepsize;
    end
    
    X0 = X0 - alpha*G
    
    dt = toc(tstart);
    etr = (dt/iters)*(max_iters-iters);
    fprintf('ETR: %d:%02.1f\n', floor(etr/60), mod(etr,60));
end
    

end
