clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
a = [-1, -0.5, 0, 0.5, 1];
b = [1, 2, 3, 4];
lambda = [0 power(10,-4:3)];
train_err =[];
test_err_6c = [];
optimal_lambdas_6c=[];
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

    for l=1:length(lambda)
        lamb = lambda(l);
        for p=1:length(a)
            pa = a(p);
            for q=1:length(b)
                qb = b(q);
                disp(sprintf('%d\t%d\t%d\t%d',t,lamb,pa,qb));
                [modelerror] = perform_k_fold_validation_poly(lamb,pa,qb, norm_train_data_appended);
                if modelerror < minmodelerror
                    minmodelerror = modelerror;
                    optimala = pa;
                    optimalb = qb;
                    optimallamb = lamb;
                end
            end
        end
    end
    cols = size(norm_train_data_appended,2);
    %ymodelerr = kernel_poly(optimallamb, optimala, optimalb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1));  
    %testerror = kernel_linear_estimate_error(newmodelw,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));
    [ypredtest] = kernel_poly_predict(optimallamb, optimala, optimalb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1), norm_test_data_appended(:,2:cols));
    [testerror] = kernel_poly_estimate_error(ypredtest, norm_test_data_appended(:,1));
    test_err_6c(end+1) = testerror;
    optimal_lambdas_6c(end+1) = optimallamb;
    optimal_a(end+1) = optimala;
    optimal_b(end+1) = optimalb;

    disp(sprintf('Optimal: %d\t%d\t%d',optimallamb,optimala,optimalb));

end

