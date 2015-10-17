clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
lambda = [0 power(10,-4:3)];
train_err =[];
test_err = [];
optimal_lambdas=[];
for t=1:3
    minmodelerror = 100;
    optimallambda = 0;
    optimalW = 0;
    [norm_train_data_appended, norm_test_data_appended] = getdata(data);
    cols = size(norm_train_data_appended,2);

    for l=1:length(lambda)
        lamb = lambda(l);
        lamb;
        [modelerror,W] = perform_k_fold_validation(lamb, norm_train_data_appended);
        if modelerror < minmodelerror
            minmodelerror = modelerror;
            optimalW = W;
            optimallambda = lamb;
        end
    end
    cols = size(norm_train_data_appended,2);
    newmodelw = problem_5_b(optimallambda, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1));
    testerror = problem_5_b_estimate_error(newmodelw,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));
    test_err(end+1) = testerror;
    optimal_lambdas(end+1) = optimallambda;
end

disp('-------------------------------------------');
disp(sprintf('t\tOptimal lambda\tError'));
for t=1:3
    disp(sprintf('%d\t%f\t%f',t,optimal_lambdas(t),test_err(t)))
end
disp('-------------------------------------------');
disp('-------------------------------------------');
disp(sprintf('Mean test error: %f', mean(test_err)));
disp('-------------------------------------------');
