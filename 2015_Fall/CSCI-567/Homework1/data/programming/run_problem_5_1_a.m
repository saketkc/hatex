load('hw1progde.mat');
H = [0.01,0.05,0.07,0.09,0.1,0.5];
for i=1:length(H)
    h = H(i);
    g_y = [];
    e_y= [];
    ht_y = [];    
    h_y= [];
    N_bins = ceil(1/h)+1;
    
    for j = 1:N_bins
        ht_y(end+1) = length(find( x_tr>=(j-1)*h & x_tr<(j*h) ))/(length(x_tr)*h);
    end
    
    for x = 0:0.001:1
        g_y(end+1) = problem_5_1_a(x,x_tr,h, 'gaussian');
        e_y(end+1) = problem_5_1_a(x,x_tr,h, 'epanechnikov');
        h_y(end+1) = ht_y(floor(x/h)+1);
        %h_y(end+1) = problem_5_1_a(x,x_tr,h, 'histogram');
    end
    plot(0:0.001:1,g_y,0:0.001:1,e_y, 0:0.001:1, h_y);
    legend('Gaussian Kernel','Epanechnikov kernel', 'Histogram');
    tl = sprintf('KDE for bandwidth h=%f',h);
    title(tl);
    print(tl, '-dpng');
    
    %%%%%%%%%%% Shuffle data
    
end
