clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
lambda = [0 power(10,-4:3)];
for t=1:10
    minmodelerror = 100;
    optimallambda = 0;
    optimalW = 0;
    permutation = randperm(datasize);
    train_ind = permutation(1:floor(0.8*datasize));
    test_ind = permutation (ceil(0.8*datasize):length(permutation));
    training_data_indices(end+1,:) = train_ind;
    test_data_indices(end+1,:) = test_ind;
    train_data = data(train_ind,:);
    test_data  = data(test_ind,:);
    [norm_train_data, mean_train_data, std_train_data] = normalise(train_data);
    norm_test_data = normalise_with_mean(test_data, mean_train_data, std_train_data);
    for l=1:length(lambda)
        lamb = lambda(l);
        [modelerror,W] = perform_k_fold_validation(l, norm_train_data);
        if modelerror < minmodelerror
            minmodelerror = modelerror;
            optimalW = W;
            optimallambda = lamb;
        end
    end
    testerror = problem_5_b_estimate_error(optimallambda,)

end

