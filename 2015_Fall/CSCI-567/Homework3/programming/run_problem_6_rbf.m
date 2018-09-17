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
   [norm_train_data_appended, norm_test_data_appended] = getdata(data);
    cols = size(norm_train_data_appended,2);

    for l=1:length(sigma)
        sigm = sigma(l);
        for k=1:length(lambda)
            lamb = lambda(k);
            [modelerror] = perform_k_fold_validation_rbf(sigm, lamb, norm_train_data_appended);
            %disp(sprintf('%d\t%d\t%d\t%d\t%f',t,lamb,sigm,modelerror));
            if modelerror < minmodelerror
                minmodelerror = modelerror;
                optimalsigma = sigm;
                optimallamb = lamb;
            end
        end
    end
    [ypredtest] = kernel_rbf_predict(optimalsigma, optimallamb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1), norm_test_data_appended(:,2:cols));
    [testerror] = kernel_poly_estimate_error(ypredtest, norm_test_data_appended(:,1));
    test_err(end+1) = testerror;
    optimal_lambdas(end+1) = optimallamb;
    optimal_sigmas(end+1) = optimalsigma;

end

disp('-------------------------------------------');
disp(sprintf('t\tOptimal lambda\tOptimal Sigma2\tError'));
for t=1:3
    disp(sprintf('%d\t%f\t%f\t%f',t,optimal_lambdas(t),optimal_sigmas(t), test_err(t)))
end
disp('-------------------------------------------');
disp('-------------------------------------------');
disp(sprintf('Mean test error: %f', mean(test_err)));
disp('-------------------------------------------');
