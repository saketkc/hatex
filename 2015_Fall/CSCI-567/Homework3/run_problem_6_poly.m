clear all;
data = dlmread('space.tsv');
rng(1);
datasize = size(data,1);
indices = 1:datasize;
a = [-1, -0.5, 0, 0.5, 1];
b = [1, 2, 3, 4];
lambda = [0 power(10,-4:3)];
test_err = [];
optimal_lambdas=[];
optimal_a=[];
optimal_b=[];
for t=1:3
    minmodelerror = 100;
    optimallamb = 0;
    optimala = 0;
    optimalb = 0;
   [norm_train_data_appended, norm_test_data_appended] = getdata(data);
    cols = size(norm_train_data_appended,2);
    disp(sprintf('t\tlambda\ta\tb\terror'));
    for l=1:length(lambda)
        lamb = lambda(l);
        for p=1:length(a)
            pa = a(p);
            for q=1:length(b)
                qb = b(q);
                [modelerror] = perform_k_fold_validation_poly(lamb,pa,qb, norm_train_data_appended);
                disp(sprintf('%d\t%d\t%d\t%d\t%f',t,lamb,pa,qb,modelerror));
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
    [ypredtest] = kernel_poly_predict(optimallamb, optimala, optimalb, norm_train_data_appended(:,2:cols), norm_train_data_appended(:,1), norm_test_data_appended(:,2:cols));
    [testerror] = kernel_poly_estimate_error(ypredtest, norm_test_data_appended(:,1));
    test_err(end+1) = testerror;
    optimal_lambdas(end+1) = optimallamb;
    optimal_a(end+1) = optimala;
    optimal_b(end+1) = optimalb;

    disp('-------------------------------------------');
    disp(sprintf('Optimal: %d\t%d\t%d',optimallamb,optimala,optimalb));
    disp('-------------------------------------------');

end

disp('-------------------------------------------');
disp(sprintf('t\tOptimal lambda\tOptimal a\tOptimal b\tError'));
for t=1:3
    disp(sprintf('%d\t%f\t%f\t%f',t,optimal_lambdas(t),optimal_a(t), optimal_b(t), test_err(t)))
end
disp('-------------------------------------------');
disp('-------------------------------------------');
disp(sprintf('Mean test error: %f', mean(test_err)));
disp('-------------------------------------------');
