function [train_accu, test_data_labels, train_data_labels] = knn_decision_boundary(train_data, train_label, new_data, K)
new_data_size = size(new_data,1);
train_data_size = length(train_label);
% Standardise

mean_train_data = mean(train_data);
std_train_data = std(train_data);

standardise_new_data = bsxfun(@minus, new_data, mean_train_data );
standardise_new_data = bsxfun(@rdivide, standardise_new_data, std_train_data);

standardise_train_data = bsxfun(@minus, train_data, mean_train_data );
standardise_train_data = bsxfun(@rdivide, standardise_train_data, std_train_data);

test_label = [];
all_distances = {};
for i =1:new_data_size
    distances = [];
    sample = standardise_new_data(i,:);
    for j=1:train_data_size
        distances(end+1) = norm(sample-standardise_train_data(j,:));
    end
    %all_distances{i} = (distances);    
    [sorted idx] = sort(distances, 'ascend');
    indices= idx(1:K);
    pivot = sorted(K);
    k=K;
    if pivot == sorted(K+1)
        % search for all indices s
        while sorted(k+1) ~= pivot
            k=k+1;
            indices(end+1)=k;
        end
            
    end
    all_labels = [];
    for j=1:length(indices)
        all_labels(end+1) = train_label(indices(j));
    end
    test_label(end+1) = mode(all_labels);
    
end

test_data_labels = test_label;
%test_l = test_label;
new_accu=0;
train_accu = 0;

test_label = [];
all_distances = {};
for i =1:train_data_size
    distances = [];
    sample = standardise_train_data(i,:);
    for j=1:train_data_size
        if i ~= j
            distances(end+1) = norm(sample-standardise_train_data(j,:));
        end
    end
    all_distances{i} = distances;
end

for i=1:train_data_size
    distances = cell2mat(all_distances(i));
    [sorted idx] = sort(distances, 'ascend');
    indices= idx(1:K);
    pivot = sorted(K);
    k=K;
    if pivot == sorted(K+1)
        % search for all indices s
        while sorted(k+1) ~= pivot
            k=k+1;
            indices(end+1)=k;
        end
            
    end
    all_labels = [];
    for j=1:length(indices)
        all_labels(end+1) = train_label(indices(j));        
    end
    test_label(end+1) = mode(all_labels);
end

train_data_labels = test_label;
%train_l = test_label;
train_accu =0;
for  i=1:train_data_size
    if test_label(i) == train_label(i)
        train_accu = train_accu+1;
    end
end

train_accu = train_accu/(train_data_size-1);      


end