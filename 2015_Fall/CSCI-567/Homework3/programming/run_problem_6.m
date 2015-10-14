clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
permutation = randperm(datasize);
train_ind = permutation(1:floor(0.8*datasize));
test_ind = permutation (ceil(0.8*datasize):length(permutation));
train_data = data(train_ind,:);
test_data  = data(test_ind,:);
[norm_train_data, mean_train_data, std_train_data] = normalise(train_data);
norm_test_data = normalise_with_mean(test_data, mean_train_data, std_train_data);

lambda = [0 power(10,-4:3)];

