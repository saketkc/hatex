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

for t=1:10
    minmodelerror = 100;
    optimallambda = 0;
    optimalW = 0;
   [norm_train_data_appeneded, norm_test_data_appeneded] = getdata(data);

    for l=1:length(lambda)
        lamb = lambda(l);
        lamb;
        [modelerror,W] = perform_k_fold_validation_linear(lamb, norm_train_data_appended);
        modelerror
        if modelerror < minmodelerror
            minmodelerror = modelerror;
            optimalW = W;
            optimallambda = lamb;
        end
        optimallambda ;
    end
    cols = size(norm_train_data_appended,2);
    newmodelw = kernel_linear(optimallambda, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1));
    testerror = kernel_linear_estimate_error(newmodelw,norm_test_data_appended(:,2:size(norm_test_data_appended,2)),norm_test_data_appended(:,1));

end

