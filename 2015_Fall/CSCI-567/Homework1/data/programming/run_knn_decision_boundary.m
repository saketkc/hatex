load('hw1boundary.mat');
%new_data = unifrnd(0,1,100,100);
new_x = linspace(0,1,100);
new_y = linspace(0,1,100);
new_data =  [];%[new_x; new_y];
for i=1:length(new_x)
    x = new_x(i);
    for j=1:length(new_y)
        y= new_y(j);
        new_data(end+1,:) = [x,y];
    end
end

KKK=[1,5,15,25];
for i=1:4    
    k=KKK(i);
    [train_accu, test_data_labels, train_data_labels] = knn_decision_boundary(features, labels, new_data, KKK(i));
    
    pluses = new_data(test_data_labels == 1,:);
    minuses = new_data(test_data_labels == -1,:);
    plot(pluses(:,1),pluses(:,2),'r+', minuses(:,1),minuses(:,2),'b^');
    xlabel('X');
    ylabel('Y');
    title(sprintf('k=%f',k));
    textstr = sprintf('boundary_k%f',k);
    print(textstr, '-dpng')

end
