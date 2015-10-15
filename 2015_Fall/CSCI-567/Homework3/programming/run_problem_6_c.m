clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
a = [−1, −0.5, 0, 0.5, 1];
c = [1, 2, 3, 4];
lambda = [0 power(10,-4:3)];
train_err =[];
test_err = [];
optimal_sigmas=[];
optimal_lambdas=[];
optimal_a=[];
optimal_b=[];
for t=1:10
    minmodelerror = 100;
    optimallamb = 0;
    optimala = 0;
    optimalb = 0;
    permutation = randperm(datasize);
    train_ind = permutation(1:floor(0.8*datasize));
    test_ind = permutation (ceil(0.8*datasize):length(permutation));
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
            [modelerror,W] = perform_k_fold_validation_poly(sigm, lamb, norm_train_data_appended);
            modelerror
            if modelerror < minmodelerror
                minmodelerror = modelerror;
                optimalW = W;
                optimala = a;
                optimalb = b;
                optimallamb = lamb;
            end
            optimalsigma ;
        end
    end
    cols = size(norm_train_data_appended,2);
    %ymodelerr = kernel_poly(optimallamb, optimala, optimalb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1));  
    %testerror = kernel_linear_estimate_error(newmodelw,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));
    [ypredtest] = kernel_poly_predict(optimallambda, a,b, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1), norm_test_data_appended(:,2:cols));%, training_data(:,1));
    [testerror] = kernel_poly_estimate_error(ypredtest, norm_train_data_appended(:,1));
    test_err(end+1) = testerror;
    optimal_lambdas(end+1) = optimallamb;
    optimal_a(end+1) = optimala;
    optimal_b(end+1) = optimalb;

end

