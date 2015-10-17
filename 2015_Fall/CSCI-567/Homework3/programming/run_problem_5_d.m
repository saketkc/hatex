clear all;
rng(1);
rows_X =100;
cols_X = 100;
[X,Y] = problem_5_a(rows_X, cols_X);
rows_X = size(X,1);
cols_X = size(X,2);
beta_matrix = [];
lambdas = [0.01,0.1,1,10];
biases = [];
vars = [];
mses =[];
for l=1:length(lambdas)
    beta_4 = [];
    lambda = lambdas(l);
    for i=1:rows_X
        beta_4(end+1,:) = estimate_beta_partd(3, l, X(i,:),Y(i,:)');
    end

    efx4 = efx(X,beta_4);
    bias4 = bias(beta_4,X,efx4);
    mse4 = mse(beta_4,X);
    var4 = variance(beta_4,X,efx4);
    mmse4 = mean(mse4);
    mvar4 = mean(var4);
    mbias4 = mean(bias4);
    biases(end+1) = mbias4;
    vars(end+1) = mvar4;
    mses(end+1) = mmse4;
    disp(sprintf('%f\t%f\t%f\t%f',lambda,mbias4,mvar4,mmse4));
end





