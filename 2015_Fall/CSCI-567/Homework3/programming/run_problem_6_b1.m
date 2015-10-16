clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
sigma = [0.125, 0.25, 0.5, 1, 2, 4, 8];
lambda = [0 power(10,-4:3)];
train_err =[];
test_err = [];
optimal_sigmas=[];
optimal_lambdas=[];

for t=1:3
    minmodelerror = 100;
    optimalsigma = 0;
    optimalW = 0;
    optimallamb = 0;
    permutation = randperm(datasize);
    train_ind = permutation(1:floor(0.5*datasize));
    test_ind = permutation (ceil(0.5*datasize):length(permutation));
    training_data_indices(end+1,:) = train_ind;
    test_data_indices(end+1,:) = test_ind;
    train_data = data(train_ind,:);
    test_data  = data(test_ind,:);
    [norm_train_data, mean_train_data, std_train_data] = normalise(train_data);
    norm_test_data = normalise_with_mean(test_data, mean_train_data, std_train_data);
    norm_train_data(:,1) = train_data(:,1);
    norm_test_data(:,1) = test_data(:,1);
    norm_test_data_appended = norm_test_data(:,1);
    norm_test_data_appended(:,2) = ones(size(norm_test_data,1),1);
    norm_test_data_appended(:,3:size(norm_test_data,2)+1) = norm_test_data(:,2:size(norm_test_data,2));



    norm_train_data_appended = norm_train_data(:,1);
    norm_train_data_appended(:,2) = ones(size(norm_train_data,1),1);
    norm_train_data_appended(:,3:size(norm_train_data,2)+1) = norm_train_data(:,2:size(norm_train_data,2));

    for l=1:length(sigma)
        sigm = sigma(l);
        for k=1:length(lambda)
            lamb = lambda(k);
            [modelerror,W] = perform_k_fold_validation_rbf(sigm, lamb, norm_train_data_appended);
            %modelerror = kernel_linear_estimate_error(model,norm_train_data_appended(:,2:size(norm_train_data_appended,2)),norm_train_data_appended(:,1));
            disp(sprintf('%d\t%d\t%d\t%d\t%f',t,lamb,sigm,modelerror));
            if modelerror < minmodelerror
                minmodelerror = modelerror;
                optimalW = W;
                optimalsigma = sigm;
                optimallamb = lamb;
            end
        end
    end
    cols = size(norm_train_data_appended,2);
    newmodelw = kernel_rbf(optimalsigma, optimallamb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1));
    testerror = kernel_linear_estimate_error(newmodelw,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));
    test_err(end+1) = testerror;
    optimal_lambdas(end+1) = optimallamb;
    optimal_sigmas(end+1) = optimalsigma;

end

