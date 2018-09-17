clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
training_data_indices = [];
test_data_indices = [];
lambda = [0 power(10,-4:3)];
optimal_lambdas =[];
test_err = [];

for t=1:3
    minmodelerror = 100;
    optimallambda = 0;
    optimalW = 0;
    [norm_train_data_appended, norm_test_data_appended] = getdata(data);
    cols = size(norm_train_data_appended,2);
   % disp(sprintf('Lambda\tError'))
    for l=1:length(lambda)
        lamb = lambda(l);
        [modelerror,W] = perform_k_fold_validation_linear(lamb, norm_train_data_appended);
        %disp(sprintf('%f\t%f',lamb, modelerror))
        if modelerror < minmodelerror
            minmodelerror = modelerror;
            optimalW = W;
            optimallambda = lamb;
        end
    end
    optimal_lambdas(end+1) = optimallambda;
    disp(sprintf('Optimal lambda: %f', optimallambda));
    testerror = kernel_linear_estimate_error(optimalW,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));
    disp(sprintf('Test err: %f', testerror));
    test_err(end+1) = testerror;
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
