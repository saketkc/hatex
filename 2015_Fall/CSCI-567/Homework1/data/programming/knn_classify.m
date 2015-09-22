function [new_accu, train_accu] = knn_classify(train_data, train_label, new_data, new_label, K)
new_data_size = length(new_label);
train_data_size = length(train_label);
% Standardise

mean_train_data = mean(train_data)
std_train_data = mean(train_data)

standardise_new_data = bsxfun(@minus, new_data, mean_train_data );
standardise_new_data = bsxfun(@rdivide, standardise_new_data, std_train_data);
%(new_data-mean_train_data)./std_train_data
%standardise_train_data = (new_data-mean_train_data)./std_train_data

standardise_train_data = bsxfun(@minus, new_data, mean_train_data );
standardise_train_data = bsxfun(@rdivide, standardise_train_data, std_train_data);

test_label = []
all_distances = {}
for i =1:new_data_size
    distances = []
    sample = standardise_new_data(i)
    for j=1:train_data_size
        distances(end+1) = norm(sample-standardise_train_data(j))
    end
    all_distances{i} = distances
end
        
new_accu = 1
train_accu = 1
end

% k-nearest neighbor classifier
% Input:
%  train_data: N*D matrix, each row as a sample and each column as a
%  feature
%  train_label: N*1 vector, each row as a label
%  new_data: M*D matrix, each row as a sample and each column as a
%  feature
%  new_label: M*1 vector, each row as a label
%  K: number of nearest neighbors
%
% Output:
%  new_accu: accuracy of classifying new_data
%  train_accu: accuracy of classifying train_data (using leave-one-out
%  strategy)
%
% CSCI 567: Machine Learning, Fall 2015, Homework 1
